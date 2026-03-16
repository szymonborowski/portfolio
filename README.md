# Portfolio Microservices

A blogging platform built with microservices architecture.

**Stack:** Laravel 12 · PHP 8.5 · MySQL 8 · Redis · RabbitMQ · Docker · Kubernetes · Traefik · Vue.js

**Live:** [borowski.services](https://borowski.services)

## Architecture

```
                    ┌─────────────┐
                    │   Traefik   │
                    │  (reverse   │
                    │   proxy)    │
                    └──────┬──────┘
                           │
        ┌──────────┬───────┼───────┬──────────┐
        │          │       │       │          │
   ┌────▼───┐ ┌───▼──┐ ┌──▼──┐ ┌──▼──┐ ┌────▼───┐
   │Frontend│ │ SSO  │ │Admin│ │Users│ │  Blog  │
   │ + Redis│ │      │ │     │ │     │ │        │
   └────────┘ └──────┘ └─────┘ └──┬──┘ └───┬────┘
                                   │        │
                              ┌────▼────────▼────┐
                              │    RabbitMQ       │
                              └────────┬──────────┘
                                       │
                              ┌────────▼──────────┐
                              │    Analytics      │
                              │   (consumers)     │
                              └───────────────────┘
```

### Services

| Service | Description | Repository |
|---------|-------------|------------|
| **Frontend** | Main web application with blog, user panel, OAuth2 | [frontend_service](https://github.com/szymonborowski/frontend_service) |
| **SSO** | OAuth2 authorization server (Laravel Passport) | [sso_service](https://github.com/szymonborowski/sso_service) |
| **Admin** | Admin panel built with FilamentPHP | [admin_service](https://github.com/szymonborowski/admin_service) |
| **Users** | User management, RBAC, internal API | [users_service](https://github.com/szymonborowski/users_service) |
| **Blog** | Blog API — posts, categories, tags, comments | [blog_service](https://github.com/szymonborowski/blog_service) |
| **Analytics** | Page view tracking via RabbitMQ consumers | [analytics_service](https://github.com/szymonborowski/analytics_service) |
| **Infrastructure** | Traefik, RabbitMQ, Prometheus, Loki, Grafana | [infrastructure_service](https://github.com/szymonborowski/infrastructure_service) |

### Docker Images

All images are published to GitHub Container Registry:

| Image | Latest |
|-------|--------|
| `ghcr.io/szymonborowski/portfolio-frontend` | `v0.0.5` |
| `ghcr.io/szymonborowski/portfolio-sso` | `v0.0.4` |
| `ghcr.io/szymonborowski/portfolio-admin` | `v0.0.4` |
| `ghcr.io/szymonborowski/portfolio-users` | `v0.0.5` |
| `ghcr.io/szymonborowski/portfolio-blog` | `v0.0.3` |
| `ghcr.io/szymonborowski/portfolio-analytics` | `v0.0.2` |

## Quick Start (Local Development)

### Prerequisites

- git
- Docker Engine 24+ and Docker Compose v2
- [mkcert](https://github.com/FiloSottile/mkcert)

### Setup

```bash
git clone https://github.com/szymonborowski/portfolio.git
cd portfolio
./install.sh
```

`install.sh` will:
1. Clone all microservice repositories into subdirectories
2. Create `.env` files from `.env.example` for each service
3. Generate TLS certificates with mkcert for `*.microservices.local`
4. Add local domains to `/etc/hosts`

After setup, review secrets in each service's `.env` file, then:

```bash
docker compose up -d
```

This starts all services via a single root `docker-compose.yml` that includes each microservice's compose file.

### Local Domains

| Service | URL |
|---------|-----|
| Frontend | `https://frontend.microservices.local` |
| SSO | `https://sso.microservices.local` |
| Admin | `https://admin.microservices.local` |
| Users API | `https://users.microservices.local` |
| Blog API | `https://blog.microservices.local` |
| Traefik Dashboard | `https://traefik.microservices.local` |
| RabbitMQ Management | `https://rabbitmq.microservices.local` |
| Grafana | `https://grafana.microservices.local` |
| Prometheus | `https://prometheus.microservices.local` |

## Quick Start (Production — Docker Compose)

```bash
git clone https://github.com/szymonborowski/portfolio.git
cd portfolio
cp .env.prod.example .env.prod
# Edit .env.prod — fill in passwords, APP_KEYs, and domains
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

## Project Structure

```
portfolio/
├── install.sh                  # Local dev setup script
├── docker-compose.yml          # Root compose (includes all services)
├── docker-compose.prod.yml     # Production compose (Traefik + all services)
├── .env.prod.example           # Production environment template
├── infra/
│   └── nginx/                  # Nginx configs per service
├── scripts/                    # Helper scripts (k8s-deploy, secrets)
└── LICENSE
```

## Monitoring

The production stack includes a full observability suite:

- **Prometheus** — metrics collection
- **Loki** — log aggregation
- **Promtail** — log shipping from Docker containers
- **Grafana** — dashboards and visualization

## Kubernetes

Kubernetes manifests are available in each service repository under `k8s/`. The cluster runs on OVH Managed Kubernetes with cert-manager and Let's Encrypt for TLS.

```bash
# Deploy all services
./scripts/k8s-deploy.sh

# Check status
kubectl get pods -n portfolio
kubectl get ingress -n portfolio
```

## License

[MIT](LICENSE)
