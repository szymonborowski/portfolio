---
title: "Dokumentacja API, monitoring i internacjonalizacja"
date: 2026-02-12
category: "Feature Update"
tags: [openapi, prometheus, loki, grafana, i18n, traefik, monitoring, dokumentacja]
locale: pl
---

Działający system to nie wszystko. Trzeba go też rozumieć — wiedzieć, jak go używać (dokumentacja), wiedzieć, co robi w danej chwili (monitoring) i oferować go w więcej niż jednym języku (i18n). Ten krok dodał wszystkie trzy elementy.

**Serwisy: Blog, Users, SSO, Infra**

## Blog i Users — dokumentacja OpenAPI

Oba serwisy dostały dokumentację API w formacie OpenAPI 3.0. Każdy endpoint opisany jest ze schematem żądania, schematem odpowiedzi, możliwymi kodami błędów i przykładowymi danymi. Dokumentacja jest generowana automatycznie z adnotacji w kodzie i hostowana pod dedykowaną ścieżką routowaną przez Traefik.

Dzięki temu każdy, kto chce zintegrować się z Blog API lub Users API, ma jedno miejsce z aktualną specyfikacją — nie musi czytać kodu źródłowego.

## SSO — tłumaczenia i18n widoków logowania

SSO serwuje HTML — formularze logowania, rejestracji, resetowania hasła. Dodałem tłumaczenia dla języka polskiego i angielskiego. Użytkownik widzi interfejs w swoim języku, a przełącznik języka zapamiętuje wybór.

Widoki logowania to pierwsza rzecz, którą widzi nowy użytkownik. Warto zadbać o to, żeby było to po polsku dla polskojęzycznych użytkowników.

## Infra — stos monitorowania

Dodałem cztery narzędzia do infrastruktury:

**Prometheus** zbiera metryki ze wszystkich serwisów Laravel (przez pakiet `spatie/laravel-prometheus` lub własne endpointy `/metrics`). Metryki obejmują czas odpowiedzi, liczbę żądań, błędy HTTP, stan połączeń z bazą danych.

**Loki** to agregator logów. Zamiast wchodzić na każdy pod i czytać logi przez `kubectl logs`, Loki zbiera wszystkie logi w jednym miejscu i udostępnia je z możliwością przeszukiwania.

**Promtail** to agent zbierający logi — uruchomiony na każdym nodzie klastra, przechwytuje logi z kontenerów i wysyła je do Loki.

**Grafana** to warstwa wizualizacji. Dashboardy pokazują metryki z Prometheusa i logi z Loki w jednym interfejsie. Skonfigurowałem podstawowe dashboardy: czas odpowiedzi per serwis, błędy 5xx w czasie, aktywność kolejek RabbitMQ.

Cały stos monitorowania dostępny jest tylko wewnętrznie — przez Traefik z wymogiem uwierzytelnienia, nie wystawiony publicznie.

## Czego się nauczyłem

Prometheus i Grafana to dosłownie osobna dziedzina wiedzy. Język zapytań PromQL jest ekspresywny, ale początkowo nieintuicyjny. Loki jest prostszy koncepcyjnie, ale wymaga dobrej konfiguracji Promtaila, żeby logi miały właściwe etykiety i były przeszukiwalne. Po pierwszym działającym dashboardzie rozumiem, dlaczego te narzędzia są standardem — możliwość przefiltrowania logów ze wszystkich serwisów naraz według przedziału czasu jest nieoceniona przy debugowaniu.
