---
title: "Production readiness — Docker hardening, health checks, and Kubernetes"
date: 2026-02-07
category: "Feature Update"
tags: [kubernetes, docker, production, health-checks, nginx, multi-stage, initcontainer, k8s]
locale: en
---

Services that work locally are one thing. Production readiness is a different category entirely. This step was dedicated to hardening containers, adding health checks, handling graceful shutdown, and writing the first Kubernetes manifests — across all services at once.

**Services: all**

## Health checks — /health and /ready

Every service received two dedicated endpoints. `/health` returns `200 OK` if the application is running at all (a basic liveness check). `/ready` returns `200 OK` only when the service is ready to accept traffic — meaning it has connected to the database, Redis is available, and the queue is reachable. Kubernetes uses these endpoints to make decisions: whether to restart a pod, and whether to route traffic to it.

Without health checks Kubernetes has no way to distinguish a pod that is still starting from a pod that has crashed.

## Production Dockerfiles — multi-stage build

Every service received a production Dockerfile using multi-stage builds. The `builder` stage installs Composer dependencies and builds assets. The final stage copies only what is needed — no development tools, no Composer cache, no test files. The resulting image is smaller and more secure.

Each PHP container has Nginx added as a sidecar — a single Kubernetes pod runs both PHP-FPM and Nginx, which handles HTTP traffic and forwards PHP requests to FPM over a socket.

## Graceful shutdown — preStop hook

Kubernetes can terminate a pod at any moment. Without proper handling this causes 502 errors for requests that are in flight. Every service received a `preStop` hook in its Kubernetes manifest — a short `sleep` that gives active requests time to finish before SIGTERM is sent to the process.

## Kubernetes manifests

Every service received a set of K8s manifests: `Deployment`, `Service`, `ConfigMap`, `Secret` (as a template), and `Ingress` with Traefik configuration. The `portfolio` namespace isolates the project's resources from the rest of the cluster.

Automatic database migrations are handled by an `initContainer` — it runs before the main container, executes `php artisan migrate --force`, and only once it succeeds does the application start. This eliminates the need to run migrations manually after every deployment.

## What I learned

Kubernetes is a whole new world. I started from absolute zero — I did not know what an `initContainer` was, what a `preStop hook` did, or how scheduling worked. I went through the documentation, several tutorials, and quite a few broken configurations. The biggest breakthrough was understanding that Kubernetes does not "run applications" — it manages declarative state. You describe what you want to have, and Kubernetes drives the cluster toward that state. That is a different way of thinking than `docker run`.
