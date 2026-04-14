---
title: "Deploying to OVH Managed Kubernetes"
date: 2026-03-16
category: "Feature Update"
tags: [kubernetes, ovh, kustomize, cert-manager, lets-encrypt, traefik, cicd, production]
locale: en
---

For several weeks the system ran locally and on Docker Compose. The time came to put it on a real cluster. Deploying to OVH Managed Kubernetes required several weeks of preparation: monorepo setup, Kustomize overlays, TLS certificates, and a CI/CD pipeline.

**Services: all (portfolio monorepo)**

## Portfolio monorepo setup

Instead of managing each service's deployment separately, I built a single portfolio repository that ties them all together. It contains `docker-compose.prod.yml` for a Docker Compose production environment (as a backup and alternative to K8s), `install.sh` for automatically cloning all service repositories and configuring the environment, and CI/CD scripts for automated deployment.

## Kustomize overlays

Each service now has a Kustomize structure with three overlays:
- `base` — shared configuration for all environments
- `dev` — local configuration with development-specific settings
- `prod` — production configuration with resource limits, replica counts, and production secrets

Kustomize allows patching manifests without duplicating code. The prod environment inherits from base and overrides only what differs from dev — domain addresses, replica counts, resource limits.

## OVH Managed Kubernetes

I chose OVH Managed Kubernetes as the production platform for several reasons: reasonable pricing for a small cluster, full Kubernetes API compatibility, good documentation, and a data center in Europe (relevant from a GDPR perspective).

The cluster has a `portfolio` namespace. Traefik, installed via a Helm chart as the IngressController, handles all external traffic. Each service has its own `Ingress` pointing to a subdomain of `borowski.services`.

## TLS via cert-manager and Let's Encrypt

cert-manager is a Kubernetes controller that manages TLS certificates. I configured a `ClusterIssuer` using the ACME protocol with Let's Encrypt. Any `Ingress` with the appropriate annotation automatically gets a TLS certificate — cert-manager obtains it, renews it, and updates the `Secret` in the cluster.

This gives all `borowski.services` subdomains HTTPS without any manual certificate work.

## What I learned

Kubernetes in production is a completely different level from local exercises. The first deployment took me much longer than I anticipated — mainly due to networking configuration, certificates, and properly understanding how Traefik works as an IngressController in K8s (as opposed to standalone Docker Compose). Kustomize proved to be the right choice — the alternative (copying manifests for each environment) would have quickly become unmanageable.
