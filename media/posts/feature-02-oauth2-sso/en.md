---
title: "OAuth2 Authorization Server with Laravel Passport"
date: 2026-01-27
category: "Dev Update"
tags: [oauth2, sso, passport, laravel, pkce, authorization]
locale: en
---

SSO got its core — an OAuth2 server built on **Laravel Passport**. From now on, every service in the system authenticates through a single central point. No more scattered `users` tables and separate login mechanisms.

**Service: SSO**

## Why Passport, not Sanctum

Sanctum works great for simple SPAs with cookie sessions. But I needed a full OAuth2 server — with authorization code flow, refresh tokens, and the ability to issue tokens for external clients. Passport implements RFC 6749 out of the box.

## Authorization Code Flow with PKCE

PKCE (Proof Key for Code Exchange) eliminates the risk of authorization code interception. Frontend generates `code_verifier` and `code_challenge` before redirecting to SSO. SSO verifies the pair when exchanging the code for a token.

> PKCE is mandatory for public clients (SPA, mobile) — without it, authorization code flow is vulnerable to CSRF attacks.

The flow looks like this:
1. Frontend generates `code_verifier` and `code_challenge` (SHA-256)
2. Redirect to `/oauth/authorize?code_challenge=...&code_challenge_method=S256`
3. After login, SSO returns a `code` to the callback
4. Frontend exchanges `code` + `code_verifier` for an access token

## The `/api/user` endpoint

After obtaining the token, Frontend fetches the logged-in user's data:

```
GET /api/user
Authorization: Bearer <access_token>
```

The response contains ID, email, full name, and roles. This is the only application endpoint in SSO — the rest are Passport endpoints.

## OAuth2 client seeders

When the environment is initialized, a seeder creates OAuth2 clients for Frontend and Admin. Each client has a configured redirect URI and appropriate permissions.

```php
// OAuth2 client configuration example
Passport::client()->create([
    'name'                   => 'Frontend',
    'redirect'               => env('FRONTEND_URL') . '/auth/callback',
    'personal_access_client' => false,
    'password_client'        => false,
    'revoked'                => false,
]);
```

The seeder can be run multiple times — it checks for the client by name before creating. The `client_id` and `client_secret` values go into environment variables of other services.
