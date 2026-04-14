---
title: "Stos monitorowania — Prometheus, Loki, Grafana"
date: 2026-02-12
category: "Dev Update"
tags: [prometheus, loki, grafana, promtail, monitoring, docker, infra]
locale: pl
---

System działa — ale co się w nim dzieje? Czas na obserwability. Postawiłem klasyczny stos: **Prometheus** do metryk, **Loki** do logów, **Grafana** jako dashboard. Wszystko w ramach infrastruktury Docker Compose.

**Serwis: Infra**

## Prometheus — metryki z serwisów

Każdy serwis Laravel eksponuje endpoint `/metrics` przez bibliotekę `spatie/prometheus`. Prometheus scrapuje je co 15 sekund. Zbierane metryki to: liczba requestów HTTP, czas odpowiedzi, użycie pamięci PHP, stan kolejek RabbitMQ.

Konfiguracja scrapowania w `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'blog'
    static_configs:
      - targets: ['blog:80']
    metrics_path: '/metrics'
    scrape_interval: 15s
```

## Loki — agregacja logów

**Loki** to system agregacji logów kompatybilny z Grafaną. Nie indeksuje treści logów (jak Elasticsearch) — indeksuje tylko etykiety. To sprawia, że jest znacznie lżejszy przy zachowaniu szybkiego przeszukiwania.

Każdy kontener Docker wysyła logi do Loki przez **Promtail**. Promtail czyta logi z Docker socket i przesyła je z metadanymi kontenera (nazwa, ID, środowisko).

## Promtail — zbieranie logów z kontenerów

Promtail działa jako agent na hoście i nasłuchuje na log driver Dockera. Konfiguracja autodiscovery — automatycznie wykrywa nowe kontenery i zaczyna zbierać ich logi bez ręcznej konfiguracji.

Każdy log dostaje etykiety: `container_name`, `compose_service`, `compose_project`. W Grafanie można filtrować logi po serwisie: `{compose_service="blog"}`.

## Grafana — wszystko w jednym miejscu

```yaml
# docker-compose fragment
grafana:
  image: grafana/grafana:latest
  volumes:
    - grafana_data:/var/lib/grafana
  environment:
    - GF_AUTH_ANONYMOUS_ENABLED=true
```

Grafana jest skonfigurowana z dwoma data sources: Prometheus (metryki) i Loki (logi). Dashboardy są zapisane jako JSON i wersjonowane w repo — `grafana/dashboards/`.

Przygotowałem dashboardy dla:
- Przegląd systemu (CPU, pamięć, requesty per serwis)
- Logi w czasie rzeczywistym z możliwością przeszukiwania
- Stan kolejek RabbitMQ

> `GF_AUTH_ANONYMOUS_ENABLED=true` działa lokalnie i na dev. Na produkcji ten parametr jest wyłączony — dostęp przez OAuth2 SSO.
