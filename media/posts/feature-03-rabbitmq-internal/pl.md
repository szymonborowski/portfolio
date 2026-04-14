---
title: "Komunikacja między serwisami — RabbitMQ i wewnętrzne sieci"
date: 2026-01-28
category: "Feature Update"
tags: [rabbitmq, microservices, users, blog, sso, infra, internal-api, docker-network]
locale: pl
---

Izolowane serwisy to dopiero połowa drogi. Prawdziwe wyzwanie zaczyna się wtedy, gdy trzeba je sprawić, żeby ze sobą rozmawiały — bezpiecznie, niezawodnie i bez tworzenia spaghetti wzajemnych zależności. Ten krok wprowadził RabbitMQ jako broker zdarzeń oraz wewnętrzne API zabezpieczone kluczem API.

**Serwisy: Users, Blog, SSO, Infra**

## Users Service — publikowanie zdarzeń

Users stał się pierwszym serwisem publikującym zdarzenia do RabbitMQ. Kiedy zmienia się stan konta użytkownika — rejestracja, zmiana adresu e-mail, dezaktywacja konta — Users publikuje wiadomość do odpowiedniej kolejki. Inne serwisy mogą subskrybować te zdarzenia i reagować asynchronicznie, bez ścisłego powiązania z Users.

Jednocześnie Users dostał wewnętrzne API dla SSO. To dedykowany zestaw endpointów dostępnych wyłącznie przez sieć wewnętrzną, zabezpieczonych kluczem API zamiast tokenami OAuth2. SSO może zapytać Users "czy istnieje użytkownik o tym adresie e-mail?" bez wystawiania tego pytania na zewnątrz.

## Blog Service — konsument RabbitMQ

Blog potrzebuje wiedzieć o zmianach użytkowników, bo przechowuje lokalną kopię danych autora (imię, avatar) przy postach. Zamiast odpytywać Users przy każdym żądaniu, Blog słucha kolejki z Users i aktualizuje swoją lokalną kopię, gdy przyjdzie zdarzenie.

To wzorzec eventual consistency — Blog może przez chwilę mieć nieaktualne dane, ale docelowo zawsze będzie zsynchronizowany. W praktyce opóźnienie jest niezauważalne.

## SSO Service — migracja auth na Users API

Na tym etapie SSO przeszło ważną refaktoryzację: przestało zarządzać własnymi rekordami użytkowników i zaczęło polegać na Users API jako źródle prawdy. Logowanie przez Passport weryfikuje credentials przez wewnętrzne żądanie do Users, a nie przez własną tabelę `users`. Dodany został też endpoint `/api/user` zwracający dane aktualnie zalogowanego użytkownika na podstawie tokenu — standardowy endpoint wymagany przez klientów OAuth2.

## Infra — wewnętrzna sieć i zabezpieczony RabbitMQ

Docker Compose dostał dedykowaną wewnętrzną sieć o nazwie `microservices`. Serwisy komunikujące się między sobą dołączone są do tej sieci, ale nie wystawiają portów na zewnątrz hosta. Traefik jest jedynym punktem wejścia z zewnątrz.

RabbitMQ dostał konfigurację z uwierzytelnianiem: własny vhost dla projektu, dedykowany użytkownik z ograniczonymi uprawnieniami, brak domyślnego konta `guest` na innych interfejsach niż localhost. Management UI dostępne przez Traefik wyłącznie dla mnie.

## Czego się nauczyłem

RabbitMQ okazał się mniej straszny niż myślałem. Laravel ma gotową integrację przez pakiet `php-amqplib/php-amqplib`, a koncept kolejek, exchange'ów i bindingów stał się jasny po pierwszym działającym przykładzie. Trudniejsza była decyzja projektowa: gdzie przebiega granica między tym, co idzie przez RabbitMQ (zdarzenia), a tym, co idzie przez wewnętrzne API (synchroniczne zapytania). Reguła, do której doszedłem: asynchronicznie tam, gdzie odbiorca nie musi odpowiedzieć natychmiast; synchronicznie tam, gdzie żądanie czeka na wynik.
