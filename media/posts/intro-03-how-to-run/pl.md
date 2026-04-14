---
title: "Jak uruchomić projekt lokalnie"
date: 2026-01-28
category: "Intro"
tags: [intro, docker, instalacja, devops, local-dev]
locale: pl
---

Ten post to praktyczny przewodnik — jak sklonować repozytorium, skonfigurować środowisko i uruchomić cały system na swoim komputerze. Jednym skryptem.

## Wymagania

Zanim zaczniesz, upewnij się że masz zainstalowane:

- **git**
- **Docker Engine 24+** z Docker Compose v2
- **[mkcert](https://github.com/FiloSottile/mkcert)** — do generowania lokalnych certyfikatów TLS

Na Ubuntu/Debian mkcert zainstalujesz przez:

```bash
sudo apt install mkcert
```

Na macOS:

```bash
brew install mkcert
```

## Klonowanie i instalacja

```bash
git clone https://github.com/szymonborowski/portfolio.git
cd portfolio
./install.sh
```

Skrypt `install.sh` wykonuje automatycznie kilka kroków:

1. Klonuje repozytoria wszystkich mikroserwisów do podkatalogów
2. Tworzy pliki `.env` na podstawie `.env.example` dla każdego serwisu
3. Generuje losowe hasła, klucze API i sekrety OAuth2
4. Generuje certyfikaty TLS przez `mkcert` dla wszystkich lokalnych domen
5. Dodaje domeny do `/etc/hosts`
6. Tworzy wymagane sieci Docker

> Skrypt poprosi o hasło `sudo` — jest potrzebne wyłącznie do modyfikacji `/etc/hosts`.

## Uruchomienie

Po zakończeniu instalacji:

```bash
./dev.sh up -d --build
```

`dev.sh` to pomocniczy skrypt opakowujący `docker compose`. Możesz też uruchomić tylko wybrane serwisy:

```bash
./dev.sh up -d --build -- blog admin
```

Lub sprawdzić logi konkretnego serwisu:

```bash
./dev.sh logs -f -- frontend
```

## Dostępne adresy

Po uruchomieniu system jest dostępny pod następującymi adresami (domyślna domena to `microservices.local`):

| Serwis | Adres |
|--------|-------|
| Frontend | `https://frontend.microservices.local` |
| SSO | `https://sso.microservices.local` |
| Admin | `https://admin.microservices.local` |
| Blog API | `https://blog.microservices.local` |
| Traefik Dashboard | `https://traefik.microservices.local` |
| RabbitMQ | `https://rabbitmq.microservices.local` |
| Grafana | `https://grafana.microservices.local` |
| Prometheus | `https://prometheus.microservices.local` |

## Własna domena lokalna

Jeśli `microservices.local` koliduje z czymś w Twoim środowisku, możesz użyć innej domeny:

```bash
./install.sh --domain myapp.local
```

## Czysty reset

Jeśli chcesz zacząć od zera:

```bash
./install.sh --purge
```

To zatrzyma wszystkie serwisy i usunie sklonowane repozytoria. Potem możesz ponownie uruchomić `./install.sh`.

---

Jeśli coś nie zadziała — chętnie pomogę. Kod jest publiczny, więc możesz też zajrzeć bezpośrednio do repozytoriów poszczególnych serwisów.
