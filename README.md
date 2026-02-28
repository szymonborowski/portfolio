# Portfolio Microservices

A blogging platform built with microservices architecture.

**Stack:** Laravel 12 · PHP 8.5 · MySQL 8 · Redis · RabbitMQ · Docker · Kubernetes · Traefik · Vue.js

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
| `ghcr.io/szymonborowski/microservices-frontend` | `v0.0.4` |
| `ghcr.io/szymonborowski/microservices-sso` | `v0.0.2` |
| `ghcr.io/szymonborowski/microservices-admin` | `v0.0.2` |
| `ghcr.io/szymonborowski/microservices-users` | `v0.0.4` |
| `ghcr.io/szymonborowski/microservices-blog` | `v0.0.2` |
| `ghcr.io/szymonborowski/microservices-analytics` | `v0.0.1` |
| `ghcr.io/szymonborowski/microservices-infrastructure` | `v0.0.1` |

## Quick Start (Production)

### Prerequisites

- Docker Engine 24+
- Docker Compose v2
- Access to GHCR images (`docker login ghcr.io`)

### Deploy

```bash
# 1. Clone this repository
git clone https://github.com/szymonborowski/portfolio.git
cd portfolio

# 2. Configure environment
cp .env.prod.example .env.prod
# Edit .env.prod — fill in passwords, APP_KEYs, and domains

# 3. Start everything
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

This starts 27 containers: 6 application services, 6 nginx proxies, 6 databases, 2 RabbitMQ consumers, Redis, and the full infrastructure stack (Traefik, RabbitMQ, Prometheus, Loki, Promtail, Grafana).

### Default Domains (local development)

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

## Development Setup

Each service has its own `docker-compose.yml` for local development with:
- Hot reload (Vite dev servers)
- Source code volume mounts
- Xdebug support
- Exposed database ports

```bash
# Start infrastructure first
cd infra && docker compose up -d

# Then start individual services
cd ../frontend && docker compose up -d
cd ../sso && docker compose up -d
# ... etc.
```

## Project Structure

```
portfolio/
├── docker-compose.prod.yml     # Production compose (all services)
├── .env.prod.example           # Environment template
├── deploy/
│   └── nginx/                  # Nginx configs per service
├── docs/                       # Deployment documentation
├── scripts/                    # Helper scripts
├── TODO.md                     # Roadmap & open tasks
├── TEST_COVERAGE.md            # Test coverage report
└── LICENSE
```

## Monitoring

The production stack includes a full observability suite:

- **Prometheus** — metrics collection and alerting
- **Loki** — log aggregation
- **Promtail** — log shipping from Docker containers
- **Grafana** — dashboards and visualization (pre-configured with datasources and dashboards)

## Kubernetes

Kubernetes manifests are available in each service repository under `k8s/` and in the infrastructure repository. See [docs/MINIKUBE_DEPLOYMENT.md](docs/MINIKUBE_DEPLOYMENT.md) for a complete local deployment guide.

## License

[MIT](LICENSE)
