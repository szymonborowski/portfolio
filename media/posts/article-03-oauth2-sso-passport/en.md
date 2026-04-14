---
title: "OAuth2 SSO from scratch with Laravel Passport — how it works under the hood"
date: 2026-02-04
category: "Backend"
tags: [OAuth2, SSO, Laravel, Passport, PHP, security, authentication]
locale: en
---

## Why build your own SSO?

My system has several clients that need authentication: Frontend, Admin. Instead of duplicating login logic in every service, I extracted it into a separate SSO microservice based on OAuth2.

Benefits:
- A single point for managing sessions and tokens
- Changing a password in one place → all clients affected
- Ability to add 2FA, social login, etc. without changes to the clients

## Laravel Passport as an OAuth2 server

Laravel Passport is a full OAuth2 implementation built on top of `league/oauth2-server`. It supports grant types: Authorization Code, Client Credentials, Password (deprecated), Refresh Token.

In my project I use **Authorization Code with PKCE** — the most secure flow for web applications.

## What does the flow look like?

```
1. User clicks "Log in" on Frontend
2. Frontend redirects to SSO: /oauth/authorize?client_id=...&redirect_uri=...&code_challenge=...
3. SSO displays the login page
4. User submits credentials → SSO verifies through Users API
5. SSO redirects back: /oauth/callback?code=AUTH_CODE
6. Frontend exchanges AUTH_CODE for access_token + refresh_token (POST /oauth/token)
7. access_token is stored in the session and used for API calls
```

## Password verification through Users API

SSO does not have its own user database — it delegates verification to the Users API via an internal endpoint:

```php
// SSO AuthController
$response = Http::withHeaders([
    'X-Internal-Api-Key' => config('services.users.internal_key'),
])->post(config('services.users.url') . '/api/internal/verify-password', [
    'email' => $request->email,
    'password' => $request->password,
]);
```

This way Users is the only service that "knows" the passwords. SSO just asks.

## Refresh token and session expiration

The access_token expires after 1 hour. On every request to the API the frontend checks whether the token has expired and, if needed, requests a new token from SSO using the refresh_token.

```php
if ($this->isTokenExpired($session->get('expires_at'))) {
    $newTokens = $this->refreshAccessToken($session->get('refresh_token'));
    $session->put('access_token', $newTokens['access_token']);
}
```

## Admin client (FilamentPHP)

The Admin panel uses the same SSO — I implemented a separate OAuth2 client with a `redirect_uri` pointing to the admin domain. Filament receives the token and makes API calls with Bearer auth.
