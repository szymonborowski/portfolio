---
title: "Kompletne Blog API, autoryzacja JWT i OAuth2"
date: 2026-01-27
category: "Feature Update"
tags: [blog, api, jwt, oauth2, laravel-passport, sso, frontend, testy]
locale: pl
---

Ten krok był jednym z największych w całym projekcie. Blog API przeszło od szkieletu do kompletnego zestawu endpointów z testami, SSO dostało pełną implementację OAuth2, a Frontend po raz pierwszy zalogował użytkownika. Sporo rzeczy naraz — ale wszystkie ze sobą powiązane.

**Serwisy: Blog, SSO, Frontend**

## Blog Service — kompletne API

Blog API składa się z czterech modułów:

**Post API** — pełen CRUD dla postów. Endpointy dla listy postów (z paginacją, filtrowaniem po kategorii i tagu), pojedynczego posta, tworzenia, edycji i usuwania. Każda operacja modyfikująca wymaga autoryzacji.

**Category API** — kategorie z hierarchią (rodzic-dziecko). Dzięki temu można budować drzewa kategorii, co daje elastyczność w organizacji treści.

**Tag API** — tagi przypisane do postów. Prosty CRUD z walidacją unikalności nazwy.

**Comment API** — komentarze z moderacją. Komentarz po dodaniu trafia do stanu "oczekujący", moderator (przez panel Admin) zatwierdza lub odrzuca. To zapobiega spamowi bez potrzeby natychmiastowej moderacji ręcznej.

Wszystkie cztery moduły mają testy — zarówno unit jak i feature testy pokrywające happy path i scenariusze błędów.

**Autoryzacja JWT z custom guardem** — Blog API jest bezstanowe. Zamiast sesji, każde żądanie niesie token JWT w nagłówku `Authorization: Bearer`. Napisałem własny guard dla Laravel, który weryfikuje token i ustala kontekst użytkownika bez odpytywania bazy przy każdym żądaniu.

## SSO Service — implementacja OAuth2

Laravel Passport dostarcza solidną implementację protokołu OAuth2. Skonfigurowałem przepływ Authorization Code Grant — ten sam, którego używa "Login with Google". Frontend przekierowuje do SSO z parametrami żądania, użytkownik loguje się, SSO zwraca kod autoryzacyjny, Frontend wymienia go na access token i refresh token.

Passport automatycznie obsługuje odnawianie tokenów, co usuwa z Frontendu potrzebę zarządzania czasem życia sesji.

## Frontend Service — integracja OAuth2 i strona główna

Frontend zaimplementował klienta OAuth2: przechowywanie tokenów, odświeżanie, wylogowywanie. Strona główna pokazuje listę postów pobieranych z Blog API — pierwsze połączenie między serwisami widoczne dla użytkownika. Redis trzyma sesję i tokeny po stronie serwera, co jest bezpieczniejsze niż przechowywanie ich w localStorage przeglądarki.

## Czego się nauczyłem

Implementacja własnego JWT guard okazała się prosta w teorii, ale wymagała dokładnego rozumienia tego, jak Laravel ładuje guard przez `Auth::guard()`. OAuth2 z Passportem jest dobrze udokumentowany, ale trzeba zrozumieć różnicę między typami grantów — na początku przez chwilę kusiło mnie użycie prostszego Client Credentials, który jednak nie nadaje się do autoryzacji w imieniu użytkownika.
