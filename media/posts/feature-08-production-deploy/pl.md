---
title: "Wdrożenie na OVH Managed Kubernetes z Kustomize"
date: 2026-03-16
category: "Dev Update"
tags: [kubernetes, kustomize, ovh, ghcr, cert-manager, produkcja, docker]
locale: pl
---

Projekt wylądował na produkcji. Klaster **OVH Managed Kubernetes**, obrazy w **GHCR**, TLS z **cert-manager** i Let's Encrypt. Zarządzanie konfiguracją przez **Kustomize** — bez Helma, bez zewnętrznych zależności.

**Serwisy: wszystkie**

## Kustomize overlays — base / dev / prod

Każdy serwis ma strukturę:

```
k8s/
  base/          # wspólna konfiguracja
  overlays/
    dev/         # nadpisania dla dev (mniej replik, bez limitów)
    prod/        # nadpisania dla prod (limity, TLS, zewnętrzne domeny)
```

`base/` zawiera Deployment, Service i ConfigMap. Overlaye nadpisują tylko to, co się różni — liczba replik, image tag, limity CPU/RAM, adres Ingress.

```bash
# Deploy na produkcję
kubectl apply -k k8s/overlays/prod
kubectl get pods -n portfolio
```

## Obrazy Docker w GHCR

Każdy merge do `main` uruchamia GitHub Actions workflow, który buduje obraz i pushuje do **GitHub Container Registry**:

```
ghcr.io/szymonborowski/blog:latest
ghcr.io/szymonborowski/frontend:latest
ghcr.io/szymonborowski/sso:latest
```

Klaster K8s pobiera obrazy z GHCR przez imagePullSecret. Tag `latest` wskazuje zawsze na najnowszy build z głównej gałęzi.

## cert-manager i Let's Encrypt

TLS obsługuje **cert-manager** z Issuerem Let's Encrypt. Certyfikaty są automatycznie odnawiane. Ingress każdego serwisu ma adnotację:

```yaml
annotations:
  cert-manager.io/cluster-issuer: "letsencrypt-prod"
```

cert-manager sam tworzy obiekt `Certificate` i przechowuje certyfikat w Secret.

## Resource limits i log rotation

Na produkcji każdy kontener ma zdefiniowane `requests` i `limits` dla CPU i pamięci. Bez limitów jeden serwis może zagłodzić cały klaster.

W Docker Compose (dla lokalnego dev) skonfigurowałem log rotation, żeby logi nie zapełniły dysku:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

> Na K8s logi zbiera Promtail i wysyła do Loki — Docker log rotation nie jest potrzebna, ale na dev Compose jest niezbędna.
