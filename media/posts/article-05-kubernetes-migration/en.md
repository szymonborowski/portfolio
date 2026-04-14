---
title: "From Docker Compose to Kubernetes — my step-by-step migration"
date: 2026-02-18
category: "DevOps"
tags: [Kubernetes, Docker, migration, StatefulSet, deployment, tutorial]
locale: en
---

## Starting point — Docker Compose

Docker Compose worked great in development. One file, `docker compose up` and everything runs. But Compose doesn't provide:
- automatic restart after a node failure
- rolling updates without downtime
- horizontal scaling
- declarative configuration management

Kubernetes solves all of these problems.

## Mapping concepts

| Docker Compose | Kubernetes |
|----------------|------------|
| `service`      | `Deployment` + `Service` |
| `volumes`      | `PersistentVolumeClaim` |
| `environment`  | `ConfigMap` + `Secret` |
| `networks`     | `NetworkPolicy` |
| `depends_on`   | `initContainer` |
| `healthcheck`  | `livenessProbe` + `readinessProbe` |

## Deployment manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    spec:
      containers:
        - name: frontend
          image: ghcr.io/szymonborowski/portfolio-frontend:v0.0.4
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: frontend-config
            - secretRef:
                name: frontend-secrets
          livenessProbe:
            httpGet:
              path: /health
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 5
```

## InitContainers — database migrations

The biggest problem: how to make sure DB migrations run before the application starts? In Compose I used `depends_on` with `condition: service_healthy`. In K8s I use an initContainer:

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/portfolio-blog:v0.0.4
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secrets
```

The initContainer must complete successfully before the main container starts.

## StatefulSets for databases

MySQL and Redis run as a StatefulSet, not a Deployment — because they need a stable network identity and persistent storage:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: blog-db
spec:
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
```

## What went wrong

The biggest pitfall: **ARM vs AMD64 images**. I was building images on a MacBook (ARM) without `--platform linux/amd64`. On the cluster (AMD64) containers crashed with an "exec format error". The fix: multi-arch build with `docker buildx`:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/... --push .
```
