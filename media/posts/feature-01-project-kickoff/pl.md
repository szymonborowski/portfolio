---
title: "Start projektu — pierwsze cztery mikroserwisy"
date: 2026-01-26
category: "Feature Update"
tags: [kickoff, laravel, docker, microservices, blog, frontend, sso, users]
locale: pl
---

Każdy projekt ma swój pierwszy dzień. Tutaj opisuję, jak wyglądał start — postawienie czterech pierwszych serwisów, konfiguracja Dockera i zdefiniowanie tego, co każdy serwis ma robić.

**Serwisy: Blog, Frontend, SSO, Users**

## Blog Service

Jako pierwszy powstał Blog Service — to on jest sercem systemu. Setup to klasyczny Docker z PHP 8.5, Nginx jako web server, MySQL jako baza danych. Na tym etapie głównym celem było przygotowanie środowiska deweloperskiego, które będzie działać tak samo lokalnie jak i na produkcji. Laravel 12 jako framework, Dockerfile z wieloetapowym buildem w planach na później. Na razie: działa, jest kontenerem, komunikuje się z bazą.

## Frontend Service

Frontend to główna aplikacja, którą widzi użytkownik. Podobna konfiguracja Dockera — PHP 8.5, Nginx, Redis do zarządzania sesjami. Laravel tutaj działa jako tradycyjna aplikacja webowa renderująca widoki, nie jako API. To celowe rozwiązanie: chciałem, żeby blog był dostępny bez JavaScript-heavy SPAs, z normalnym server-side renderingiem. Redis od razu w składzie, bo sesje OAuth2 muszą być gdzieś trzymane po stronie serwera.

## SSO Service

SSO to serwer autoryzacji OAuth2. Tutaj odbywa się  zarządzanie tokenamiy i przepływ logowania. Na tym etapie: podstawowy setup Dockera z Laravel, gotowy do instalacji Laravel Passport w kolejnym kroku. Serwis ma być punktem wejścia dla wszystkich operacji związanych z tożsamością użytkownika.

## Users Service

Users to rejestr użytkowników, ról i uprawnień systemu. Jako oddzielny serwis — zamiast tabeli `users` w każdej bazie — gwarantuje, że dane użytkownika mają jedno źródło prawdy. Na etapie kickoffu: podstawowy setup identyczny jak inne serwisy, gotowy na dalszy rozwój.

## Co dalej

Cztery serwisy stoją. Każdy ma własny kontener, własną bazę danych, własną konfigurację Nginx. W kolejnym kroku — implementacja Blog API od podstaw wraz z autoryzacją JWT i pierwszą integracją OAuth2 między Frontend i SSO.
