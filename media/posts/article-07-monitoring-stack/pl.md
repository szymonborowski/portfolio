---
title: "Monitoring z Prometheus, Loki i Grafana — stack obserwowalności w Docker Compose"
date: 2026-03-05
category: "DevOps"
tags: [Prometheus, Loki, Grafana, monitoring, Docker, observability]
locale: pl
---

## Trzy filary obserwowalności

Pełna obserwowalność systemu wymaga trzech typów danych:

- **Metryki** — liczby w czasie: CPU, pamięć, liczba requestów, czas odpowiedzi (Prometheus)
- **Logi** — tekstowe rekordy zdarzeń (Loki + Promtail)
- **Traces** — śledzenie konkretnego requestu przez wiele serwisów (nie wdrożone jeszcze)

## Prometheus — zbieranie metryk

Prometheus scrape'uje metryki z endpointów HTTP `/metrics`. Traefik i Laravel eksponują je automatycznie.

Konfiguracja scrapowania:
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

Dla PHP/Laravel używam `nginx-prometheus-exporter` jako sidecar, który czyta status Nginx i eksponuje metryki w formacie Prometheusa.

## Loki + Promtail — agregacja logów

Zamiast `docker logs` (które znikają po restarcie kontenera), loguję przez Promtail → Loki.

Wszystkie serwisy PHP mają ustawione `LOG_CHANNEL=stderr` — logi lecą do stdout kontenera, Promtail je zbiera:

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

## Grafana — dashboardy

Stworzyłem trzy dashboardy:

**1. Infrastructure Overview**
- CPU i RAM per kontener
- Network I/O
- Liczba aktywnych kontenerów

**2. Laravel Application**
- Requesty HTTP per minutę (przez logi Nginx)
- Response time (p50, p95, p99)
- Error rate (5xx)
- Cache hit rate Redis

**3. RabbitMQ**
- Liczba wiadomości w kolejkach
- Consumer throughput
- Dead-letter queue size

## Alerty (TODO)

Grafana pozwala ustawiać alerty na podstawie zapytań PromQL. Planowane alerty:
- Error rate > 5% przez 5 minut
- Pod restart count > 3
- Queue depth > 1000 wiadomości
- Czas odpowiedzi p95 > 2 sekundy

Na razie monitoring działa "read-only" — obserwuję, nie alarmuje. To jedno z zadań do zrealizowania przed pełnym deployem produkcyjnym.
