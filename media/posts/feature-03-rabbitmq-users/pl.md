---
title: "RabbitMQ i wewnętrzne API serwisów"
date: 2026-01-28
category: "Dev Update"
tags: [rabbitmq, users, blog, sso, api, eventy, mikroserwisy]
locale: pl
---

Serwisy zaczęły ze sobą rozmawiać. Nie przez wspólną bazę danych — przez kolejkę komunikatów i dedykowane wewnętrzne API. To krok, który oddziela synchroniczne wywołania od asynchronicznych zdarzeń.

**Serwisy: Users, Blog**

## Wewnętrzne API Users dla SSO

SSO musi pobierać dane użytkownika przy każdym żądaniu do `/api/user`. Zamiast wspólnej bazy danych — **Users** udostępnia wewnętrzne API chronione kluczem API. Tylko SSO zna ten klucz. Komunikacja odbywa się wewnątrz sieci Dockera, port nie jest eksponowany na zewnątrz.

```
GET /internal/users/{id}
X-Api-Key: <service-key>
```

Odpowiedź zawiera pełny profil użytkownika z rolami. SSO dokłada te dane do odpowiedzi `/api/user`.

## Zdarzenia RabbitMQ z Users

Kiedy stan użytkownika się zmienia — rejestracja, aktualizacja profilu, zmiana roli — **Users** publikuje zdarzenie do RabbitMQ. Inne serwisy subskrybują i reagują asynchronicznie.

```php
// Publikowanie zdarzenia
$this->rabbitMQ->publish('user.updated', [
    'id'    => $user->id,
    'email' => $user->email,
    'name'  => $user->name,
]);
```

Zdarzenia używają routingu opartego na topic exchange. Klucz `user.updated` trafia do wszystkich kolejek, które subskrybują `user.*`.

## Consumer w Blog Service

**Blog** nasłuchuje na zdarzenia `user.*` i synchronizuje dane autorów lokalnie. Dzięki temu Blog nie odpytuje Users przy każdym żądaniu — ma własną tabelę `authors` zaktualizowaną przez consumera.

Jeśli użytkownik zmieni imię w Users, consumer w Blog zaktualizuje rekord autora automatycznie. Zero zapytań cross-serwisowych w ścieżce żądania.

## OAuth2 flow w Frontend

Frontend dostał pełny przepływ OAuth2 — od przycisku "Zaloguj się" do przechowywania tokenu w sesji. Kroki:

1. Generowanie `code_verifier` i `code_challenge`
2. Przekierowanie do SSO `/oauth/authorize`
3. Odbiór kodu w `/auth/callback`
4. Wymiana kodu na token przez SSO
5. Zapis access tokenu i refresh tokenu w sesji Redis

> Refresh token jest przechowywany tylko po stronie serwera w Redis — nigdy nie trafia do przeglądarki. Access token ma krótki TTL, refresh token jest długożyciowy.
