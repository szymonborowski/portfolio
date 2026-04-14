---
title: "Monitoring produkcyjny na Kubernetes"
date: 2026-04-01
category: "Dev Log"
tags: [Kubernetes, Prometheus, Grafana, Loki, Promtail, Helm, monitoring, OVH, nginx-ingress]
locale: pl
---

Stos monitoringu, który do tej pory działał lokalnie na Docker Compose, wylądował na produkcyjnym klastrze Kubernetes (OVH Managed Kubernetes). Prometheus, Grafana, Loki i Promtail — ten sam zestaw, ale zainstalowany przez Helm i dostępny z zewnątrz pod własnymi subdomenami.

## Instalacja przez Helm

Lokalnie stos startował przez `docker-compose.yml` z ręczną konfiguracją. Na Kubernetes użyłem dwóch chartów Helm:

```bash
helm install kube-prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  -f k8s/helm-values/kube-prometheus-stack-values.yaml

helm install loki grafana/loki-stack \
  -n monitoring \
  -f k8s/helm-values/loki-stack-values.yaml
```

`kube-prometheus-stack` instaluje Prometheus, Grafanę, Alertmanager, node-exporter i kube-state-metrics. `loki-stack` dodaje Loki i Promtail jako DaemonSet na każdym node.

## Promtail i containerd

Pierwsza wersja konfiguracji montowała `/var/lib/docker/containers` — standardowa ścieżka dla Dockera. OVH Managed Kubernetes używa containerd, a logi trafiają do `/var/log/pods/`.

Promtail startował, ale nie znajdował żadnych plików logów. Fix wymagał trzech zmian:

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

Kluczowe elementy: `pipeline_stages: - cri: {}` parsuje format logów containerd (nie Docker JSON), a relabel z `__meta_kubernetes_pod_uid` buduje ścieżkę `/var/log/pods/*/uid/container/*.log`.

## Metryki nginx-ingress

Na lokalnym dev monitorowałem Traefik jako reverse proxy. Na produkcji ruch przechodzi przez nginx-ingress controller. Domyślnie nie eksponował on szczegółowych metryk HTTP.

Włączenie wymagało dwóch kroków: dodania flagi `--enable-metrics=true` i portu 10254 w deploymencie, a następnie stworzenia Service i ServiceMonitor:

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

Label `release: kube-prometheus` jest wymagany — Prometheus Operator filtruje ServiceMonitory po tym labelu.

## Dostęp z zewnątrz

Oba panele dostępne są pod własnymi subdomenami z TLS (Let's Encrypt przez cert-manager):

- `grafana.borowski.services` — Grafana z loginem
- `prometheus.borowski.services` — Prometheus UI

Początkowo chroniłem dostęp przez IP whitelist w annotacji nginx:

```yaml
nginx.ingress.kubernetes.io/whitelist-source-range: "79.186.58.130/32"
```

Nie zadziałało. Load balancer OVH robi SNAT — nginx widział IP load balancera (`146.59.117.234`), nie prawdziwe IP klienta. Próba włączenia proxy protocol zepsuła połączenia (LB go nie wysyła). Rozwiązanie: basic auth zamiast whitelisty.

```yaml
nginx.ingress.kubernetes.io/auth-type: basic
nginx.ingress.kubernetes.io/auth-secret: monitoring-basic-auth
nginx.ingress.kubernetes.io/auth-realm: "Monitoring"
```

Secret `monitoring-basic-auth` wygenerowany przez `htpasswd`. Grafana ma dodatkowo własny login — podwójna warstwa.

## Dashboardy

Dashboardy ładowane są automatycznie przez sidecar Grafany. ConfigMap z labelem `grafana_dashboard=1` jest wykrywany i importowany bez restartu:

- **Portfolio Services Dashboard** — request rate, latency (p50/p95/p99), error rate i logi z Loki
- **Loki Logs — Portfolio** — przeglądarka logów z filtrowaniem po namespace, pod i kontenerze

Zapytania zostały przepisane z Traefika na nginx-ingress (`nginx_ingress_controller_requests` zamiast `traefik_service_requests_total`). Szczegóły konfiguracji dashboardów opisałem w osobnym artykule.

## Wersje

- `infra` → `v0.1.0` (nowy minor: monitoring produkcyjny, cert-manager, nginx configs, basic auth)
