---
title: "Traefik v3 jako reverse proxy — routing, TLS i dashboard w praktyce"
date: 2026-02-01
category: "DevOps"
tags: [Traefik, Docker, nginx, TLS, reverse-proxy, infrastructure]
locale: pl
---

## Czym jest Traefik?

Traefik to nowoczesny reverse proxy i load balancer, który odróżnia się od Nginx tym, że **konfiguruje się dynamicznie**. Zamiast ręcznie pisać bloki `server {}`, Traefik czyta labele z kontenerów Dockera i sam buduje routing.

## Podstawowa konfiguracja

W `docker-compose.prod.yml` Traefik uruchamiam jako pierwszy serwis:

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

Kluczowe decyzje:
- `exposedbydefault=false` — serwis musi explicite dodać label `traefik.enable=true`, żeby być wystawiony
- Redirect z HTTP na HTTPS jest globalny, jeden wpis, działa dla wszystkich serwisów

## Routing przez labele

Każdy serwis, który chcę wystawić publicznie, dostaje etykiety:

```yaml
frontend:
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.frontend.rule=Host(`portfolio.example.com`)"
    - "traefik.http.routers.frontend.entrypoints=websecure"
    - "traefik.http.routers.frontend.tls=true"
    - "traefik.http.services.frontend.loadbalancer.server.port=80"
```

Serwisy wewnętrzne (Blog API, Users API) są w osobnej sieci i nie mają tych labeli — dostępne tylko z sieci `microservices`.

## TLS z własnymi certyfikatami

W projekcie używam własnych certyfikatów (dev) lub Let's Encrypt (produkcja). Konfiguracja TLS jest w pliku dynamicznym:

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

Dashboard Traefika jest bardzo przydatny do debugowania — pokazuje aktywne routery, serwisy i middleware. Zabezpieczam go osobną domeną z Basic Auth przez middleware:

```yaml
- "traefik.http.routers.dashboard.rule=Host(`traefik.example.com`)"
- "traefik.http.routers.dashboard.middlewares=auth@file"
```

## Co mi się podoba w Traefikie?

Największy plus to **zero restartów przy zmianie konfiguracji**. Dodam nowy kontener z odpowiednimi labelami, Traefik wykryje go w ciągu sekund i zacznie routować ruch. W Nginx musiałbym edytować plik konfiguracyjny i przeładować serwis.

Minusem jest krzywa uczenia się — składnia labeli jest specyficzna i łatwo o literówkę, która cicho nic nie robi.
