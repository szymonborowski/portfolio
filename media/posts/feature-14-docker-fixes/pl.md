---
title: "Stabilizacja Docker — vendor, MySQL 8.0 i unifikacja .env"
date: 2026-03-22
category: "Dev Log"
tags: [Docker, docker-compose, MySQL, devops, configuration, vendor, environment]
locale: pl
---

Po kilku tygodniach rozwijania mikroserwisów trafiłem na serię problemów, które powtarzały się przy każdym `docker compose up` -- znikający vendor/, niekompatybilny MySQL i rozjeżdżające się dane logowania do baz. Jeden dzień na naprawienie tego we wszystkich sześciu serwisach.

## vendor/ znika po starcie kontenera

Problem był podstępny. W `docker-compose.yml` montuję cały katalog `src/` jako bind mount, żeby mieć hot-reload przy developmencie. Dockerfile uruchamia `composer install` przy budowaniu obrazu, więc vendor/ jest w kontenerze. Ale po starcie bind mount nadpisuje cały `src/` treścią z hosta -- a na hoście `vendor/` jest pusty albo nie istnieje. Efekt: kontener startuje, Laravel nie widzi żadnej paczki, aplikacja pada.

Rozwiązanie to **named volume** zamontowany na ścieżce vendor/ wewnątrz kontenera. Named volume ma wyższy priorytet niż bind mount i zachowuje zawartość z obrazu:

```yaml
services:
  app:
    volumes:
      - ./src:/var/www/html
      - vendor_data:/var/www/html/vendor

volumes:
  vendor_data:
```

Docker przy pierwszym starcie kopiuje zawartość vendor/ z obrazu do named volume. Kolejne starty używają tego samego wolumenu. Bind mount na `src/` dalej działa normalnie, ale vendor/ jest chroniony. Po `composer require` w kontenerze zmiany zostają w wolumenie -- nie znikają po restarcie.

## MySQL 8.4 łamie połączenia

Drugi problem objawiał się błędem `Access denied` mimo poprawnych danych logowania. Przyczyna: w `docker-compose.yml` miałem `mysql:8`, co po aktualizacji obrazu ściągnęło MySQL 8.4. Wersja 8.4 zmieniła domyślny plugin autoryzacji z `mysql_native_password` na `caching_sha2_password`. Laravel z domyślnym driverem PDO nie obsługuje tego pluginu bez dodatkowej konfiguracji.

Najprostsze rozwiązanie -- **przypięcie obrazu do mysql:8.0**:

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USERNAME}
      MYSQL_PASSWORD: ${DB_PASSWORD}
```

MySQL 8.0 używa `mysql_native_password` domyślnie. Kiedy będziemy gotowi na migrację do nowszej wersji, zrobimy to świadomie z odpowiednią konfiguracją pluginu.

## Unifikacja danych logowania do baz

Każdy serwis miał inne nazwy użytkowników i haseł do bazy -- coś wymyślonego na szybko przy tworzeniu każdego `.env`. Przy sześciu serwisach to sześć różnych nazw użytkowników, sześć haseł i zero możliwości debugowania, które hasło pasuje do którego serwisu.

Ujednoliciłem schemat: **nazwa użytkownika = nazwa serwisu**, wspólne hasło developerskie. Przykład dla serwisu blog:

```env
DB_DATABASE=blog
DB_USERNAME=blog
DB_PASSWORD=secret_dev
```

To samo dla sso, admin, users, analytics, frontend. Każdy serwis ma własną bazę i własnego użytkownika, ale wzorzec jest identyczny. Debugowanie staje się trywialne.

## bootstrap/cache w .gitignore

Ostatnia zmiana -- wykluczenie `bootstrap/cache/` z repozytorium. Pliki w tym katalogu są generowane przez Laravela (cache konfiguracji, routing, serwisy). Commity z tymi plikami powodowały konflikty przy merge'ach i niepotrzebny szum w diffach. Teraz `.gitignore` zawiera `bootstrap/cache/*` i każde środowisko generuje swój cache lokalnie.

## Podsumowanie

Cztery zmiany zastosowane do wszystkich sześciu serwisów: named volume na vendor/, MySQL przypięty do 8.0, ujednolicone dane logowania i wyczyszczony .gitignore. Środowisko developerskie startuje teraz bez niespodzianek.
