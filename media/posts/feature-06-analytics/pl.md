---
title: "Mikroserwis analityki — śledzenie wyświetleń przez RabbitMQ"
date: 2026-02-11
category: "Dev Update"
tags: [analytics, rabbitmq, frontend, eventy, statystyki]
locale: pl
---

Nowy serwis w systemie — **Analytics**. Jego jedynym zadaniem jest zbieranie zdarzeń i produkowanie statystyk. Nie ma publicznego API — komunikuje się wyłącznie przez kolejkę RabbitMQ.

**Serwisy: Analytics, Frontend**

## Architektura bez publicznego API

Większość serwisów analitycznych to REST API, do których Frontend wysyła dane POST-em. Wybrałem inne podejście: Frontend publikuje zdarzenie do RabbitMQ, Analytics go konsumuje w tle. Zyski:

- Frontend nie czeka na odpowiedź (fire-and-forget)
- Analytics może nie działać chwilowo bez straty zdarzeń — kolejka je buforuje
- Łatwe skalowanie consumera niezależnie od Frontendu

## Wysyłanie zdarzenia z Frontend

Po wyświetleniu posta Frontend publikuje zdarzenie `post.viewed`:

```php
// Frontend — wysłanie zdarzenia
$this->analyticsApi->trackView([
    'post_id'    => $post->id,
    'user_id'    => auth()->id(),
    'ip'         => request()->ip(),
    'user_agent' => request()->userAgent(),
]);
```

`analyticsApi` to wrapper nad klientem RabbitMQ. Serializuje payload i wysyła do odpowiedniej kolejki. Jeśli użytkownik nie jest zalogowany, `user_id` jest null — zdarzenie i tak trafia do systemu.

## Consumer w Analytics

**Analytics** uruchamia worker nasłuchujący na kolejce `post.viewed`. Każde zdarzenie trafia do tabeli `post_views` z timestampem, IP i user agentem.

Serwis agreguje statystyki: liczba wyświetleń per post, unikalne wyświetlenia (deduplikacja po IP + post_id w oknie czasowym), trend dzienny.

## Statystyki w panelu admina

**Admin** odpytuje Analytics przez wewnętrzne API (chronione kluczem API). Na stronie posta wyświetlana jest liczba wyświetleń, wykres trendu i podział na zalogowanych/anonimowych czytelników.

> Dane analityczne są read-only z perspektywy Admina — panel nie modyfikuje historii zdarzeń, tylko ją wyświetla.
