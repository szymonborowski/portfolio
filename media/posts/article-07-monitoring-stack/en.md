---
title: "Monitoring with Prometheus, Loki and Grafana — observability stack in Docker Compose"
date: 2026-03-05
category: "DevOps"
tags: [Prometheus, Loki, Grafana, monitoring, Docker, observability]
locale: en
---

## Three pillars of observability

Full system observability requires three types of data:

- **Metrics** — numbers over time: CPU, memory, request count, response time (Prometheus)
- **Logs** — textual event records (Loki + Promtail)
- **Traces** — tracking a specific request across multiple services (not yet implemented)

## Prometheus — collecting metrics

Prometheus scrapes metrics from HTTP `/metrics` endpoints. Traefik and Laravel expose them automatically.

Scrape configuration:
```yaml
# infra/prometheus/prometheus.yml
scrape_configs:
  - job_name: traefik
    static_configs:
      - targets: ['traefik:8080']
    metrics_path: /metrics

  - job_name: frontend
    static_configs:
      - targets: ['frontend-nginx:9113']
```

For PHP/Laravel I use `nginx-prometheus-exporter` as a sidecar that reads Nginx status and exposes metrics in Prometheus format.

## Loki + Promtail — log aggregation

Instead of `docker logs` (which disappear after a container restart), I log through Promtail → Loki.

All PHP services have `LOG_CHANNEL=stderr` set — logs go to container stdout, and Promtail collects them:

```yaml
# infra/promtail/promtail.yml
scrape_configs:
  - job_name: containers
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: [__meta_docker_container_name]
        target_label: container
```

## Grafana — dashboards

I created three dashboards:

**1. Infrastructure Overview**
- CPU and RAM per container
- Network I/O
- Number of active containers

**2. Laravel Application**
- HTTP requests per minute (via Nginx logs)
- Response time (p50, p95, p99)
- Error rate (5xx)
- Redis cache hit rate

**3. RabbitMQ**
- Number of messages in queues
- Consumer throughput
- Dead-letter queue size

## Alerts (TODO)

Grafana allows setting up alerts based on PromQL queries. Planned alerts:
- Error rate > 5% for 5 minutes
- Pod restart count > 3
- Queue depth > 1000 messages
- p95 response time > 2 seconds

For now the monitoring works in "read-only" mode — I observe, it does not alert. This is one of the tasks to complete before a full production deployment.
