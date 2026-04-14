---
title: "Monitoring stack — Prometheus, Loki, Grafana"
date: 2026-02-12
category: "Dev Update"
tags: [prometheus, loki, grafana, promtail, monitoring, docker, infra]
locale: en
---

The system is running — but what's happening inside it? Time for observability. I set up the classic stack: **Prometheus** for metrics, **Loki** for logs, **Grafana** as the dashboard. All within the Docker Compose infrastructure.

**Service: Infra**

## Prometheus — metrics from services

Each Laravel service exposes a `/metrics` endpoint via the `spatie/prometheus` library. Prometheus scrapes them every 15 seconds. Collected metrics include: HTTP request count, response time, PHP memory usage, RabbitMQ queue state.

Scrape configuration in `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'blog'
    static_configs:
      - targets: ['blog:80']
    metrics_path: '/metrics'
    scrape_interval: 15s
```

## Loki — log aggregation

**Loki** is a log aggregation system compatible with Grafana. It does not index log content (like Elasticsearch) — it only indexes labels. This makes it much lighter while still providing fast searching.

Each Docker container sends logs to Loki via **Promtail**. Promtail reads logs from the Docker socket and forwards them with container metadata (name, ID, environment).

## Promtail — collecting logs from containers

Promtail runs as an agent on the host and listens on the Docker log driver. Autodiscovery configuration — it automatically detects new containers and starts collecting their logs without manual configuration.

Each log gets labels: `container_name`, `compose_service`, `compose_project`. In Grafana you can filter logs by service: `{compose_service="blog"}`.

## Grafana — everything in one place

```yaml
# docker-compose fragment
grafana:
  image: grafana/grafana:latest
  volumes:
    - grafana_data:/var/lib/grafana
  environment:
    - GF_AUTH_ANONYMOUS_ENABLED=true
```

Grafana is configured with two data sources: Prometheus (metrics) and Loki (logs). Dashboards are saved as JSON and versioned in the repo under `grafana/dashboards/`.

I prepared dashboards for:
- System overview (CPU, memory, requests per service)
- Real-time logs with search capability
- RabbitMQ queue state

> `GF_AUTH_ANONYMOUS_ENABLED=true` works locally and on dev. In production this parameter is disabled — access is through OAuth2 SSO.
