---
title: "Multi-stage Docker builds — Alpine, hardening and minimal production images"
date: 2026-02-09
category: "DevOps"
tags: [Docker, Alpine, security, PHP, Dockerfile, containers, hardening]
locale: en
---

## The problem with simple Dockerfiles

A naive Dockerfile for a Laravel application:

```dockerfile
FROM php:8.5-fpm
RUN apt-get install -y git zip unzip nodejs npm
COPY . /var/www
RUN composer install
RUN npm install && npm run build
```

Resulting image: ~1.2 GB. It contains build-time tools (git, npm, composer) that production does not need.

## Multi-stage build — splitting into stages

```dockerfile
# Stage 1: build assets (Node.js)
FROM node:22-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY resources/ resources/
COPY vite.config.js ./
RUN npm run build

# Stage 2: install PHP dependencies
FROM composer:2 AS composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Stage 3: production image
FROM php:8.5-fpm-alpine AS production
WORKDIR /var/www

# Copy only the artifacts from previous stages
COPY --from=composer /app/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
COPY . .

RUN chown -R www-data:www-data /var/www
USER www-data
```

Resulting image: ~180 MB — 85% smaller.

## Container hardening

A few security principles I follow:

**Non-root user:**
```dockerfile
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser
```

**Read-only filesystem (where possible):**
```yaml
# docker-compose.prod.yml
security_opt:
  - no-new-privileges:true
read_only: true
tmpfs:
  - /tmp
  - /var/run
```

**Minimal image — Alpine instead of Debian:**
Alpine Linux is ~5 MB compared to ~80 MB for Debian. Fewer packages = smaller attack surface.

**STOPSIGNAL SIGQUIT for PHP-FPM:**
```dockerfile
STOPSIGNAL SIGQUIT
```
PHP-FPM performs a graceful shutdown on SIGQUIT — it finishes active requests before shutting down. Without this, K8s could kill the container in the middle of handling a request.

## OCI labels for traceability

```dockerfile
LABEL org.opencontainers.image.version="0.0.4"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/szymonborowski/portfolio"
```

This way, when looking at a running container I know exactly which commit it came from.
