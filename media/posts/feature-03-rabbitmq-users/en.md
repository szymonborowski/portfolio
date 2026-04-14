---
title: "RabbitMQ and internal service APIs"
date: 2026-01-28
category: "Dev Update"
tags: [rabbitmq, users, blog, sso, api, events, microservices]
locale: en
---

Services started talking to each other. Not through a shared database — through a message queue and dedicated internal APIs. This is the step that separates synchronous calls from asynchronous events.

**Services: Users, Blog**

## Internal Users API for SSO

SSO needs to fetch user data on every request to `/api/user`. Instead of a shared database — **Users** exposes an internal API protected by an API key. Only SSO knows this key. Communication happens inside the Docker network; the port is not exposed externally.

```
GET /internal/users/{id}
X-Api-Key: <service-key>
```

The response contains the full user profile with roles. SSO appends this data to the `/api/user` response.

## RabbitMQ events from Users

When a user's state changes — registration, profile update, role change — **Users** publishes an event to RabbitMQ. Other services subscribe and react asynchronously.

```php
// Publishing an event
$this->rabbitMQ->publish('user.updated', [
    'id'    => $user->id,
    'email' => $user->email,
    'name'  => $user->name,
]);
```

Events use topic exchange-based routing. The key `user.updated` reaches all queues that subscribe to `user.*`.

## Consumer in Blog Service

**Blog** listens for `user.*` events and synchronizes author data locally. This way Blog doesn't query Users on every request — it has its own `authors` table updated by the consumer.

If a user changes their name in Users, the consumer in Blog updates the author record automatically. Zero cross-service queries in the request path.

## OAuth2 flow in Frontend

Frontend got the full OAuth2 flow — from the "Log in" button to storing the token in the session. Steps:

1. Generate `code_verifier` and `code_challenge`
2. Redirect to SSO `/oauth/authorize`
3. Receive code at `/auth/callback`
4. Exchange code for token via SSO
5. Save access token and refresh token to Redis session

> The refresh token is stored server-side only in Redis — it never reaches the browser. The access token has a short TTL, the refresh token is long-lived.
