---
title: "Multi-stage Docker builds — Alpine, hardening i minimalne obrazy produkcyjne"
date: 2026-02-09
category: "DevOps"
tags: [Docker, Alpine, security, PHP, Dockerfile, containers, hardening]
locale: pl
---

## Problem z prostymi Dockerfile

Naiwny Dockerfile dla aplikacji Laravel:

```dockerfile
FROM php:8.5-fpm
RUN apt-get install -y git zip unzip nodejs npm
COPY . /var/www
RUN composer install
RUN npm install && npm run build
```

Wynikowy obraz: ~1.2 GB. Zawiera narzędzia build-time (git, npm, composer) których produkcja nie potrzebuje.

## Multi-stage build — podział na etapy

```dockerfile
# Etap 1: build assets (Node.js)
FROM node:22-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY resources/ resources/
COPY vite.config.js ./
RUN npm run build

# Etap 2: install PHP dependencies
FROM composer:2 AS composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Etap 3: obraz produkcyjny
FROM php:8.5-fpm-alpine AS production
WORKDIR /var/www

# Kopiujemy tylko artefakty z poprzednich etapów
COPY --from=composer /app/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
COPY . .

RUN chown -R www-data:www-data /var/www
USER www-data
```

Wynikowy obraz: ~180 MB — 85% mniej.

## Hardening kontenera

Kilka zasad bezpieczeństwa, które stosuję:

**Non-root user:**
```dockerfile
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser
```

**Read-only filesystem (tam gdzie możliwe):**
```yaml
# docker-compose.prod.yml
security_opt:
  - no-new-privileges:true
read_only: true
tmpfs:
  - /tmp
  - /var/run
```

**Minimalny obraz — Alpine zamiast Debian:**
Alpine Linux ma ~5 MB w porównaniu do ~80 MB Debiana. Mniej pakietów = mniejsza powierzchnia ataku.

**STOPSIGNAL SIGQUIT dla PHP-FPM:**
```dockerfile
STOPSIGNAL SIGQUIT
```
PHP-FPM na SIGQUIT robi graceful shutdown — dokańcza aktywne requesty zanim się wyłączy. Bez tego K8s mógłby zabić kontener w trakcie obsługi requestu.

## OCI labels dla trackowalności

```dockerfile
LABEL org.opencontainers.image.version="0.0.4"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/szymonborowski/portfolio"
```

Dzięki temu patrząc na działający kontener wiem dokładnie z jakiego commitu pochodzi.
