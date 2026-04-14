---
title: "The Analytics microservice — collecting views via RabbitMQ and aggregation"
date: 2026-03-12
category: "Backend"
tags: [Analytics, RabbitMQ, MySQL, Laravel, microservices, API]
locale: en
---

## Why a separate service?

View statistics have different characteristics than the rest of the system:
- **Writes are very frequent** (every post view)
- **Reads are rare** (admin dashboard, author panel)
- **Data can be stale by a few seconds** — that is acceptable

This makes it an ideal candidate for a separate service with a different data model optimized for a write-heavy workload.

## Database schema

```sql
CREATE TABLE post_views (
    id          BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_uuid   CHAR(36) NOT NULL,
    user_id     BIGINT UNSIGNED NULL,
    ip          VARCHAR(45) NULL,
    user_agent  TEXT NULL,
    referer     VARCHAR(500) NULL,
    viewed_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_post_uuid (post_uuid),
    INDEX idx_viewed_at (viewed_at)
);

CREATE TABLE post_view_aggregates (
    id          BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_uuid   CHAR(36) NOT NULL,
    date        DATE NOT NULL,
    view_count  INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY uq_post_date (post_uuid, date)
);
```

`post_views` holds the raw data. `post_view_aggregates` holds aggregated views per day — fast reads without scanning millions of records.

## Consumer — receiving events

```php
class ConsumePostViews extends Command
{
    public function handle(): void
    {
        $this->channel->basic_consume(
            queue: 'analytics.post_views',
            callback: function (AMQPMessage $msg) {
                $data = json_decode($msg->body, true);

                // Store the raw event
                PostView::create([
                    'post_uuid' => $data['post_uuid'],
                    'user_id'   => $data['user_id'] ?? null,
                    'ip'        => $data['ip'],
                    'user_agent' => $data['user_agent'] ?? null,
                    'referer'   => $data['referer'] ?? null,
                    'viewed_at' => $data['timestamp'],
                ]);

                // Upsert the aggregate (atomic increment)
                DB::statement('
                    INSERT INTO post_view_aggregates (post_uuid, date, view_count)
                    VALUES (?, CURDATE(), 1)
                    ON DUPLICATE KEY UPDATE view_count = view_count + 1
                ', [$data['post_uuid']]);

                $msg->ack();
            }
        );

        while ($this->channel->is_consuming()) {
            $this->channel->wait();
        }
    }
}
```

## Analytics API

```
GET /api/v1/posts/{uuid}/views          → total view count
GET /api/v1/posts/{uuid}/views/daily    → views per day (last 30 days)
GET /api/v1/posts/top?limit=10          → top posts by views
```

All endpoints require `X-Internal-Api-Key` — accessible only to other services.

## Frontend integration

The frontend calls the analytics API when displaying the author dashboard. It queries `GET /api/v1/posts/{uuid}/views` for each post and displays the count.
