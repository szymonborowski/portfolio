---
title: "Dlaczego mikroserwisy do bloga? Analiza decyzji architektonicznej"
date: 2026-01-29
category: "Architektura"
tags: [microservices, Laravel, architecture, Docker, RabbitMQ]
locale: pl
---

## Skąd w ogóle ten pomysł?

Kiedy zaczynałem budować portfolio, stałem przed klasycznym wyborem: monorepo z Laravelem, które działa od pierwszego dnia, albo coś bardziej ambitnego. Wybrałem to drugie — i mam co do tego mieszane uczucia, ale w pozytywnym sensie.

Celem nie była "najlepsza architektura do bloga". Celem było **stworzenie platformy, która będzie służyła jako żywe demo moich umiejętności**. Blog jest tylko pretekstem.

## Co wchodzi w skład systemu?

System składa się z 6 serwisów:

- **Frontend** — Laravel + Blade, serwuje strony użytkownikom
- **Blog** — Laravel API, zarządza postami, komentarzami, kategoriami, tagami
- **Users** — Laravel API, zarządza użytkownikami, RBAC
- **SSO** — serwer OAuth2 oparty na Laravel Passport
- **Admin** — panel administracyjny oparty na FilamentPHP
- **Analytics** — zbiera wyświetlenia postów i agreguje statystyki

Każdy serwis ma własną bazę danych MySQL, własny kontener, własne testy.

## Komunikacja między serwisami

Serwisy komunikują się na dwa sposoby:

### HTTP (synchroniczne)
Frontend wywołuje Blog API i Users API bezpośrednio przez wewnętrzną sieć Dockera. Używam `X-Internal-Api-Key` jako prostego mechanizmu autoryzacji między serwisami.

### RabbitMQ (asynchroniczne)
Kiedy użytkownik wyświetla post, Frontend publikuje event `post.viewed` do RabbitMQ. Analytics consumer odbiera go i zapisuje do bazy. Kiedy użytkownik zmienia dane w Users, event `user.updated` trafia do Blog, który aktualizuje swoją lokalną kopię autora.

```
Frontend ──HTTP──▶ Blog API
Frontend ──HTTP──▶ Users API
Frontend ──RabbitMQ──▶ Analytics
Users ──RabbitMQ──▶ Blog (synchronizacja autorów)
```

## Czy to był dobry pomysł?

**Zalety:**
- Każdy serwis można deployować niezależnie
- Naturalna izolacja odpowiedzialności
- Świetny materiał do nauki Kubernetes, ArgoCD, CI/CD
- Demo, które można pokazać na rozmowie kwalifikacyjnej

**Wady:**
- Dużo boilerplate na start (6 razy to samo scaffolding)
- Debugowanie przez sieć jest trudniejsze niż w monolicie
- Overhead infrastrukturalny (RabbitMQ, Traefik, osobne bazy)

Gdybym budował "prawdziwy" produkt od zera, pewnie wybrałbym monolit. Ale to nie jest "prawdziwy" produkt — to platforma do nauki i demo. I jako takie, spełnia swoje zadanie znakomicie.
