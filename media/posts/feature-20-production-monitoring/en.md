---
title: "Production monitoring on Kubernetes"
date: 2026-04-01
category: "Dev Log"
tags: [Kubernetes, Prometheus, Grafana, Loki, Promtail, Helm, monitoring, OVH, nginx-ingress]
locale: en
---

The monitoring stack that had been running locally on Docker Compose landed on the production Kubernetes cluster (OVH Managed Kubernetes). Prometheus, Grafana, Loki and Promtail — the same set, but installed via Helm and accessible externally under dedicated subdomains.

## Installation via Helm

Locally the stack started through `docker-compose.yml` with manual configuration. On Kubernetes I used two Helm charts:

```bash
helm install kube-prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  -f k8s/helm-values/kube-prometheus-stack-values.yaml

helm install loki grafana/loki-stack \
  -n monitoring \
  -f k8s/helm-values/loki-stack-values.yaml
```

`kube-prometheus-stack` installs Prometheus, Grafana, Alertmanager, node-exporter and kube-state-metrics. `loki-stack` adds Loki and Promtail as a DaemonSet on every node.

## Promtail and containerd

The first configuration mounted `/var/lib/docker/containers` — the standard path for Docker. OVH Managed Kubernetes uses containerd, and logs go to `/var/log/pods/`.

Promtail started but found no log files. The fix required three changes:

```yaml
# loki-stack-values.yaml
promtail:
  extraVolumes:
    - name: pods
      hostPath:
        path: /var/log/pods
  extraVolumeMounts:
    - name: pods
      mountPath: /var/log/pods
      readOnly: true
  config:
    snippets:
      scrapeConfigs: |
        - job_name: kubernetes-pods
          kubernetes_sd_configs:
            - role: pod
          pipeline_stages:
            - cri: {}
          relabel_configs:
            - source_labels:
                - __meta_kubernetes_pod_uid
                - __meta_kubernetes_pod_container_name
              separator: /
              replacement: /var/log/pods/*$1/$2/*.log
              target_label: __path__
```

Key elements: `pipeline_stages: - cri: {}` parses the containerd log format (not Docker JSON), and the relabel using `__meta_kubernetes_pod_uid` builds the path `/var/log/pods/*/uid/container/*.log`.

## nginx-ingress metrics

On local dev I monitored Traefik as the reverse proxy. In production, traffic flows through the nginx-ingress controller. By default it did not expose detailed HTTP metrics.

Enabling them required two steps: adding the `--enable-metrics=true` flag and port 10254 to the deployment, then creating a Service and ServiceMonitor:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: ingress-nginx
  namespace: monitoring
  labels:
    release: kube-prometheus
spec:
  namespaceSelector:
    matchNames:
      - ingress-nginx
  selector:
    matchLabels:
      app.kubernetes.io/name: ingress-nginx
  endpoints:
    - port: metrics
      interval: 15s
```

The `release: kube-prometheus` label is required — Prometheus Operator filters ServiceMonitors by this label.

## External access

Both panels are available under dedicated subdomains with TLS (Let's Encrypt via cert-manager):

- `grafana.borowski.services` — Grafana with login
- `prometheus.borowski.services` — Prometheus UI

Initially I protected access with an IP whitelist via an nginx annotation:

```yaml
nginx.ingress.kubernetes.io/whitelist-source-range: "79.186.58.130/32"
```

It did not work. The OVH load balancer performs SNAT — nginx saw the load balancer's IP (`146.59.117.234`), not the real client IP. Attempting to enable proxy protocol broke connections (the LB does not send it). The solution: basic auth instead of a whitelist.

```yaml
nginx.ingress.kubernetes.io/auth-type: basic
nginx.ingress.kubernetes.io/auth-secret: monitoring-basic-auth
nginx.ingress.kubernetes.io/auth-realm: "Monitoring"
```

The `monitoring-basic-auth` secret was generated with `htpasswd`. Grafana has its own login on top — a double layer.

## Dashboards

Dashboards are loaded automatically by the Grafana sidecar. A ConfigMap with the `grafana_dashboard=1` label is detected and imported without a restart:

- **Portfolio Services Dashboard** — request rate, latency (p50/p95/p99), error rate and Loki logs
- **Loki Logs — Portfolio** — log browser with filtering by namespace, pod and container

Queries were rewritten from Traefik to nginx-ingress (`nginx_ingress_controller_requests` instead of `traefik_service_requests_total`). Dashboard configuration details are covered in a separate article.

## Versions

- `infra` → `v0.1.0` (new minor: production monitoring, cert-manager, nginx configs, basic auth)
