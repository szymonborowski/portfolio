---
title: "Manifesty Kubernetes i produkcyjne Dockerfile"
date: 2026-02-08
category: "Dev Update"
tags: [kubernetes, k8s, docker, deployment, health-check, nginx]
locale: pl
---

Dev działa na Docker Compose — ale produkcja to Kubernetes. Napisałem manifesty K8s dla każdego serwisu i przeprojektowałem Dockerfile pod realia produkcyjne: multi-stage build, health checki, graceful shutdown.

**Serwisy: wszystkie**

## Manifesty K8s — jeden zestaw na serwis

Każdy serwis ma własny katalog `k8s/` z kompletem plików:

- `deployment.yaml` — definicja poda, limity zasobów, zmienne środowiskowe
- `service.yaml` — ClusterIP do komunikacji wewnętrznej
- `configmap.yaml` — konfiguracja nieczuła (APP_ENV, LOG_CHANNEL)
- `secret.yaml` — szablony na hasła i klucze API
- `ingress.yaml` — routing HTTP z cert-manager

Separacja ConfigMap i Secret to nie tylko kwestia bezpieczeństwa — ułatwia rotację sekretów bez wdrażania aplikacji.

## InitContainers — migracje przed startem

Główny kontener startuje dopiero po wykonaniu migracji bazy danych. Robi to InitContainer uruchamiający `php artisan migrate --force` z tego samego obrazu co aplikacja.

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/blog:latest
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secret
```

Dzięki temu nie ma sytuacji, w której nowy pod startuje z nieaktualnym schematem bazy.

## Health checki — `/health` i `/ready`

Każdy serwis ma dwa endpointy:

- `GET /health` — liveness probe: "czy aplikacja żyje"
- `GET /ready` — readiness probe: "czy aplikacja jest gotowa na ruch"

`/ready` sprawdza połączenie z bazą danych i Redis. Dopiero gdy oba działają, K8s kieruje ruch do poda.

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 5
```

## Graceful shutdown — preStop hook w Nginx

Kubernetes wysyła `SIGTERM` do kontenera gdy go kończy. PHP-FPM potrzebuje chwili na dokończenie aktywnych żądań. Nginx dostał `preStop` hook z krótkim opóźnieniem:

```yaml
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh", "-c", "sleep 5 && nginx -s quit"]
```

Pięć sekund wystarczy, żeby K8s skończył przesyłanie nowych połączeń do poda przed jego zamknięciem.

## Hardened Dockerfile multi-stage

Obraz produkcyjny budowany jest w dwóch etapach: builder (z Composerem i zależnościami dev) i runtime (tylko artefakty produkcyjne). Finalny obraz nie zawiera Composera ani żadnych narzędzi deweloperskich.

```dockerfile
FROM php:8.3-fpm-alpine AS builder
# instalacja zależności, composer install --no-dev

FROM php:8.3-fpm-alpine AS runtime
# tylko pliki z buildera, bez narzędzi
COPY --from=builder /app /app
```

Wynikowy obraz jest mniejszy i ma mniejszą powierzchnię ataku.
