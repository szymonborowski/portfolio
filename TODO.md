# Portfolio Microservices — TODO & Roadmap

> **Projekt:** Platforma blogowa w architekturze mikroserwisowej
> **Stack:** Laravel 12 · PHP 8.5 · MySQL 8 · Redis · RabbitMQ · Docker · Kubernetes · Vue.js
> **Serwisy:** Frontend, Blog, Users, SSO, Admin, Analytics, Infra
> **Ostatnia aktualizacja:** 2026-02-12

---

## Roadmap — dotychczasowy postęp

### Faza 1 — Fundament (grudzień 2025)
- [x] Scaffolding SSO i Users (Laravel, Docker, Passport)
- [x] Infrastruktura: Traefik reverse proxy

### Faza 2 — Główne serwisy (26–28 styczeń 2026)
- [x] Blog: pełne API CRUD (posty, kategorie, tagi, komentarze), JWT auth, RabbitMQ consumer
- [x] Frontend: strona główna z blogiem, OAuth2 z SSO, profil użytkownika
- [x] Users: implementacja Laravel, eventy RabbitMQ, internal API, RBAC
- [x] SSO: serwer OAuth2 (Passport), integracja z Users API
- [x] Infra: RabbitMQ z routingiem Traefik, sieć wewnętrzna mikroserwisów

### Faza 3 — Admin i panel użytkownika (31 styczeń 2026)
- [x] Admin: panel z FilamentPHP
- [x] Frontend: panel użytkownika z sidebar, i18n, dropdown menu

### Faza 4 — Production hardening (6–7 luty 2026)
- [x] Secrets management (.env.example, .gitignore)
- [x] Healthchecks w docker-compose (MySQL, Redis, RabbitMQ, Traefik, Nginx)
- [x] LOG_CHANNEL=stderr (cloud native logging)
- [x] Deploy Dockerfiles (multi-stage, Alpine, hardened)
- [x] Produkcyjne konfiguracje Nginx (gzip, security headers, cache)
- [x] Kubernetes manifesty dla wszystkich serwisów (Deployments, Services, ConfigMaps, Secrets, Ingress, StatefulSets, PVCs)
- [x] Health/ready endpoints z K8s probes

### Faza 5 — Testy i K8s (8–9 luty 2026)
- [x] Testy jednostkowe/feature dla wszystkich serwisów (243 testów łącznie)
- [x] Graceful shutdown (STOPSIGNAL SIGQUIT, preStop hooks)
- [x] InitContainers (automatyczne migracje i seedy)
- [x] Wersjonowanie obrazów K8s (v0.0.1)
- [x] Widoki kategorii, tagów, posta z paginacją (frontend)

### Faza 6 — Integracja i finalizacja (10–11 luty 2026)
- [x] Standaryzacja nazw zmiennych ({SERVICE}_API_URL_INTERNAL)
- [x] OpenAPI dokumentacja (blog, users)
- [x] SSO OAuth2 dla panelu admin
- [x] Analytics — nowy mikroserwis (zbieranie wyświetleń postów, agregacja, API)
- [x] Frontend integracja z analytics (post.viewed → RabbitMQ)
- [x] K8s manifesty dla analytics
- [x] Monitoring stack (Prometheus, Loki, Promtail, Grafana + dashboardy)
- [x] Traefik TLS certificates, OCI labels, GHCR namespace

---

## TODO — otwarte zadania

### Frontend

- [ ] **Widok czytania posta** — treść posta w środkowej kolumnie (layout jak strona główna), przycisk edycji dla autora, lista zatwierdzonych komentarzy z lazy-loading (domyślnie ostatni, rozwijanie po 10)
- [ ] **Edycja posta** — widok w panelu użytkownika: edycja treści, przypisanie kategorii, tagi, slug; post wymaga zatwierdzenia przez moderatora
- [ ] **Lista postów użytkownika** — tabela z paginacją (tytuł, slug, fragment treści, daty, kategoria, tagi), akcje edit/delete
- [ ] **Panel autora — statystyki wyświetleń** — widok "Moje posty" z liczbą wyświetleń per post (dane z analytics API)

### Blog

- [ ] **Testy ConsumeUserEvents** — pokrycie komendy RabbitMQ consumer (obecnie 0%)

### Admin

- [ ] **Analytics dashboard** — dashboard Filament ze statystykami wyświetleń postów

### Analytics

- [ ] **Testy jednostkowe i E2E** — pokrycie testami serwisu analytics
- [ ] **Zaawansowane statystyki** — analityka per kategoria/tag (porównania, trendy w czasie)
- [ ] **Wykresy i wizualizacje** — interaktywne wykresy w dashboardach admin + panel autora (trendy dzienne/tygodniowe/miesięczne, rozkład per kategoria/tag, porównanie postów)

### SSO

- [ ] **Testy AuthorizationViewResponse** — pokrycie klasy (obecnie 0%)

### Users

- [ ] **Testy RabbitMQ update event** — naprawa 2 failing testów (event dispatch przy update)

### Infra — Docker Compose

- [ ] **Usunąć hardcoded container_name** — umożliwi `docker compose up --scale`
- [ ] **Limity zasobów** — `deploy.resources.limits` (CPU, memory) dla serwisów
- [ ] **Rotacja logów** — `logging.driver` json-file z `max-size` i `max-file`

### Infra — Kubernetes

- [ ] **Ingress Controller** — zainstalować nginx-ingress lub Traefik for K8s w klastrze
- [ ] **TLS** — cert-manager (Let's Encrypt) lub ręczne certyfikaty, domeny produkcyjne
- [ ] **Secrets management (prod)** — wybór strategii (Sealed Secrets / External Secrets Operator + Vault / manual kubectl)
- [ ] **NetworkPolicy** — izolacja sieci per serwis (zastąpienie Docker network isolation)
- [ ] **Komunikacja między serwisami** — zezwolić tylko wymagane połączenia (admin→users, frontend→blog/users/sso, etc.)

### CI/CD

- [ ] **GitHub Actions CI** — lint, testy, budowa obrazu Docker przy push/PR
- [ ] **GitHub Actions CD** — push do ghcr.io, aktualizacja tagu w K8s Deployment, apply do klastra
- [ ] **Konwencja nazw obrazów** — `ghcr.io/szymonborowski/portfolio-{service}:{tag}` (SHA/semver, unikać :latest)
- [ ] **Strategia migracji DB** — K8s Job lub init container przed rollout

### Skalowanie i wydajność

- [ ] **Resource tuning** — load testy, dostosowanie CPU/memory requests/limits
- [ ] **Metrics-server** — instalacja w klastrze
- [ ] **HPA** — Horizontal Pod Autoscaler dla frontend, sso, admin (wg CPU)
- [ ] **KEDA** — skalowanie blog-consumer i analytics-consumer wg długości kolejki RabbitMQ

### Bazy danych (produkcja)

- [ ] **Managed DB vs in-cluster** — decyzja (RDS/Cloud SQL vs MySQL StatefulSet)
- [ ] **Backupy** — CronJob z mysqldump lub Velero (jeśli in-cluster)
- [ ] **Replikacja MySQL** — HA (jeśli in-cluster)

### Monitoring — rozszerzenie

- [ ] **Alerty** — reguły na restarty podów, wysoki error rate, błędy połączeń do DB
- [ ] **K8s monitoring** — wdrożenie Prometheus/Loki/Grafana w klastrze (obecnie tylko docker-compose dev)

### Research (przyszłość)

- [ ] **Data Analytics z Python** — Pandas, Jupyter Notebooks, predykcje trendów (scikit-learn, Prophet), integracja z analytics (osobny kontener, API/RabbitMQ)

---

## Pokrycie testami (pomiar 2026-02-08)

| Serwis | Linie | Testy | Priorytetowe braki |
|--------|-------|-------|--------------------|
| Users | 87.8% | 49 | RabbitMQ update event (2 failing) |
| SSO | 83.7% | 22 | AuthorizationViewResponse (0%) |
| Blog | 80.1% | 98 | ConsumeUserEvents (0%) |
| Admin | 73.0% | 28 | — |
| Frontend | 61.4% | 46 | HomeController (~0%) |
| Analytics | — | — | brak testów |
