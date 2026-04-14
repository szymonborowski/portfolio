---
title: "OAuth2 SSO od zera z Laravel Passport — jak to działa pod maską"
date: 2026-02-04
category: "Backend"
tags: [OAuth2, SSO, Laravel, Passport, PHP, security, authentication]
locale: pl
---

## Po co własne SSO?

W systemie mam kilku klientów, którzy potrzebują uwierzytelniania: Frontend, Admin. Zamiast duplikować logikę logowania w każdym serwisie, wyodrębniłem ją do osobnego mikroserwisu SSO opartego na OAuth2.

Benefity:
- Jeden punkt zarządzania sesjami i tokenami
- Zmiana hasła w jednym miejscu → wszystkie klienty dotknięte
- Możliwość dodania 2FA, social login itp. bez zmian w klientach

## Laravel Passport jako serwer OAuth2

Laravel Passport to pełna implementacja OAuth2 na bazie `league/oauth2-server`. Wspiera grant types: Authorization Code, Client Credentials, Password (deprecated), Refresh Token.

W moim projekcie używam **Authorization Code z PKCE** — najbezpieczniejszy flow dla aplikacji webowych.

## Jak wygląda flow?

```
1. Użytkownik klika "Zaloguj się" na Frontend
2. Frontend przekierowuje na SSO: /oauth/authorize?client_id=...&redirect_uri=...&code_challenge=...
3. SSO pokazuje stronę logowania
4. Użytkownik podaje dane → SSO weryfikuje przez Users API
5. SSO przekierowuje z powrotem: /oauth/callback?code=AUTH_CODE
6. Frontend wymienia AUTH_CODE na access_token + refresh_token (POST /oauth/token)
7. access_token trafia do sesji, używany do wywołań API
```

## Weryfikacja hasła przez Users API

SSO nie ma własnej bazy użytkowników — deleguje weryfikację do Users API przez internal endpoint:

```php
// SSO AuthController
$response = Http::withHeaders([
    'X-Internal-Api-Key' => config('services.users.internal_key'),
])->post(config('services.users.url') . '/api/internal/verify-password', [
    'email' => $request->email,
    'password' => $request->password,
]);
```

Dzięki temu Users jest jedynym serwisem, który "zna" hasła. SSO tylko pyta.

## Refresh token i wygasanie sesji

access_token wygasa po 1 godzinie. Przy każdym żądaniu do API frontend sprawdza czy token nie wygasł i w razie potrzeby odpytuje SSO o nowy token przy pomocy refresh_token.

```php
if ($this->isTokenExpired($session->get('expires_at'))) {
    $newTokens = $this->refreshAccessToken($session->get('refresh_token'));
    $session->put('access_token', $newTokens['access_token']);
}
```

## Klient Admin (FilamentPHP)

Admin panel używa tego samego SSO — zaimplementowałem osobny OAuth2 client z `redirect_uri` wskazującym na domenę admina. Filament dostaje token i robi API calls z Bearer auth.
