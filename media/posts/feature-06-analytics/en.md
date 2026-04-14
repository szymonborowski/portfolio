---
title: "Analytics microservice — tracking post views via RabbitMQ"
date: 2026-02-11
category: "Dev Update"
tags: [analytics, rabbitmq, frontend, events, statistics]
locale: en
---

A new service in the system — **Analytics**. Its only job is collecting events and producing statistics. It has no public API — it communicates exclusively through the RabbitMQ queue.

**Services: Analytics, Frontend**

## Architecture without a public API

Most analytics services are REST APIs that Frontend POSTs data to. I chose a different approach: Frontend publishes an event to RabbitMQ, Analytics consumes it in the background. Benefits:

- Frontend doesn't wait for a response (fire-and-forget)
- Analytics can be temporarily down without losing events — the queue buffers them
- Easy scaling of the consumer independently from Frontend

## Sending an event from Frontend

After a post is displayed, Frontend publishes a `post.viewed` event:

```php
// Frontend — sending the event
$this->analyticsApi->trackView([
    'post_id'    => $post->id,
    'user_id'    => auth()->id(),
    'ip'         => request()->ip(),
    'user_agent' => request()->userAgent(),
]);
```

`analyticsApi` is a wrapper around the RabbitMQ client. It serializes the payload and sends it to the appropriate queue. If the user is not logged in, `user_id` is null — the event still reaches the system.

## Consumer in Analytics

**Analytics** runs a worker listening on the `post.viewed` queue. Each event goes into the `post_views` table with a timestamp, IP, and user agent.

The service aggregates statistics: view count per post, unique views (deduplicated by IP + post_id within a time window), daily trend.

## Statistics in the admin panel

**Admin** queries Analytics through an internal API (protected by an API key). The post page shows view count, a trend chart, and a breakdown of logged-in vs anonymous readers.

> Analytics data is read-only from Admin's perspective — the panel does not modify event history, it only displays it.
