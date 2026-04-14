---
title: "Kubernetes od Docker Compose — moja migracja krok po kroku"
date: 2026-02-18
category: "DevOps"
tags: [Kubernetes, Docker, migration, StatefulSet, deployment, tutorial]
locale: pl
---

## Punkt startowy — Docker Compose

Docker Compose działał świetnie w developmencie. Jeden plik, `docker compose up` i wszystko chodzi. Ale Compose nie daje:
- automatycznego restartu po awarii noda
- rolling updates bez downtime
- horizontal scaling
- deklaratywnego zarządzania konfiguracją

Kubernetes rozwiązuje wszystkie te problemy.

## Mapowanie pojęć

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

## InitContainers — migracje bazy

Największy problem: jak upewnić się, że migracje DB wykonają się przed startem aplikacji? W Compose używałem `depends_on` z `condition: service_healthy`. W K8s używam initContainer:

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/portfolio-blog:v0.0.4
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secrets
```

initContainer musi zakończyć się sukcesem zanim główny kontener wystartuje.

## StatefulSets dla baz danych

MySQL i Redis działają jako StatefulSet, nie Deployment — bo potrzebują stabilnej tożsamości sieciowej i trwałego storage:

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

## Co poszło nie tak

Największa pułapka: **obrazy ARM vs AMD64**. Budowałem obrazy na MacBooku (ARM) bez `--platform linux/amd64`. Na klastrze (AMD64) kontenery crashowały z błędem "exec format error". Rozwiązanie: multi-arch build z `docker buildx`:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/... --push .
```
