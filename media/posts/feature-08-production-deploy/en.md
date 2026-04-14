---
title: "Deploying to OVH Managed Kubernetes with Kustomize"
date: 2026-03-16
category: "Dev Update"
tags: [kubernetes, kustomize, ovh, ghcr, cert-manager, production, docker]
locale: en
---

The project is live. **OVH Managed Kubernetes** cluster, images in **GHCR**, TLS with **cert-manager** and Let's Encrypt. Configuration management via **Kustomize** — no Helm, no external dependencies.

**Services: all**

## Kustomize overlays — base / dev / prod

Each service has this structure:

```
k8s/
  base/          # shared configuration
  overlays/
    dev/         # overrides for dev (fewer replicas, no limits)
    prod/        # overrides for prod (limits, TLS, external domains)
```

`base/` contains the Deployment, Service, and ConfigMap. Overlays only override what differs — replica count, image tag, CPU/RAM limits, Ingress address.

```bash
# Deploy to production
kubectl apply -k k8s/overlays/prod
kubectl get pods -n portfolio
```

## Docker images in GHCR

Every merge to `main` triggers a GitHub Actions workflow that builds the image and pushes it to **GitHub Container Registry**:

```
ghcr.io/szymonborowski/blog:latest
ghcr.io/szymonborowski/frontend:latest
ghcr.io/szymonborowski/sso:latest
```

The K8s cluster pulls images from GHCR via an imagePullSecret. The `latest` tag always points to the newest build from the main branch.

## cert-manager and Let's Encrypt

TLS is handled by **cert-manager** with a Let's Encrypt Issuer. Certificates are automatically renewed. Each service's Ingress has the annotation:

```yaml
annotations:
  cert-manager.io/cluster-issuer: "letsencrypt-prod"
```

cert-manager creates the `Certificate` object itself and stores the certificate in a Secret.

## Resource limits and log rotation

In production, every container has defined `requests` and `limits` for CPU and memory. Without limits, one service can starve the entire cluster.

In Docker Compose (for local dev) I configured log rotation so logs don't fill the disk:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

> On K8s, logs are collected by Promtail and sent to Loki — Docker log rotation isn't needed, but on dev Compose it's essential.
