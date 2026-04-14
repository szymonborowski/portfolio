---
title: "Serwer autoryzacji OAuth2 z Laravel Passport"
date: 2026-01-27
category: "Dev Update"
tags: [oauth2, sso, passport, laravel, pkce, autoryzacja]
locale: pl
---

SSO dostał swój rdzeń — serwer OAuth2 oparty na **Laravel Passport**. Od tej chwili każdy serwis w systemie autoryzuje się przez jeden centralny punkt. Koniec z rozproszonymi tabelami `users` i osobnymi mechanizmami logowania.

**Serwis: SSO**

## Dlaczego Passport, nie Sanctum

Sanctum świetnie nadaje się do prostych SPA z sesją cookie. Potrzebowałem jednak pełnego serwera OAuth2 — z authorization code flow, tokenami odświeżającymi i możliwością wystawiania tokenów dla zewnętrznych klientów. Passport implementuje RFC 6749 out of the box.

## Authorization Code Flow z PKCE

PKCE (Proof Key for Code Exchange) eliminuje ryzyko przechwycenia kodu autoryzacji. Frontend generuje `code_verifier` i `code_challenge` przed przekierowaniem do SSO. SSO weryfikuje parę przy wymianie kodu na token.

> PKCE jest obowiązkowy dla publicznych klientów (SPA, mobile) — bez niego authorization code flow jest podatny na atak CSRF.

Flow wygląda następująco:
1. Frontend generuje `code_verifier` i `code_challenge` (SHA-256)
2. Przekierowanie do `/oauth/authorize?code_challenge=...&code_challenge_method=S256`
3. Po zalogowaniu SSO zwraca `code` do callbacku
4. Frontend wymienia `code` + `code_verifier` na access token

## Endpoint `/api/user`

Po uzyskaniu tokenu Frontend pobiera dane zalogowanego użytkownika:

```
GET /api/user
Authorization: Bearer <access_token>
```

Odpowiedź zawiera ID, email, imię i nazwisko oraz role. To jedyny endpoint aplikacyjny w SSO — reszta to endpointy Passport.

## Seedery klientów OAuth2

Przy inicjalizacji środowiska seeder tworzy klientów OAuth2 dla Frontendu i Admina. Każdy klient ma skonfigurowany redirect URI i odpowiednie uprawnienia.

```php
// Przykład konfiguracji klienta OAuth2
Passport::client()->create([
    'name'                   => 'Frontend',
    'redirect'               => env('FRONTEND_URL') . '/auth/callback',
    'personal_access_client' => false,
    'password_client'        => false,
    'revoked'                => false,
]);
```

Seeder można uruchomić wielokrotnie — sprawdza istnienie klienta po nazwie przed utworzeniem. Wartości `client_id` i `client_secret` trafiają do zmiennych środowiskowych pozostałych serwisów.
