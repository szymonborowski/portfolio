---
title: "Traefik v3 as a reverse proxy — routing, TLS and dashboard in practice"
date: 2026-02-01
category: "DevOps"
tags: [Traefik, Docker, nginx, TLS, reverse-proxy, infrastructure]
locale: en
---

## What is Traefik?

Traefik is a modern reverse proxy and load balancer that differs from Nginx in that it **configures itself dynamically**. Instead of manually writing `server {}` blocks, Traefik reads labels from Docker containers and builds the routing on its own.

## Basic configuration

In `docker-compose.prod.yml` I start Traefik as the first service:

```yaml
traefik:
  image: traefik:v3.6
  command:
    - "--entrypoints.web.address=:80"
    - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
    - "--entrypoints.websecure.address=:443"
    - "--entrypoints.websecure.http.tls=true"
    - "--providers.docker=true"
    - "--providers.docker.exposedbydefault=false"
    - "--providers.file.filename=/etc/traefik/dynamic/traefik_dynamic.yml"
```

Key decisions:
- `exposedbydefault=false` — a service must explicitly add the label `traefik.enable=true` to be exposed
- The HTTP-to-HTTPS redirect is global — a single entry that works for all services

## Routing via labels

Every service I want to expose publicly gets labels:

```yaml
frontend:
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.frontend.rule=Host(`portfolio.example.com`)"
    - "traefik.http.routers.frontend.entrypoints=websecure"
    - "traefik.http.routers.frontend.tls=true"
    - "traefik.http.services.frontend.loadbalancer.server.port=80"
```

Internal services (Blog API, Users API) are on a separate network and do not have these labels — they are only accessible from the `microservices` network.

## TLS with custom certificates

In the project I use custom certificates (dev) or Let's Encrypt (production). The TLS configuration lives in a dynamic file:

```yaml
# infra/dynamic/traefik_dynamic.yml
tls:
  certificates:
    - certFile: /certs/cert.pem
      keyFile: /certs/key.pem
  stores:
    default:
      defaultCertificate:
        certFile: /certs/cert.pem
        keyFile: /certs/key.pem
```

## Dashboard

The Traefik dashboard is very useful for debugging — it shows active routers, services, and middleware. I secure it with a separate domain using Basic Auth via middleware:

```yaml
- "traefik.http.routers.dashboard.rule=Host(`traefik.example.com`)"
- "traefik.http.routers.dashboard.middlewares=auth@file"
```

## What I like about Traefik

The biggest plus is **zero restarts when the configuration changes**. I add a new container with the appropriate labels, Traefik detects it within seconds, and starts routing traffic. With Nginx I would have to edit a configuration file and reload the service.

The downside is the learning curve — the label syntax is specific and it is easy to make a typo that silently does nothing.
