---
title: "How to run the project locally"
date: 2026-01-28
category: "Intro"
tags: [intro, docker, installation, devops, local-dev]
locale: en
---

This post is a practical guide — how to clone the repository, configure the environment, and run the entire system on your machine. With a single script.

## Requirements

Before you start, make sure you have the following installed:

- **git**
- **Docker Engine 24+** with Docker Compose v2
- **[mkcert](https://github.com/FiloSottile/mkcert)** — for generating local TLS certificates

On Ubuntu/Debian:

```bash
sudo apt install mkcert
```

On macOS:

```bash
brew install mkcert
```

## Cloning and setup

```bash
git clone https://github.com/szymonborowski/portfolio.git
cd portfolio
./install.sh
```

The `install.sh` script automatically handles several steps:

1. Clones all microservice repositories into subdirectories
2. Creates `.env` files from `.env.example` for each service
3. Generates random passwords, API keys, and OAuth2 secrets
4. Generates TLS certificates via `mkcert` for all local domains
5. Adds domains to `/etc/hosts`
6. Creates the required Docker networks

> The script will ask for your `sudo` password — it is only needed to modify `/etc/hosts`.

## Starting the services

Once installation is complete:

```bash
./dev.sh up -d --build
```

`dev.sh` is a helper script wrapping `docker compose`. You can also start only selected services:

```bash
./dev.sh up -d --build -- blog admin
```

Or follow the logs of a specific service:

```bash
./dev.sh logs -f -- frontend
```

## Available addresses

After startup, the system is available at the following addresses (default domain is `microservices.local`):

| Service | Address |
|---------|---------|
| Frontend | `https://frontend.microservices.local` |
| SSO | `https://sso.microservices.local` |
| Admin | `https://admin.microservices.local` |
| Blog API | `https://blog.microservices.local` |
| Traefik Dashboard | `https://traefik.microservices.local` |
| RabbitMQ | `https://rabbitmq.microservices.local` |
| Grafana | `https://grafana.microservices.local` |
| Prometheus | `https://prometheus.microservices.local` |

## Custom local domain

If `microservices.local` conflicts with something in your environment, you can use a different domain:

```bash
./install.sh --domain myapp.local
```

## Clean reset

If you want to start from scratch:

```bash
./install.sh --purge
```

This stops all services and removes the cloned repositories. You can then run `./install.sh` again.

---

If something does not work — feel free to reach out. The code is public, so you can also browse the individual service repositories directly.
