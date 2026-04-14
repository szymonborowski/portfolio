---
title: "Automatyzacja środowiska — install.sh"
date: 2026-03-21
category: "Dev Log"
tags: [devops, docker, automation, bash, mkcert, TLS, install]
locale: pl
---

Siedem repozytoriów, kilkanaście plików .env, certyfikaty TLS, wpisy w /etc/hosts, sieci Dockera, klucze Passport -- ustawienie tego wszystkiego ręcznie to dobra godzina klikania i kopiowania. Napisałem skrypt, który robi to w jednym poleceniu.

## Problem

Projekt składa się z siedmiu mikroserwisów: infra, frontend, sso, admin, users, blog, analytics. Każdy ma swój `docker-compose.yml`, swój `.env` na poziomie Compose i osobny `src/.env` dla Laravela. Domena pojawia się w kilkudziesięciu miejscach. Sekrety (klucze API, hasła baz, klucze Passport OAuth2) muszą być spójne między serwisami. Do tego certyfikaty TLS dla kilkunastu subdomen i wpisy DNS w `/etc/hosts`.

Robiłem to ręcznie przez kilka tygodni. Za każdym razem, kiedy chciałem postawić środowisko od zera, traciłem czas na te same kroki. Czas to zautomatyzować.

## Jak działa install.sh

Skrypt wykonuje wszystko sekwencyjnie w jednym przebiegu:

```bash
./install.sh
# lub z parametrami:
./install.sh --domain myapp.local --repo-base git@github.com:myuser
```

Główna pętla klonuje repozytoria na podstawie tablicy serwisów:

```bash
SERVICES=(
  "infra:infrastructure_service"
  "frontend:frontend_service"
  "sso:sso_service"
  "admin:admin_service"
  "users:users_service"
  "blog:blog_service"
  "analytics:analytics_service"
)

for entry in "${SERVICES[@]}"; do
  dir="${entry%%:*}"
  repo="${entry##*:}"
  git clone "${REPO_BASE}/${repo}.git" "$dir"
done
```

Po sklonowaniu skrypt kopiuje `.env.example` do `.env` dla każdego serwisu, podmienia domenę przez `sed`, ustawia UID/GID hosta i konfiguruje połączenia do baz danych w Laravelowych `src/.env`.

## Generowanie sekretów

Sekrety generowane są przez `openssl rand` i wstrzykiwane do plików .env za pomocą funkcji `env_set_once`, która nadpisuje wartość tylko wtedy, gdy jest pusta. Dzięki temu ponowne uruchomienie skryptu nie nadpisze istniejących kluczy:

```bash
env_set_once() {
  local f="$1" k="$2" v="$3"
  [ -f "$f" ] || return 0
  local current
  current=$(grep "^${k}=" "$f" | cut -d= -f2) || true
  [ -n "$current" ] && return 0
  sed -i "s|^${k}=.*|${k}=${v}|" "$f"
}
```

Skrypt generuje i dystrybuuje: hasło RabbitMQ, hasła MySQL, klucz klienta SSO OAuth2, wewnętrzne klucze API do Users i Analytics, oraz `APP_KEY` dla każdego serwisu Laravel.

## Certyfikaty TLS

`mkcert` generuje certyfikaty dla domeny bazowej i wszystkich subdomen (frontend, sso, admin, traefik, rabbitmq, grafana...). Certyfikaty lądują w `infra/certs/`, a certyfikaty Vite są kopiowane do `frontend/src/certs/`. Traefik korzysta z nich w konfiguracji dynamicznej generowanej przez `envsubst`.

## Purge i ponowna instalacja

Flaga `--purge` zatrzymuje wszystkie serwisy, usuwa sklonowane katalogi i wolumeny baz danych. Po purge można uruchomić `./install.sh` od nowa -- czyste środowisko w kilka minut.

## Podsumowanie

Jeden skrypt zastępuje kilkadziesiąt ręcznych kroków. Nowy członek zespołu może postawić całe środowisko jednym poleceniem, bez czytania dokumentacji konfiguracyjnej. Skrypt jest idempotentny -- pomija kroki, które już zostały wykonane, i nie nadpisuje istniejących plików.
