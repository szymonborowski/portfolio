---
title: "Kubernetes manifests and production Dockerfiles"
date: 2026-02-08
category: "Dev Update"
tags: [kubernetes, k8s, docker, deployment, health-check, nginx]
locale: en
---

Dev runs on Docker Compose — but production is Kubernetes. I wrote K8s manifests for every service and redesigned the Dockerfiles for production realities: multi-stage build, health checks, graceful shutdown.

**Services: all**

## K8s manifests — one set per service

Each service has its own `k8s/` directory with a complete set of files:

- `deployment.yaml` — pod definition, resource limits, environment variables
- `service.yaml` — ClusterIP for internal communication
- `configmap.yaml` — non-sensitive configuration (APP_ENV, LOG_CHANNEL)
- `secret.yaml` — templates for passwords and API keys
- `ingress.yaml` — HTTP routing with cert-manager

Separating ConfigMap and Secret is not just a security matter — it makes secret rotation easier without redeploying the application.

## InitContainers — migrations before startup

The main container only starts after database migrations have run. An InitContainer handles this by running `php artisan migrate --force` from the same image as the application.

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/blog:latest
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secret
```

This prevents a situation where a new pod starts with an outdated database schema.

## Health checks — `/health` and `/ready`

Each service has two endpoints:

- `GET /health` — liveness probe: "is the application alive"
- `GET /ready` — readiness probe: "is the application ready for traffic"

`/ready` checks the database and Redis connections. Only when both are working does K8s route traffic to the pod.

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 5
```

## Graceful shutdown — preStop hook in Nginx

Kubernetes sends `SIGTERM` to the container when terminating it. PHP-FPM needs a moment to finish active requests. Nginx got a `preStop` hook with a short delay:

```yaml
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh", "-c", "sleep 5 && nginx -s quit"]
```

Five seconds is enough for K8s to stop forwarding new connections to the pod before shutting it down.

## Hardened multi-stage Dockerfile

The production image is built in two stages: builder (with Composer and dev dependencies) and runtime (only production artifacts). The final image contains neither Composer nor any development tools.

```dockerfile
FROM php:8.3-fpm-alpine AS builder
# install dependencies, composer install --no-dev

FROM php:8.3-fpm-alpine AS runtime
# only files from builder, no tools
COPY --from=builder /app /app
```

The resulting image is smaller and has a reduced attack surface.
