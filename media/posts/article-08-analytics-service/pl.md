---
title: "Mikroserwis Analytics — zbieranie wyświetleń przez RabbitMQ i agregacja"
date: 2026-03-12
category: "Backend"
tags: [Analytics, RabbitMQ, MySQL, Laravel, microservices, API]
locale: pl
---

## Po co osobny serwis?

Statystyki wyświetleń mają inne charakterystyki niż reszta systemu:
- **Zapis jest bardzo częsty** (każde wyświetlenie posta)
- **Odczyt jest rzadki** (dashboard admina, panel autora)
- **Dane mogą być nieaktualne do kilku sekund** — to akceptowalne

To idealny kandydat na osobny serwis z innym modelem danych zoptymalizowanym pod write-heavy workload.

## Schemat bazy danych

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

`post_views` to surowe dane. `post_view_aggregates` to zagregowane widoki per dzień — szybki odczyt bez skanowania milionów rekordów.

## Consumer — odbieranie eventów

```php
class ConsumePostViews extends Command
{
    public function handle(): void
    {
        $this->channel->basic_consume(
            queue: 'analytics.post_views',
            callback: function (AMQPMessage $msg) {
                $data = json_decode($msg->body, true);

                // Zapis surowego eventu
                PostView::create([
                    'post_uuid' => $data['post_uuid'],
                    'user_id'   => $data['user_id'] ?? null,
                    'ip'        => $data['ip'],
                    'user_agent' => $data['user_agent'] ?? null,
                    'referer'   => $data['referer'] ?? null,
                    'viewed_at' => $data['timestamp'],
                ]);

                // Upsert agregatu (atomowy increment)
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

## API Analytics

```
GET /api/v1/posts/{uuid}/views          → łączna liczba wyświetleń
GET /api/v1/posts/{uuid}/views/daily    → wyświetlenia per dzień (ostatnie 30 dni)
GET /api/v1/posts/top?limit=10          → top posty wg wyświetleń
```

Wszystkie endpointy wymagają `X-Internal-Api-Key` — dostępne tylko dla innych serwisów.

## Integracja z frontendem

Frontend wywołuje analytics API przy wyświetlaniu dashboardu autora. Odpytuje `GET /api/v1/posts/{uuid}/views` dla każdego posta i wyświetla liczbę.
