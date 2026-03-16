-- =============================================================================
-- Portfolio Blog — seed postów serii "Build in Public"
-- Autor: user_id = 1
--
-- Uruchomienie (Docker Compose):
--   docker compose exec blog-db mysql -u root -p"$MYSQL_ROOT_PASSWORD" blog_db \
--     < scripts/seed-blog-posts.sql
--
-- Uruchomienie (Kubernetes):
--   kubectl exec -it <blog-db-pod> -- mysql -u root -p blog_db \
--     < scripts/seed-blog-posts.sql
--
-- UWAGA: Jeśli rekord autora już istnieje (RabbitMQ go stworzył),
--        INSERT IGNORE go pominie i użyjemy istniejącego.
-- =============================================================================

SET NAMES utf8mb4;
SET foreign_key_checks = 0;

-- ---------------------------------------------------------------------------
-- 1. AUTOR
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO authors (user_id, name, email, created_at, updated_at)
VALUES (1, 'Szymon Borowski', 'szymon@portfolio.local', NOW(), NOW());

SET @author_id = (SELECT id FROM authors WHERE user_id = 1);

-- ---------------------------------------------------------------------------
-- 2. KATEGORIE
-- ---------------------------------------------------------------------------

-- Kategorie główne
INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Architektura', 'architektura', NULL);
SET @cat_architektura = (SELECT id FROM categories WHERE slug = 'architektura');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('DevOps', 'devops', NULL);
SET @cat_devops = (SELECT id FROM categories WHERE slug = 'devops');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Backend', 'backend', NULL);
SET @cat_backend = (SELECT id FROM categories WHERE slug = 'backend');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Bezpieczeństwo', 'bezpieczenstwo', NULL);
SET @cat_bezpieczenstwo = (SELECT id FROM categories WHERE slug = 'bezpieczenstwo');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Monitoring', 'monitoring', NULL);
SET @cat_monitoring = (SELECT id FROM categories WHERE slug = 'monitoring');

-- Kategorie potomne — Architektura
INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Mikroserwisy', 'mikroserwisy', @cat_architektura);
SET @cat_mikroserwisy = (SELECT id FROM categories WHERE slug = 'mikroserwisy');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Infrastruktura', 'infrastruktura', @cat_architektura);
SET @cat_infrastruktura = (SELECT id FROM categories WHERE slug = 'infrastruktura');

-- Kategorie potomne — DevOps
INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Docker', 'docker', @cat_devops);
SET @cat_docker = (SELECT id FROM categories WHERE slug = 'docker');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Kubernetes', 'kubernetes', @cat_devops);
SET @cat_kubernetes = (SELECT id FROM categories WHERE slug = 'kubernetes');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('CI/CD', 'ci-cd', @cat_devops);
SET @cat_cicd = (SELECT id FROM categories WHERE slug = 'ci-cd');

-- Kategorie potomne — Backend
INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Laravel', 'laravel', @cat_backend);
SET @cat_laravel = (SELECT id FROM categories WHERE slug = 'laravel');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('API Design', 'api-design', @cat_backend);
SET @cat_api = (SELECT id FROM categories WHERE slug = 'api-design');

INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('Kolejki', 'kolejki', @cat_backend);
SET @cat_kolejki = (SELECT id FROM categories WHERE slug = 'kolejki');

-- Kategorie potomne — Bezpieczeństwo
INSERT IGNORE INTO categories (name, slug, parent_id)
VALUES ('OAuth2 / SSO', 'oauth2-sso', @cat_bezpieczenstwo);
SET @cat_oauth2 = (SELECT id FROM categories WHERE slug = 'oauth2-sso');

-- ---------------------------------------------------------------------------
-- 3. TAGI (uzupełnienie istniejących)
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO tags (name, slug) VALUES ('kubernetes', 'kubernetes');
INSERT IGNORE INTO tags (name, slug) VALUES ('traefik', 'traefik');
INSERT IGNORE INTO tags (name, slug) VALUES ('rabbitmq', 'rabbitmq');
INSERT IGNORE INTO tags (name, slug) VALUES ('microservices', 'microservices');
INSERT IGNORE INTO tags (name, slug) VALUES ('oauth2', 'oauth2');
INSERT IGNORE INTO tags (name, slug) VALUES ('sso', 'sso');
INSERT IGNORE INTO tags (name, slug) VALUES ('grafana', 'grafana');
INSERT IGNORE INTO tags (name, slug) VALUES ('prometheus', 'prometheus');
INSERT IGNORE INTO tags (name, slug) VALUES ('argocd', 'argocd');
INSERT IGNORE INTO tags (name, slug) VALUES ('github-actions', 'github-actions');
INSERT IGNORE INTO tags (name, slug) VALUES ('filamentphp', 'filamentphp');
INSERT IGNORE INTO tags (name, slug) VALUES ('mysql', 'mysql');
INSERT IGNORE INTO tags (name, slug) VALUES ('redis', 'redis');
INSERT IGNORE INTO tags (name, slug) VALUES ('nginx', 'nginx');
INSERT IGNORE INTO tags (name, slug) VALUES ('loki', 'loki');
INSERT IGNORE INTO tags (name, slug) VALUES ('tests', 'tests');
INSERT IGNORE INTO tags (name, slug) VALUES ('devlog', 'devlog');

-- Shorthand zmiennych dla istniejących tagów
SET @tag_php          = (SELECT id FROM tags WHERE slug = 'php');
SET @tag_laravel      = (SELECT id FROM tags WHERE slug = 'laravel');
SET @tag_javascript   = (SELECT id FROM tags WHERE slug = 'javascript');
SET @tag_vuejs        = (SELECT id FROM tags WHERE slug = 'vuejs');
SET @tag_docker       = (SELECT id FROM tags WHERE slug = 'docker');
SET @tag_api          = (SELECT id FROM tags WHERE slug = 'api');
SET @tag_tutorial     = (SELECT id FROM tags WHERE slug = 'tutorial');
SET @tag_tips         = (SELECT id FROM tags WHERE slug = 'tips');
SET @tag_kubernetes   = (SELECT id FROM tags WHERE slug = 'kubernetes');
SET @tag_traefik      = (SELECT id FROM tags WHERE slug = 'traefik');
SET @tag_rabbitmq     = (SELECT id FROM tags WHERE slug = 'rabbitmq');
SET @tag_microservices = (SELECT id FROM tags WHERE slug = 'microservices');
SET @tag_oauth2       = (SELECT id FROM tags WHERE slug = 'oauth2');
SET @tag_sso          = (SELECT id FROM tags WHERE slug = 'sso');
SET @tag_grafana      = (SELECT id FROM tags WHERE slug = 'grafana');
SET @tag_prometheus   = (SELECT id FROM tags WHERE slug = 'prometheus');
SET @tag_argocd       = (SELECT id FROM tags WHERE slug = 'argocd');
SET @tag_ghactions    = (SELECT id FROM tags WHERE slug = 'github-actions');
SET @tag_filament     = (SELECT id FROM tags WHERE slug = 'filamentphp');
SET @tag_mysql        = (SELECT id FROM tags WHERE slug = 'mysql');
SET @tag_redis        = (SELECT id FROM tags WHERE slug = 'redis');
SET @tag_nginx        = (SELECT id FROM tags WHERE slug = 'nginx');
SET @tag_loki         = (SELECT id FROM tags WHERE slug = 'loki');
SET @tag_tests        = (SELECT id FROM tags WHERE slug = 'tests');
SET @tag_devlog       = (SELECT id FROM tags WHERE slug = 'devlog');

-- ---------------------------------------------------------------------------
-- 4. POSTY
-- ---------------------------------------------------------------------------

-- ============================================================
-- POST 1: Dlaczego mikroserwisy do bloga?
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Dlaczego mikroserwisy do bloga? Analiza decyzji architektonicznej',
  'dlaczego-mikroserwisy-do-bloga',
  'Blog można zbudować w jeden wieczór w monolicie. Dlaczego więc wybrałem architekturę mikroserwisową i czy to był dobry pomysł?',
  '## Skąd w ogóle ten pomysł?

Kiedy zaczynałem budować portfolio, stałem przed klasycznym wyborem: monorepo z Laravelem, które działa od pierwszego dnia, albo coś bardziej ambitnego. Wybrałem to drugie — i mam co do tego mieszane uczucia, ale w pozytywnym sensie.

Celem nie była "najlepsza architektura do bloga". Celem było **stworzenie platformy, która będzie służyła jako żywe demo moich umiejętności**. Blog jest tylko pretekstem.

## Co wchodzi w skład systemu?

System składa się z 6 serwisów:

- **Frontend** — Laravel + Blade, serwuje strony użytkownikom
- **Blog** — Laravel API, zarządza postami, komentarzami, kategoriami, tagami
- **Users** — Laravel API, zarządza użytkownikami, RBAC
- **SSO** — serwer OAuth2 oparty na Laravel Passport
- **Admin** — panel administracyjny oparty na FilamentPHP
- **Analytics** — zbiera wyświetlenia postów i agreguje statystyki

Każdy serwis ma własną bazę danych MySQL, własny kontener, własne testy.

## Komunikacja między serwisami

Serwisy komunikują się na dwa sposoby:

### HTTP (synchroniczne)
Frontend wywołuje Blog API i Users API bezpośrednio przez wewnętrzną sieć Dockera. Używam `X-Internal-Api-Key` jako prostego mechanizmu autoryzacji między serwisami.

### RabbitMQ (asynchroniczne)
Kiedy użytkownik wyświetla post, Frontend publikuje event `post.viewed` do RabbitMQ. Analytics consumer odbiera go i zapisuje do bazy. Kiedy użytkownik zmienia dane w Users, event `user.updated` trafia do Blog, który aktualizuje swoją lokalną kopię autora.

```
Frontend ──HTTP──▶ Blog API
Frontend ──HTTP──▶ Users API
Frontend ──RabbitMQ──▶ Analytics
Users ──RabbitMQ──▶ Blog (synchronizacja autorów)
```

## Czy to był dobry pomysł?

**Zalety:**
- Każdy serwis można deployować niezależnie
- Naturalna izolacja odpowiedzialności
- Świetny materiał do nauki Kubernetes, ArgoCD, CI/CD
- Demo, które można pokazać na rozmowie kwalifikacyjnej

**Wady:**
- Dużo boilerplate na start (6 razy to samo scaffolding)
- Debugowanie przez sieć jest trudniejsze niż w monolicie
- Overhead infrastrukturalny (RabbitMQ, Traefik, osobne bazy)

Gdybym budował "prawdziwy" produkt od zera, pewnie wybrałbym monolit. Ale to nie jest "prawdziwy" produkt — to platforma do nauki i demo. I jako takie, spełnia swoje zadanie znakomicie.',
  'published',
  '2026-01-28 10:00:00',
  '2026-01-28 10:00:00',
  '2026-01-28 10:00:00'
);
SET @post1 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_mikroserwisy, @post1);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post1, @tag_microservices);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post1, @tag_devlog);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post1, @tag_laravel);

-- ============================================================
-- POST 2: Traefik v3 jako reverse proxy
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Traefik v3 jako reverse proxy — routing, TLS i dashboard w praktyce',
  'traefik-v3-reverse-proxy-routing-tls-dashboard',
  'Traefik automatycznie wykrywa kontenery Dockera i konfiguruje routing. Pokazuję jak skonfigurowałem go w tym projekcie — od HTTP redirect po własne certyfikaty TLS.',
  '## Czym jest Traefik?

Traefik to nowoczesny reverse proxy i load balancer, który odróżnia się od Nginx tym, że **konfiguruje się dynamicznie**. Zamiast ręcznie pisać bloki `server {}`, Traefik czyta labele z kontenerów Dockera i sam buduje routing.

## Podstawowa konfiguracja

W `docker-compose.prod.yml` Traefik uruchamiam jako pierwszy serwis:

```yaml
traefik:
  image: traefik:v3.6
  command:
    - "--entrypoints.web.address=:80"
    - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
    - "--entrypoints.websecure.address=:443"
    - "--entrypoints.websecure.http.tls=true"
    - "--providers.docker=true"
    - "--providers.docker.exposedbydefault=false"
    - "--providers.file.filename=/etc/traefik/dynamic/traefik_dynamic.yml"
```

Kluczowe decyzje:
- `exposedbydefault=false` — serwis musi explicite dodać label `traefik.enable=true`, żeby być wystawiony
- Redirect z HTTP na HTTPS jest globalny, jeden wpis, działa dla wszystkich serwisów

## Routing przez labele

Każdy serwis, który chcę wystawić publicznie, dostaje etykiety:

```yaml
frontend:
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.frontend.rule=Host(`portfolio.example.com`)"
    - "traefik.http.routers.frontend.entrypoints=websecure"
    - "traefik.http.routers.frontend.tls=true"
    - "traefik.http.services.frontend.loadbalancer.server.port=80"
```

Serwisy wewnętrzne (Blog API, Users API) są w osobnej sieci i nie mają tych labeli — dostępne tylko z sieci `microservices`.

## TLS z własnymi certyfikatami

W projekcie używam własnych certyfikatów (dev) lub Let''s Encrypt (produkcja). Konfiguracja TLS jest w pliku dynamicznym:

```yaml
# infra/dynamic/traefik_dynamic.yml
tls:
  certificates:
    - certFile: /certs/cert.pem
      keyFile: /certs/key.pem
  stores:
    default:
      defaultCertificate:
        certFile: /certs/cert.pem
        keyFile: /certs/key.pem
```

## Dashboard

Dashboard Traefika jest bardzo przydatny do debugowania — pokazuje aktywne routery, serwisy i middleware. Zabezpieczam go osobną domeną z Basic Auth przez middleware:

```yaml
- "traefik.http.routers.dashboard.rule=Host(`traefik.example.com`)"
- "traefik.http.routers.dashboard.middlewares=auth@file"
```

## Co mi się podoba w Traefikie?

Największy plus to **zero restartów przy zmianie konfiguracji**. Dodam nowy kontener z odpowiednimi labelami, Traefik wykryje go w ciągu sekund i zacznie routować ruch. W Nginx musiałbym edytować plik konfiguracyjny i przeładować serwis.

Minusem jest krzywa uczenia się — składnia labeli jest specyficzna i łatwo o literówkę, która cicho nic nie robi.',
  'published',
  '2026-01-30 10:00:00',
  '2026-01-30 10:00:00',
  '2026-01-30 10:00:00'
);
SET @post2 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_infrastruktura, @post2);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post2, @tag_traefik);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post2, @tag_docker);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post2, @tag_nginx);

-- ============================================================
-- POST 3: OAuth2 SSO z Laravel Passport
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'OAuth2 SSO od zera z Laravel Passport — jak to działa pod maską',
  'oauth2-sso-laravel-passport-jak-dziala',
  'Zbudowałem centralny serwer SSO oparty na Laravel Passport. Tłumaczę flow Authorization Code, tokeny, odświeżanie sesji i integrację z wieloma klientami.',
  '## Po co własne SSO?

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
    ''X-Internal-Api-Key'' => config(''services.users.internal_key''),
])->post(config(''services.users.url'') . ''/api/internal/verify-password'', [
    ''email'' => $request->email,
    ''password'' => $request->password,
]);
```

Dzięki temu Users jest jedynym serwisem, który "zna" hasła. SSO tylko pyta.

## Refresh token i wygasanie sesji

access_token wygasa po 1 godzinie. Przy każdym żądaniu do API frontend sprawdza czy token nie wygasł i w razie potrzeby odpytuje SSO o nowy token przy pomocy refresh_token.

```php
if ($this->isTokenExpired($session->get(''expires_at''))) {
    $newTokens = $this->refreshAccessToken($session->get(''refresh_token''));
    $session->put(''access_token'', $newTokens[''access_token'']);
}
```

## Klient Admin (FilamentPHP)

Admin panel używa tego samego SSO — zaimplementowałem osobny OAuth2 client z `redirect_uri` wskazującym na domenę admina. Filament dostaje token i robi API calls z Bearer auth.',
  'published',
  '2026-02-03 10:00:00',
  '2026-02-03 10:00:00',
  '2026-02-03 10:00:00'
);
SET @post3 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_oauth2, @post3);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post3, @tag_oauth2);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post3, @tag_sso);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post3, @tag_laravel);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post3, @tag_php);

-- ============================================================
-- POST 4: RabbitMQ w mikroserwisach
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'RabbitMQ w mikroserwisach — eventy, routing i dead-letter queues',
  'rabbitmq-mikroserwisy-eventy-routing-dlq',
  'RabbitMQ pozwala serwisem komunikować się asynchronicznie bez bezpośrednich zależności. Pokazuję jak zaprojektowałem topologię exchanges i kolejek w tym projekcie.',
  '## Dlaczego kolejki?

Bez RabbitMQ synchroniczna komunikacja między serwisami wygląda tak:

```
Frontend → Blog API (HTTP) → OK
Frontend → Analytics API (HTTP) → jeśli Analytics padł, wyświetlenie posta też się nie uda?
```

To niedopuszczalne. Wyświetlenie posta nie powinno zależeć od tego, czy serwis analityki działa. Z kolejką:

```
Frontend → RabbitMQ (publish event) → wraca natychmiast
RabbitMQ → Analytics consumer (async) → przetwarza kiedy może
```

## Topologia exchanges i kolejek

Używam **topic exchange** co daje elastyczny routing oparty na wzorcach:

```
Exchange: portfolio.events (topic)
  ├── Routing key: post.viewed     → kolejka: analytics.post_views
  ├── Routing key: user.created    → kolejka: blog.user_events
  ├── Routing key: user.updated    → kolejka: blog.user_events
  └── Routing key: user.deleted    → kolejka: blog.user_events
```

Jeden exchange, wiele konsumerów — każdy słucha na swoich routing keys.

## Publisher w PHP (Frontend)

```php
class AnalyticsEventPublisher
{
    public function publishPostViewed(string $postUuid, ?int $userId): void
    {
        $message = new AMQPMessage(
            json_encode([
                ''event'' => ''post.viewed'',
                ''post_uuid'' => $postUuid,
                ''user_id'' => $userId,
                ''ip'' => request()->ip(),
                ''timestamp'' => now()->toIso8601String(),
            ]),
            [''content_type'' => ''application/json'', ''delivery_mode'' => AMQPMessage::DELIVERY_MODE_PERSISTENT]
        );

        $this->channel->basic_publish($message, ''portfolio.events'', ''post.viewed'');
    }
}
```

## Consumer w Laravel (Artisan Command)

```php
class ConsumeUserEvents extends Command
{
    public function handle(): void
    {
        $this->channel->basic_consume(
            ''blog.user_events'',
            callback: function (AMQPMessage $msg) {
                $data = json_decode($msg->body, true);
                $this->handler->handle($data);
                $msg->ack();
            }
        );

        while ($this->channel->is_consuming()) {
            $this->channel->wait();
        }
    }
}
```

Consumer działa jako długożyjący proces — w Dockerze jest osobnym kontenerem `blog-consumer`, w K8s osobnym Deploymentem.

## Dead-letter queues

Jeśli consumer rzuci wyjątek i nie wyśle `ack()`, wiadomość trafia z powrotem do kolejki i jest ponawiana. Żeby uniknąć nieskończonej pętli, konfiguruję DLQ:

```php
$this->channel->queue_declare(''blog.user_events'', arguments: new AMQPTable([
    ''x-dead-letter-exchange'' => ''portfolio.dlx'',
    ''x-message-ttl'' => 30000,
    ''x-max-retries'' => 3,
]));
```

Po 3 nieudanych próbach wiadomość trafia do kolejki martwych listów — można ją później przejrzeć i przetworzyć ręcznie.',
  'published',
  '2026-02-05 10:00:00',
  '2026-02-05 10:00:00',
  '2026-02-05 10:00:00'
);
SET @post4 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_kolejki, @post4);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post4, @tag_rabbitmq);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post4, @tag_microservices);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post4, @tag_laravel);

-- ============================================================
-- POST 5: Multi-stage Docker builds
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Multi-stage Docker builds — Alpine, hardening i minimalne obrazy produkcyjne',
  'multi-stage-docker-builds-alpine-hardening',
  'Obraz z naiwnego Dockerfile może ważyć 1 GB. Pokazuję jak zredukowałem obrazy produkcyjne przez multi-stage builds, Alpine Linux i usunięcie zbędnych narzędzi.',
  '## Problem z prostymi Dockerfile

Naiwny Dockerfile dla aplikacji Laravel:

```dockerfile
FROM php:8.5-fpm
RUN apt-get install -y git zip unzip nodejs npm
COPY . /var/www
RUN composer install
RUN npm install && npm run build
```

Wynikowy obraz: ~1.2 GB. Zawiera narzędzia build-time (git, npm, composer) których produkcja nie potrzebuje.

## Multi-stage build — podział na etapy

```dockerfile
# Etap 1: build assets (Node.js)
FROM node:22-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY resources/ resources/
COPY vite.config.js ./
RUN npm run build

# Etap 2: install PHP dependencies
FROM composer:2 AS composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Etap 3: obraz produkcyjny
FROM php:8.5-fpm-alpine AS production
WORKDIR /var/www

# Kopiujemy tylko artefakty z poprzednich etapów
COPY --from=composer /app/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
COPY . .

RUN chown -R www-data:www-data /var/www
USER www-data
```

Wynikowy obraz: ~180 MB — 85% mniej.

## Hardening kontenera

Kilka zasad bezpieczeństwa, które stosuję:

**Non-root user:**
```dockerfile
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser
```

**Read-only filesystem (tam gdzie możliwe):**
```yaml
# docker-compose.prod.yml
security_opt:
  - no-new-privileges:true
read_only: true
tmpfs:
  - /tmp
  - /var/run
```

**Minimalny obraz — Alpine zamiast Debian:**
Alpine Linux ma ~5 MB w porównaniu do ~80 MB Debiana. Mniej pakietów = mniejsza powierzchnia ataku.

**STOPSIGNAL SIGQUIT dla PHP-FPM:**
```dockerfile
STOPSIGNAL SIGQUIT
```
PHP-FPM na SIGQUIT robi graceful shutdown — dokańcza aktywne requesty zanim się wyłączy. Bez tego K8s mógłby zabić kontener w trakcie obsługi requestu.

## OCI labels dla trackowalności

```dockerfile
LABEL org.opencontainers.image.version="0.0.4"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/szymonborowski/portfolio"
```

Dzięki temu patrząc na działający kontener wiem dokładnie z jakiego commitu pochodzi.',
  'published',
  '2026-02-07 10:00:00',
  '2026-02-07 10:00:00',
  '2026-02-07 10:00:00'
);
SET @post5 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_docker, @post5);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post5, @tag_docker);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post5, @tag_nginx);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post5, @tag_tutorial);

-- ============================================================
-- POST 6: Migracja z Docker Compose do Kubernetes
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Kubernetes od Docker Compose — moja migracja krok po kroku',
  'kubernetes-od-docker-compose-migracja',
  'Miałem działający Docker Compose. Migracja do Kubernetes wymagała napisania manifestów dla każdego serwisu, rozwiązania problemu z sekretami i skonfigurowania health checks.',
  '## Punkt startowy — Docker Compose

Docker Compose działał świetnie w developmencie. Jeden plik, `docker compose up` i wszystko chodzi. Ale Compose nie daje:
- automatycznego restartu po awarii noda
- rolling updates bez downtime
- horizontal scaling
- deklaratywnego zarządzania konfiguracją

Kubernetes rozwiązuje wszystkie te problemy.

## Mapowanie pojęć

| Docker Compose | Kubernetes |
|----------------|------------|
| `service`      | `Deployment` + `Service` |
| `volumes`      | `PersistentVolumeClaim` |
| `environment`  | `ConfigMap` + `Secret` |
| `networks`     | `NetworkPolicy` |
| `depends_on`   | `initContainer` |
| `healthcheck`  | `livenessProbe` + `readinessProbe` |

## Deployment manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    spec:
      containers:
        - name: frontend
          image: ghcr.io/szymonborowski/portfolio-frontend:v0.0.4
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: frontend-config
            - secretRef:
                name: frontend-secrets
          livenessProbe:
            httpGet:
              path: /health
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 5
```

## InitContainers — migracje bazy

Największy problem: jak upewnić się, że migracje DB wykonają się przed startem aplikacji? W Compose używałem `depends_on` z `condition: service_healthy`. W K8s używam initContainer:

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/portfolio-blog:v0.0.4
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secrets
```

initContainer musi zakończyć się sukcesem zanim główny kontener wystartuje.

## StatefulSets dla baz danych

MySQL i Redis działają jako StatefulSet, nie Deployment — bo potrzebują stabilnej tożsamości sieciowej i trwałego storage:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: blog-db
spec:
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
```

## Co poszło nie tak

Największa pułapka: **obrazy ARM vs AMD64**. Budowałem obrazy na MacBooku (ARM) bez `--platform linux/amd64`. Na klastrze (AMD64) kontenery crashowały z błędem "exec format error". Rozwiązanie: multi-arch build z `docker buildx`:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/... --push .
```',
  'published',
  '2026-02-10 10:00:00',
  '2026-02-10 10:00:00',
  '2026-02-10 10:00:00'
);
SET @post6 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_kubernetes, @post6);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post6, @tag_kubernetes);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post6, @tag_docker);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post6, @tag_tutorial);

-- ============================================================
-- POST 7: ArgoCD i GitOps
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'ArgoCD i GitOps — deploy przez PR bez SSH do serwera',
  'argocd-gitops-deploy-przez-pr',
  'GitOps to podejście, w którym Git jest jedynym źródłem prawdy o stanie infrastruktury. ArgoCD obserwuje repozytorium i automatycznie synchronizuje klaster z każdą zmianą.',
  '## Czym jest GitOps?

Tradycyjny CD: push kodu → CI buduje obraz → skrypt SSH na serwer → `kubectl apply`.

GitOps: push kodu → CI buduje obraz i aktualizuje tag w manifeście K8s → ArgoCD widzi zmianę w repo → ArgoCD aplikuje manifest na klastrze.

**Kluczowa różnica:** w GitOps nikt nie ma dostępu SSH do klastra produkcyjnego. Jedyna droga do deploymentu to PR do repo.

## Instalacja ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Application manifest

Dla każdego serwisu tworzę `argocd-application.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: portfolio-frontend
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/szymonborowski/portfolio
    targetRevision: master
    path: frontend/k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: portfolio
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

`automated.selfHeal: true` oznacza, że jeśli ktoś ręcznie zmieni coś w klastrze, ArgoCD to przywróci do stanu z repo.

## CI/CD pipeline — jak to łączy się z GitHub Actions?

```yaml
# .github/workflows/ci-cd.yml (fragment CD)
- name: Update image tag in K8s manifest
  run: |
    IMAGE_TAG=sha-${GITHUB_SHA::7}
    sed -i "s|image: ghcr.io/.*/portfolio-frontend:.*|image: ghcr.io/${{ github.repository_owner }}/portfolio-frontend:${IMAGE_TAG}|" frontend/k8s/deployment.yaml
    git config user.email "ci@portfolio.local"
    git config user.name "CI Bot"
    git add frontend/k8s/deployment.yaml
    git commit -m "ci: update frontend image to ${IMAGE_TAG}"
    git push
```

Po tym commicie ArgoCD w ciągu ~3 minut wykrywa zmianę i robi rolling update.

## Health checks i rollback

ArgoCD nie marki Deployment jako "Synced" dopóki wszystkie pody nie są w stanie Running z przechodzącymi health checks. Jeśli nowa wersja się nie uruchomi, ArgoCD to pokaże — można ręcznie zrolbackować jednym kliknięciem w UI lub:

```bash
argocd app rollback portfolio-frontend
```

## Bezpieczeństwo

ArgoCD ma dostęp tylko do klastra (via ServiceAccount z ograniczonymi uprawnieniami). Sekrety w repo trzymam jako placeholdery — rzeczywiste wartości ładowane przez Sealed Secrets lub External Secrets Operator.',
  'published',
  '2026-02-14 10:00:00',
  '2026-02-14 10:00:00',
  '2026-02-14 10:00:00'
);
SET @post7 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_cicd, @post7);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post7, @tag_argocd);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post7, @tag_ghactions);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post7, @tag_kubernetes);

-- ============================================================
-- POST 8: GitHub Actions CI/CD
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'GitHub Actions CI/CD — testy, budowanie obrazów i push do GHCR',
  'github-actions-cicd-testy-docker-ghcr',
  'Opisuję workflow CI/CD oparty na GitHub Actions: jak uruchamiam testy dla 6 serwisów, buduję obrazy Docker i wypycham je do GitHub Container Registry.',
  '## Struktura pipeline

Pipeline podzielony jest na dwa etapy:

1. **CI** — uruchamia się na każdym PR i pushu do `master`; musi przejść żeby można było mergować
2. **CD** — uruchamia się tylko na pushu do `master`; buduje i publikuje obrazy

```yaml
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  test:
    # CI — uruchamia się zawsze
  build-and-push:
    needs: test
    if: github.ref == ''refs/heads/master''
    # CD — tylko na master po przejściu testów
```

## CI — uruchamianie testów

Każdy serwis PHP ma własny job. Dla Blog serwisu:

```yaml
test-blog:
  runs-on: ubuntu-latest
  services:
    mysql:
      image: mysql:8
      env:
        MYSQL_DATABASE: blog_test
        MYSQL_ROOT_PASSWORD: secret
      options: --health-cmd="mysqladmin ping" --health-interval=10s

  steps:
    - uses: actions/checkout@v4
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: "8.5"
        extensions: pdo_mysql, mbstring, redis
    - name: Install dependencies
      run: composer install --no-interaction
      working-directory: blog/src
    - name: Run tests
      run: php artisan test --parallel
      working-directory: blog/src
      env:
        DB_DATABASE: blog_test
        DB_USERNAME: root
        DB_PASSWORD: secret
```

## CD — budowanie i push do GHCR

```yaml
build-and-push:
  strategy:
    matrix:
      service: [frontend, blog, users, sso, admin, analytics]

  steps:
    - name: Login to GHCR
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: ./${{ matrix.service }}
        file: ./${{ matrix.service }}/Dockerfile
        push: true
        tags: |
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:${{ github.sha }}
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:latest
        platforms: linux/amd64,linux/arm64
```

## Caching warstw Dockera

Bez cachowania każdy build ściąga `composer install` od nowa (~2 min). Z cache:

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

GitHub Actions Cache przechowuje warstwy Dockera. Przy kolejnym buildzie, jeśli `composer.lock` się nie zmienił, warstwa vendor jest wzięta z cache. Czas buildu spada z ~8 minut do ~2 minut.

## Czas wykonania pipeline

Dzięki `matrix` i parallelizacji, 6 serwisów buduje się jednocześnie. Łączny czas CI+CD: **~6 minut** od pusha do opublikowanych obrazów.',
  'published',
  '2026-02-17 10:00:00',
  '2026-02-17 10:00:00',
  '2026-02-17 10:00:00'
);
SET @post8 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_cicd, @post8);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post8, @tag_ghactions);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post8, @tag_docker);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post8, @tag_tips);

-- ============================================================
-- POST 9: FilamentPHP — panel admina
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'FilamentPHP — w pełni funkcjonalny panel admina w jeden dzień',
  'filamentphp-panel-admina',
  'FilamentPHP to biblioteka do budowania paneli administracyjnych w Laravelu. Opisuję co dostałem za darmo i co musiałem dostosować, żeby połączyć go z zewnętrznym API.',
  '## Czym jest FilamentPHP?

FilamentPHP to zestaw komponentów Livewire do budowania CRUD-owych paneli administracyjnych. Dostarcza:
- Tabele z sortowaniem, filtrowaniem, paginacją
- Formularze z walidacją
- Widgety (wykresy, statystyki)
- Ciemny motyw
- System powiadomień

Tradycyjny panel admina w Laravel zajmuje kilka dni. Z Filamentem — kilka godzin.

## Konfiguracja zasobu

```php
class PostResource extends Resource
{
    protected static ?string $model = Post::class;

    public static function form(Form $form): Form
    {
        return $form->schema([
            TextInput::make(''title'')->required()->maxLength(255),
            TextInput::make(''slug'')->required()->unique(ignoreRecord: true),
            Textarea::make(''excerpt'')->rows(3),
            MarkdownEditor::make(''content'')->required()->columnSpanFull(),
            Select::make(''status'')
                ->options([''draft'' => ''Szkic'', ''published'' => ''Opublikowany'', ''archived'' => ''Archiwum''])
                ->required(),
            DateTimePicker::make(''published_at''),
            Select::make(''categories'')
                ->relationship(''categories'', ''name'')
                ->multiple()
                ->preload(),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make(''title'')->searchable()->sortable(),
                BadgeColumn::make(''status'')
                    ->colors([''warning'' => ''draft'', ''success'' => ''published'', ''secondary'' => ''archived'']),
                TextColumn::make(''published_at'')->dateTime()->sortable(),
            ])
            ->filters([
                SelectFilter::make(''status'')->options([...]),
            ]);
    }
}
```

## Problem: Filament + zewnętrzne SSO

Domyślnie Filament używa standardowego auth Laravela (sesja, guards). Mój admin potrzebował logowania przez SSO (OAuth2).

Musiałem:
1. Wyłączyć domyślną stronę logowania Filamenta
2. Zaimplementować własny `AuthController` który robi redirect do SSO
3. Po powrocie z SSO (z tokenem) ustawić sesję Filamenta

```php
// AdminPanelProvider.php
->login(CustomSsoLogin::class)
->authGuard(''web'')
```

```php
class CustomSsoLogin extends SimplePage
{
    public function mount(): void
    {
        // Redirect natychmiast do SSO zamiast pokazywać formularz
        redirect()->to(route(''sso.redirect''));
    }
}
```

## Zarządzanie komentarzami

Moderacja komentarzy to jedno z głównych zastosowań panelu. Custom action w tabeli:

```php
Tables\Actions\Action::make(''approve'')
    ->label(''Zatwierdź'')
    ->icon(''heroicon-o-check'')
    ->color(''success'')
    ->action(function (Comment $record) {
        $record->update([''status'' => ''approved'']);
        $this->notify(''success'', ''Komentarz zatwierdzony'');
    })
    ->visible(fn (Comment $record) => $record->status === ''pending''),
```

## Co mi się podoba?

Filament pozwolił mi skupić się na logice biznesowej zamiast na pisaniu kolejnych tabel HTML. Jeden plik `PostResource.php` zastępuje controller, widoki, formularze i walidację.',
  'published',
  '2026-02-20 10:00:00',
  '2026-02-20 10:00:00',
  '2026-02-20 10:00:00'
);
SET @post9 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_laravel, @post9);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post9, @tag_filament);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post9, @tag_laravel);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post9, @tag_php);

-- ============================================================
-- POST 10: Monitoring — Prometheus + Loki + Grafana
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Monitoring z Prometheus, Loki i Grafana — stack obserwowalności w Docker Compose',
  'monitoring-prometheus-loki-grafana-docker-compose',
  'Wdrożyłem pełny stack monitoringu: Prometheus zbiera metryki, Loki agreguje logi, Grafana wizualizuje wszystko. Opisuję konfigurację i gotowe dashboardy.',
  '## Trzy filary obserwowalności

Pełna obserwowalność systemu wymaga trzech typów danych:

- **Metryki** — liczby w czasie: CPU, pamięć, liczba requestów, czas odpowiedzi (Prometheus)
- **Logi** — tekstowe rekordy zdarzeń (Loki + Promtail)
- **Traces** — śledzenie konkretnego requestu przez wiele serwisów (nie wdrożone jeszcze)

## Prometheus — zbieranie metryk

Prometheus scrape-uje metryki z endpointów HTTP `/metrics`. Traefik i Laravel eksponują je automatycznie.

Konfiguracja scrapowania:
```yaml
# infra/prometheus/prometheus.yml
scrape_configs:
  - job_name: traefik
    static_configs:
      - targets: [''traefik:8080'']
    metrics_path: /metrics

  - job_name: frontend
    static_configs:
      - targets: [''frontend-nginx:9113'']
```

Dla PHP/Laravel używam `nginx-prometheus-exporter` jako sidecar, który czyta status Nginx i eksponuje metryki w formacie Prometheusa.

## Loki + Promtail — agregacja logów

Zamiast `docker logs` (które znikają po restarcie kontenera), loguję przez Promtail → Loki.

Wszystkie serwisy PHP mają ustawione `LOG_CHANNEL=stderr` — logi lecą do stdout kontenera, Promtail je zbiera:

```yaml
# infra/promtail/promtail.yml
scrape_configs:
  - job_name: containers
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: [__meta_docker_container_name]
        target_label: container
```

## Grafana — dashboardy

Stworzyłem trzy dashboardy:

**1. Infrastructure Overview**
- CPU i RAM per kontener
- Network I/O
- Liczba aktywnych kontenerów

**2. Laravel Application**
- Requesty HTTP per minutę (przez logi Nginx)
- Response time (p50, p95, p99)
- Error rate (5xx)
- Cache hit rate Redis

**3. RabbitMQ**
- Liczba wiadomości w kolejkach
- Consumer throughput
- Dead-letter queue size

## Alerty (TODO)

Grafana pozwala ustawiać alerty na podstawie zapytań PromQL. Planowane alerty:
- Error rate > 5% przez 5 minut
- Pod restart count > 3
- Queue depth > 1000 wiadomości
- Czas odpowiedzi p95 > 2 sekundy

Na razie monitoring działa "read-only" — obserwuję, nie alarmuje. To jedno z zadań do zrealizowania przed pełnym deployem produkcyjnym.',
  'published',
  '2026-02-24 10:00:00',
  '2026-02-24 10:00:00',
  '2026-02-24 10:00:00'
);
SET @post10 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_monitoring, @post10);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post10, @tag_grafana);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post10, @tag_prometheus);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post10, @tag_loki);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post10, @tag_docker);

-- ============================================================
-- POST 11: Testowanie mikroserwisów — 243 testy
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Jak testuję mikroserwisy w Laravel — 243 testy, RabbitMQ i OAuth2',
  'testowanie-mikroserwisow-laravel-243-testy',
  'Opisuję strategię testowania dla 5 serwisów PHP: testy jednostkowe, feature testy z prawdziwą bazą, mockowanie RabbitMQ i testowanie flow OAuth2.',
  '## Pokrycie testami

| Serwis    | Linie | Testy |
|-----------|-------|-------|
| Users     | 87.8% | 54    |
| SSO       | 83.7% | 25    |
| Blog      | 80.1% | 104   |
| Admin     | 73.0% | 28    |
| Frontend  | 61.4% | 46    |
| **Razem** | ~78%  | **243** |

Każdy serwis używa SQLite in-memory (`DB_CONNECTION=sqlite`, `:memory:`) do testów — bez potrzeby stawiania MySQL dla CI.

## Testy feature — realna baza, nie mocki

Preferuję testy feature z prawdziwą bazą zamiast unit testów z mockami. Przykład testu BlogAPI:

```php
class PostApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_published_posts(): void
    {
        Post::factory()->count(5)->published()->create();
        Post::factory()->count(3)->draft()->create();

        $response = $this->getJson(''/api/v1/public/posts'');

        $response->assertOk()
            ->assertJsonCount(5, ''data'')
            ->assertJsonStructure([
                ''data'' => [[''id'', ''title'', ''slug'', ''excerpt'', ''published_at'']],
                ''meta'' => [''total'', ''per_page'', ''current_page''],
            ]);
    }
}
```

## Mockowanie RabbitMQ

Testy publisherów RabbitMQ nie powinny wymagać działającego brokera. Używam `mock()`:

```php
public function test_publishes_post_viewed_event(): void
{
    $publisher = $this->mock(AnalyticsEventPublisher::class);
    $publisher->shouldReceive(''publishPostViewed'')
        ->once()
        ->with(Mockery::type(''string''), null);

    $this->get(''/post/'' . $post->slug);
}
```

## Testowanie konsumera RabbitMQ

Consumer to Artisan Command. Test symuluje odebranie wiadomości przez wywołanie handlera bezpośrednio:

```php
public function test_handles_user_updated_event(): void
{
    $author = Author::factory()->create([''user_id'' => 42]);

    $handler = app(UserEventsMessageHandler::class);
    $handler->handle([
        ''event'' => ''user.updated'',
        ''user_id'' => 42,
        ''name'' => ''Nowe Imię'',
        ''email'' => ''nowy@email.com'',
    ]);

    $this->assertDatabaseHas(''authors'', [
        ''user_id'' => 42,
        ''name'' => ''Nowe Imię'',
    ]);
}
```

## Testowanie OAuth2 w SSO

Flow OAuth2 ma wiele kroków. Test end-to-end całego flow:

```php
public function test_authorization_code_flow(): void
{
    $client = Passport::client()->create([...]);
    $user = User::factory()->create();

    // Krok 1: GET /oauth/authorize
    $response = $this->actingAs($user)
        ->get(''/oauth/authorize?'' . http_build_query([
            ''client_id'' => $client->id,
            ''redirect_uri'' => ''https://app.test/callback'',
            ''response_type'' => ''code'',
        ]));

    // Krok 2: POST approve
    $approveResponse = $this->actingAs($user)
        ->post(''/oauth/authorize'', [...]);

    $code = parse_url($approveResponse->headers->get(''Location''), PHP_URL_QUERY);
    parse_str($code, $params);

    // Krok 3: Wymiana kodu na token
    $tokenResponse = $this->post(''/oauth/token'', [
        ''grant_type'' => ''authorization_code'',
        ''code'' => $params[''code''],
        ''client_id'' => $client->id,
    ]);

    $tokenResponse->assertOk()->assertJsonStructure([''access_token'', ''refresh_token'']);
}
```',
  'published',
  '2026-02-27 10:00:00',
  '2026-02-27 10:00:00',
  '2026-02-27 10:00:00'
);
SET @post11 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_backend, @post11);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post11, @tag_tests);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post11, @tag_laravel);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post11, @tag_rabbitmq);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post11, @tag_php);

-- ============================================================
-- POST 12: Mikroserwis Analytics
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Mikroserwis Analytics — zbieranie wyświetleń przez RabbitMQ i agregacja',
  'mikroserwis-analytics-wyswietlenia-rabbitmq',
  'Zbudowałem dedykowany serwis do zbierania i agregowania statystyk wyświetleń postów. Dane przychodzą asynchronicznie przez RabbitMQ, agregaty przechowywane w MySQL.',
  '## Po co osobny serwis?

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
            queue: ''analytics.post_views'',
            callback: function (AMQPMessage $msg) {
                $data = json_decode($msg->body, true);

                // Zapis surowego eventu
                PostView::create([
                    ''post_uuid'' => $data[''post_uuid''],
                    ''user_id''   => $data[''user_id''] ?? null,
                    ''ip''        => $data[''ip''],
                    ''user_agent'' => $data[''user_agent''] ?? null,
                    ''referer''   => $data[''referer''] ?? null,
                    ''viewed_at'' => $data[''timestamp''],
                ]);

                // Upsert agregatu (atomowy increment)
                DB::statement(''
                    INSERT INTO post_view_aggregates (post_uuid, date, view_count)
                    VALUES (?, CURDATE(), 1)
                    ON DUPLICATE KEY UPDATE view_count = view_count + 1
                '', [$data[''post_uuid'']]);

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

Frontend wywołuje analytics API przy wyświetlaniu dashboardu autora. Odpytuje `GET /api/v1/posts/{uuid}/views` dla każdego posta i wyświetla liczbę.',
  'published',
  '2026-03-03 10:00:00',
  '2026-03-03 10:00:00',
  '2026-03-03 10:00:00'
);
SET @post12 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_mikroserwisy, @post12);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post12, @tag_rabbitmq);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post12, @tag_mysql);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post12, @tag_microservices);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post12, @tag_laravel);

-- ============================================================
-- POST 13: Secrets management w Kubernetes
-- ============================================================
INSERT INTO posts (uuid, author_id, title, slug, excerpt, content, status, published_at, created_at, updated_at)
VALUES (
  UUID(),
  @author_id,
  'Secrets management w Kubernetes — Sealed Secrets vs External Secrets Operator',
  'secrets-management-kubernetes-sealed-secrets-vs-external-secrets',
  'Jak bezpiecznie trzymać sekrety w repozytorium GitOps? Porównuję dwa podejścia: Sealed Secrets (szyfrowanie w repo) i External Secrets Operator (sekrety w zewnętrznym vault).',
  '## Problem: sekrety w GitOps

GitOps zakłada, że wszystko jest w repozytorium Git. Ale sekrety (hasła do baz, klucze API) nie mogą być w repo jako plain text.

Naiwne rozwiązanie — placeholder w repo, ręczny kubectl apply dla sekretów — psuje GitOps: ArgoCD nie zarządza sekretami, trzeba pamiętać o ręcznym tworzeniu.

## Opcja 1: Sealed Secrets

Sealed Secrets to operator K8s, który umożliwia zaszyfrowanie sekretu kluczem publicznym klastra. Zaszyfrowany sekret (`SealedSecret`) można bezpiecznie commitować do repo.

```bash
# Instalacja
helm install sealed-secrets sealed-secrets/sealed-secrets -n kube-system

# Szyfrowanie sekretu
kubectl create secret generic db-password \
  --from-literal=password=supersecret \
  --dry-run=client -o yaml | \
  kubeseal --format yaml > k8s/sealed-db-password.yaml
```

Wynikowy `SealedSecret` jest bezużyteczny bez klucza prywatnego klastra:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: db-password
spec:
  encryptedData:
    password: AgBY3mT....(długi zaszyfrowany ciąg)....
```

**Zalety:** proste, działa offline, sekrety w repo razem z manifestami
**Wady:** rotacja kluczy klastra wymaga re-szyfrowania wszystkich sekretów, trudniejsze audytowanie

## Opcja 2: External Secrets Operator (ESO)

ESO synchronizuje sekrety z zewnętrznego vault (AWS Secrets Manager, HashiCorp Vault, GCP Secret Manager) do Kubernetes Secrets.

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-credentials
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-store
    kind: ClusterSecretStore
  target:
    name: db-credentials
  data:
    - secretKey: password
      remoteRef:
        key: portfolio/db
        property: password
```

**Zalety:** centralne zarządzanie sekretami, audyt dostępu, rotacja bez zmian w K8s
**Wady:** zewnętrzna zależność, więcej do konfigurowania

## Co wybrałem?

Na środowisku deweloperskim (Minikube) używam plain `kubectl create secret` — bez GitOps dla sekretów.

Na produkcji planuję **Sealed Secrets** — prostsze i samodzielne, bez potrzeby zewnętrznego vault. Jeśli projekt wyrośnie i trafi do chmury, migracja do ESO + AWS Secrets Manager będzie naturalnym krokiem.

## Secrets w CI/CD

Sekrety używane w GitHub Actions (hasła do GHCR, deploy keys) trzymam w **GitHub Secrets** — zarządzane przez GitHub, odizolowane od kodu:

```yaml
- name: Login to GHCR
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}  # Automatycznie dostępny
```

`GITHUB_TOKEN` jest generowany automatycznie per job — nie trzeba go nigdzie przechowywać.',
  'published',
  '2026-03-07 10:00:00',
  '2026-03-07 10:00:00',
  '2026-03-07 10:00:00'
);
SET @post13 = LAST_INSERT_ID();
INSERT INTO category_post (category_id, post_id) VALUES (@cat_kubernetes, @post13);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post13, @tag_kubernetes);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post13, @tag_argocd);
INSERT INTO post_tag (post_id, tag_id) VALUES (@post13, @tag_devlog);

-- ---------------------------------------------------------------------------
-- Koniec
-- ---------------------------------------------------------------------------
SET foreign_key_checks = 1;

SELECT CONCAT('Wstawiono postów: ', COUNT(*), ' dla author_id = ', MAX(author_id)) AS summary
FROM posts
WHERE author_id = @author_id;
