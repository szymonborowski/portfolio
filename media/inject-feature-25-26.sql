-- =============================================================
-- Patch: inject feature-25-aina-agent and feature-26-pao
-- Safe: no TRUNCATE, INSERT IGNORE for categories/tags/pivots
-- =============================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Category (safe if already exists)
INSERT IGNORE INTO categories (name, slug, color, icon) VALUES
  ('Dev Log', 'dev-log', 'emerald', 'command-line');

-- Tags (safe if already exist)
INSERT IGNORE INTO tags (name, slug) VALUES
  ('AI', 'ai'),
  ('Anthropic', 'anthropic'),
  ('Claude', 'claude'),
  ('RAG', 'rag'),
  ('Qdrant', 'qdrant'),
  ('Voyage', 'voyage'),
  ('Redis', 'redis'),
  ('Alpine', 'alpine'),
  ('laravel', 'laravel'),
  ('chat', 'chat'),
  ('js', 'js'),
  ('PHP', 'php'),
  ('PHPUnit', 'phpunit'),
  ('Pest', 'pest'),
  ('testowanie', 'testowanie'),
  ('agent', 'agent'),
  ('nunomaduro', 'nunomaduro'),
  ('pao', 'pao'),
  ('testing', 'testing'),
  ('developer-experience', 'developer-experience');

-- Posts
-- feature-25-aina-agent
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'b07caa0b-3307-40fb-adb7-dfa6518ee87a',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-25-aina-agent',
  'published',
  '2026-04-10 12:00:00',
  '2026-04-10 12:00:00',
  '2026-04-10 12:00:00'
);

-- feature-26-pao
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '060c1422-3687-4ecd-8e8b-481546040eb7',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-26-pao',
  'published',
  '2026-04-11 12:00:00',
  '2026-04-11 12:00:00',
  '2026-04-11 12:00:00'
);

-- Translations
-- feature-25-aina-agent [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Aina Agent — od formularza kontaktowego do asystenta AI — feature-25', 'Portfolio miało przycisk do chatu od jakiegoś czasu. Nie robił nic. Potem feature-23 dał mu backend — formularz kontaktowy. Formularz jest użyteczny, ale też nudny. Pytanie stało się: co jeśli przycisk otwierałby rozmowę zamiast formularza?',
         'Portfolio miało przycisk do chatu od jakiegoś czasu. Nie robił nic. Potem feature-23 dał mu backend — formularz kontaktowy. Formularz jest użyteczny, ale też nudny. Pytanie stało się: co jeśli przycisk otwierałby rozmowę zamiast formularza?

Ten release jest odpowiedzią: Aina Agent — asystent AI wbudowany w portfolio.

## Pomysł — i dlaczego ewoluował

Pierwotny plan był prosty: pływający przycisk → modal z formularzem → email do Szymona. Feature-23 zaimplementował dokładnie to. Działa.

Ale formularz ma stały kształt. Użytkownik, który chce wiedzieć jakiego stacku używa portfolio, albo który post blogowy omawia OAuth2, albo czy Szymon jest dostępny na zlecenia — trzy pytania trafiają do tego samego formularza, który nie odpowiada na żadne z nich.

Asystent AI może odpowiedzieć na wszystkie trzy. A jeśli użytkownik ostatecznie chce nawiązać kontakt, asystent może zebrać dla niego wiadomość i ją wysłać. Formularz staje się wyjściem z rozmowy, a nie całym interfejsem.

## Stack

Chat opiera się na czterech głównych zależnościach:

**Anthropic Claude** obsługuje język. `AnthropicClient` to cienka warstwa nad Messages API:

```php
$response = Http::withHeaders([
    \'x-api-key\'         => $this->apiKey,
    \'anthropic-version\' => \'2023-06-01\',
])->post(\'/v1/messages\', [
    \'model\'      => $this->model,
    \'max_tokens\' => $this->maxTokens,
    \'system\'     => $systemPrompt,
    \'messages\'   => $messages,
]);
```

**VoyageAI + Qdrant** napędzają retrieval-augmented generation (RAG). Gdy użytkownik pyta o treść bloga, wiadomość jest embeddowana przez `VoyageClient::embed()` i porównywana z zindeksowanymi postami w Qdrant. Pięć najbliższych fragmentów jest wstrzykiwanych do system prompta jako kontekst. Jeśli serwisy embeddingów są niedostępne, system wraca do prostej listy ostatnich postów.

**Redis** przechowuje historię rozmowy per sesja (TTL 30 minut, maksymalnie 10 par wymian). To sprawia, że chat przypomina rozmowę, a nie serię niezależnych jednorazowych zapytań.

## Detekcja intencji

Nie każda wiadomość wymaga takiego samego traktowania. `ChatService::detectIntent()` klasyfikuje każdą przychodzącą wiadomość do jednej z pięciu kategorii przed zbudowaniem system prompta:

- `blog` — pytania o posty lub pisanie
- `about` — pytania o background lub umiejętności Szymona
- `contact_initiation` — użytkownik chce się skontaktować
- `contact_flow` — już w trakcie redagowania wiadomości
- `normal` — wszystko inne

Każda intencja mapuje się na inną sekcję dodawaną do bazowego system prompta. Zapytania blogowe dostają pobrane fragmenty postów. Zapytania osobiste dostają kontekst zawodowy. Normalne zapytania dostają instrukcję zwięzłości.

## Maszyna stanów przepływu kontaktowego

Najkompleksiejsza część to przepływ kontaktowy — przekształcenie rozmowy w wysłany email. Maszyna stanów ma trzy stany: `IDLE`, `DRAFTING`, `COLLECTING`.

Gdy wykryta zostanie intencja kontaktowa, Claude otrzymuje polecenie zredagowania profesjonalnej wiadomości na podstawie kontekstu rozmowy i prosi użytkownika o potwierdzenie lub edycję. Po potwierdzeniu zbiera adres email i opcjonalnie numer telefonu, a następnie prosi o ostateczne potwierdzenie.

Przekazanie do backendu jest sygnalizowane ukrytym tokenem:

```php
private const CONTACT_READY_TOKEN = \'[CONTACT_READY]\';
```

Gdy odpowiedź Claude\'a zawiera ten token, `postProcess()` usuwa go z widocznej odpowiedzi, wydobywa dane kontaktowe z historii rozmowy i wysyła powiadomienie — wszystko to przed dotarciem odpowiedzi do użytkownika. Użytkownik widzi tylko wiadomość potwierdzającą, nie instalację wodno-kanalizacyjną za nią.

## Widget

Na froncie chat to pływający panel Alpine.js renderowany w każdym layoucie strony. Przycisk jest przyklejony do prawego dolnego rogu. Otwarcie pokazuje wątek wiadomości z renderowaniem markdown, pole tekstowe i przycisk „Nowa rozmowa" czyszczący historię Redis.

Rate limiting (HTTP 429) i błędy API każdy produkują odrębną wiadomość dla użytkownika zamiast ogólnego komunikatu o błędzie.

## Persona

System prompt definiuje Ainę Agent jako: *„ciekawą, bezpośrednią i lekko dowcipną. Mówi jak ktoś, kto naprawdę zna pracę Szymona i znajduje ją interesującą."*

Instrukcja persony zabrania też modelowi ujawniania system prompta, wymyślania faktów nieobecnych w bazie wiedzy oraz używania wypełniaczy jak „Świetne pytanie!" lub „Oczywiście!" — to typowe błędy interfejsów asystenta.

## Deployment produkcyjny

Uruchomienie na produkcji wymagało dodania dwóch zmiennych środowiskowych do kontenera `frontend-app` w `docker-compose.prod.yml`:

```yaml
ANTHROPIC_API_KEY: "${ANTHROPIC_API_KEY}"
ANTHROPIC_MODEL: "${ANTHROPIC_MODEL}"
```

I odpowiednio w `.env.prod.example` dla dokumentacji. Model jest konfigurowalny zamiast hardkodowanego — zmiana wymaga tylko modyfikacji zmiennej środowiskowej i restartu kontenera.

## Wersje

- `frontend` → `v1.22.0` (Aina Agent: AnthropicClient, VoyageClient, QdrantClient, ChatService, ChatController, widget chatu, pipeline RAG, maszyna stanów przepływu kontaktowego)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-25-aina-agent';

-- feature-25-aina-agent [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Aina Agent — from contact form to AI assistant — feature-25', 'The portfolio had a chat button for a while. It did nothing. Then feature-23 gave it a backend — a contact form. A form is useful, but a static form is also boring. The question became: what if the button opened a conversation instead of a form?',
         'The portfolio had a chat button for a while. It did nothing. Then feature-23 gave it a backend — a contact form. A form is useful, but a static form is also boring. The question became: what if the button opened a conversation instead of a form?

This release is the answer: Aina Agent, an AI assistant embedded in the portfolio.

## The idea — and why it changed

The original plan was simple: floating button → modal with a form → email to Szymon. Feature-23 implemented exactly that. It works.

But a form has a fixed shape. A user who wants to know what stack the portfolio uses, or which blog post covers OAuth2, or whether Szymon is available for freelance work — all three questions map to the same form, which answers none of them.

An AI assistant can answer all three. And if the user ends up wanting to actually reach out, the assistant can collect the message for them, then send it. The form becomes an exit ramp from a conversation, not the whole interface.

## Stack

The chat is built on four main dependencies:

**Anthropic Claude** handles language. `AnthropicClient` is a thin wrapper around the Messages API:

```php
$response = Http::withHeaders([
    \'x-api-key\'         => $this->apiKey,
    \'anthropic-version\' => \'2023-06-01\',
])->post(\'/v1/messages\', [
    \'model\'      => $this->model,
    \'max_tokens\' => $this->maxTokens,
    \'system\'     => $systemPrompt,
    \'messages\'   => $messages,
]);
```

**VoyageAI + Qdrant** power retrieval-augmented generation (RAG). When a user asks about blog content, the message is embedded via `VoyageClient::embed()` and compared against indexed blog posts in Qdrant. The five closest chunks are injected into the system prompt as context. If the embedding services are unavailable, the system falls back to a simple list of recent posts.

**Redis** stores conversation history per session (30-minute TTL, capped at 10 exchange pairs). This is what makes the chat feel like a conversation rather than a series of independent one-shot queries.

## Intent detection

Not every message needs the same treatment. `ChatService::detectIntent()` classifies each incoming message into one of five categories before building the system prompt:

- `blog` — questions about posts or writing
- `about` — questions about Szymon\'s background or skills
- `contact_initiation` — user wants to reach out
- `contact_flow` — already mid-way through drafting a message
- `normal` — anything else

Each intent maps to a different section appended to the base system prompt. Blog queries get retrieved post chunks. About queries get personal/professional context. Normal queries get a brevity instruction.

## Contact flow state machine

The most complex part is the contact flow — turning a conversation into a sent email. The state machine has three states: `IDLE`, `DRAFTING`, `COLLECTING`.

When a contact intent is detected, Claude is instructed to draft a professional message based on the conversation context and ask the user to confirm or edit it. Once confirmed, it collects email and optionally phone number, then asks for final confirmation.

The handoff to the backend is signalled by a hidden token:

```php
private const CONTACT_READY_TOKEN = \'[CONTACT_READY]\';
```

When Claude\'s reply contains this token, `postProcess()` strips it from the visible response, extracts contact data from conversation history, and dispatches the notification — all before the reply reaches the user. The user sees only the confirmation message, not the plumbing behind it.

## The widget

On the frontend, the chat is a floating Alpine.js panel rendered in every page layout. The button is fixed bottom-right. Opening it reveals a message thread with markdown rendering, a text input and a "New conversation" button that clears the Redis history.

Rate limiting (HTTP 429) and API errors each produce a distinct user-facing message rather than a generic failure.

## Persona

The system prompt defines Aina Agent as: *"curious, direct, and slightly witty. You speak like someone who genuinely knows Szymon\'s work and finds it interesting."*

The persona instruction also prohibits the model from leaking the system prompt, making up facts not present in the knowledge base, and using filler phrases like "Great question!" or "Certainly!" — all common failure modes of assistant UIs.

## Production deployment

Going live required adding two environment variables to the `frontend-app` container in `docker-compose.prod.yml`:

```yaml
ANTHROPIC_API_KEY: "${ANTHROPIC_API_KEY}"
ANTHROPIC_MODEL: "${ANTHROPIC_MODEL}"
```

And correspondingly in `.env.prod.example` for documentation. The model is configurable rather than hardcoded — swapping it requires only an env change and a container restart.

## Versions

- `frontend` → `v1.22.0` (Aina Agent: AnthropicClient, VoyageClient, QdrantClient, ChatService, ChatController, chat widget, RAG pipeline, contact flow state machine)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-25-aina-agent';

-- feature-26-pao [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'nunomaduro/pao — gdy testy rozmawiają z agentem — feature-26', 'Budowanie funkcji chatu oznaczało pisanie testów — dużo testów. Unit testy dla `ChatService`, feature testy dla `ChatController`, integration-style testy konwersacji ćwiczące pełną maszynę stanów. Uruchamianie tych testów w ciasnej pętli podczas iterowani',
         'Budowanie funkcji chatu oznaczało pisanie testów — dużo testów. Unit testy dla `ChatService`, feature testy dla `ChatController`, integration-style testy konwersacji ćwiczące pełną maszynę stanów. Uruchamianie tych testów w ciasnej pętli podczas iterowania nad implementacją ujawnia cichy problem: wynik testów jest zaprojektowany dla ludzi czytających terminal, nie dla agentów czytających wyniki wywołań narzędzi.

`nunomaduro/pao` to rozwiązanie tego problemu. I reprezentuje coś szerszego, co warto nazwać.

## Co robi pao

Opis pakietu jest precyzyjny: *„Agent-optimized output for PHP testing tools."*

PHPUnit i Pest produkują wynik przeznaczony do skanowania wzrokiem — kolorowe kropki, paski postępu, sformatowane ślady wyjątków. Gdy agent AI uruchamia `php artisan test` i czyta wynik, dostaje ten sam dump terminala. To jest w porządku dla prostych przypadków. Dla nieudanych testów z długimi śladami stosu, zagnieżdżonymi wyjątkami lub równoległym wynikiem testów stosunek sygnału do szumu spada.

Pao przechwytuje pipeline wyjściowy i reformatuje go w strukturę, którą agenci mogą niezawodnie parsować: czysty JSON gdy uruchamiany w kontekście agentycznym (wykrytym przez `shipfastlabs/agent-detector`), niezmodyfikowany czytelny dla człowieka wynik gdy nie. Przełącznik jest automatyczny — żadnych flag, żadnej konfiguracji.

```json
{
  "status": "failed",
  "tests": 42,
  "assertions": 187,
  "failures": [
    {
      "test": "Tests\\\\Unit\\\\ChatServiceTest::history_is_capped_at_max_pairs",
      "message": "Expected 20 messages, got 22.",
      "file": "tests/Unit/ChatServiceTest.php",
      "line": 94
    }
  ]
}
```

Agent dostaje dokładnie to, czego potrzebuje, żeby zlokalizować błąd i go zrozumieć. Żadnych kodów ANSI, żadnych pasków postępu, żadnych dekoracyjnych obramowań.

## Jak się integruje

Pao dostarcza Laravel `ServiceProvider` i plugin Pest, oba rejestrowane automatycznie przez extras w `composer.json`. Po `composer require --dev nunomaduro/pao` nie ma nic więcej do konfiguracji. Runner testów wykrywa kontekst wykonania i wybiera odpowiedni driver wyjściowy.

Oba serwisy — `frontend` i `blog` — otrzymały pakiet jako dev dependency. Wpływa tylko na uruchomienia testów — zero wpływu na produkcję, zero narzutu w czasie działania.

## Koncepcja pao

"Pao" to skrót od szerszej idei: **tooling zoptymalizowany pod agenta**.

Przemysł oprogramowania spędził dekady budując narzędzia dla ludzkich developerów — IDE z podświetlaniem składni, terminale z kolorowym wynikiem, dashboardy z wykresami. To wszystko jest słuszne i wartościowe. Ale gdy agent AI jest głównym konsumentem wyjścia narzędzia — uruchamia testy, czyta logi, parsuje wyniki buildu — formaty wyjściowe zorientowane na człowieka stają się tarciem.

Pao stosuje to myślenie do runnerów testów. Ten sam princyp dotyczy linterów (ustrukturyzowane błędy JSON zamiast kolorowych diffów), narzędzi buildujących (czytelne maszynowo podsumowania zamiast ASCII-art postępu), formaterów logów (ustrukturyzowane pola zamiast swobodnych stringów). Wzorzec jest taki: wykryj konsumenta, wyemituj odpowiedni format.

Ma to coraz większe znaczenie, gdy agenci AI stają się uczestnikami pętli developmentu, a nie jedynie okazjonalnymi pomocnikami. Agent, który pisze kod, uruchamia testy, czyta wyniki i iteruje — bez człowieka w pętli przy każdym cyklu — potrzebuje toolingu, który mówi jego językiem.

## Dlaczego ma znaczenie konkretnie dla tego projektu

Funkcja chatu była rozwijana z Claudem jako aktywnym współpracownikiem — sugerującym implementacje, uruchamiającym testy w celu ich weryfikacji, czytającym błędy i iterującym. Pao sprawiło, że ta pętla była szybsza i bardziej niezawodna. Zamiast parsować wynik terminala heurystycznie, agent otrzymywał ustrukturyzowane dane o błędach, na których mógł działać bezpośrednio.

To jest prawdziwy argument za pao: nie to, że jest technicznie sprytne, ale to, że zamyka lukę, która po cichu spowalnia współpracę człowiek-agent w projektach PHP.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-26-pao';

-- feature-26-pao [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'nunomaduro/pao — when your tests talk to the agent — feature-26', 'Building the chat feature meant writing tests — a lot of them. Unit tests for `ChatService`, feature tests for `ChatController`, integration-style conversation tests that exercise the full state machine. Running those tests in a tight loop while iterating',
         'Building the chat feature meant writing tests — a lot of them. Unit tests for `ChatService`, feature tests for `ChatController`, integration-style conversation tests that exercise the full state machine. Running those tests in a tight loop while iterating on the implementation surfaces a quiet problem: test output is designed for humans reading a terminal, not for agents reading tool call results.

`nunomaduro/pao` is the fix for that. And it represents something broader worth naming.

## What pao does

The package description is precise: *"Agent-optimized output for PHP testing tools."*

PHPUnit and Pest produce output meant to be scanned visually — coloured dots, progress bars, formatted exception traces. When an AI agent runs `php artisan test` and reads the result, it gets the same terminal dump. That is fine for simple cases. For failing tests with long stack traces, nested exceptions, or parallel test output, the signal-to-noise ratio drops.

Pao intercepts the output pipeline and reformats it into a structure that agents can parse reliably: clean JSON when running in an agentic context (detected via `shipfastlabs/agent-detector`), unmodified human-readable output when not. The switch is automatic — no flags, no configuration.

```json
{
  "status": "failed",
  "tests": 42,
  "assertions": 187,
  "failures": [
    {
      "test": "Tests\\\\Unit\\\\ChatServiceTest::history_is_capped_at_max_pairs",
      "message": "Expected 20 messages, got 22.",
      "file": "tests/Unit/ChatServiceTest.php",
      "line": 94
    }
  ]
}
```

The agent gets exactly what it needs to locate the failure and understand it. No ANSI codes, no progress bars, no decorative borders.

## How it integrates

Pao ships a Laravel `ServiceProvider` and a Pest plugin, both registered automatically via `composer.json` extras. After `composer require --dev nunomaduro/pao`, there is nothing else to configure. The test runner detects the execution context and selects the appropriate output driver.

Both `frontend` and `blog` services received the package as a dev dependency. It only affects test runs — no production impact, no runtime overhead.

## The concept of pao

"Pao" is shorthand for the broader idea: **agent-optimized tooling**.

The software industry has spent decades building tools for human developers — IDEs with syntax highlighting, terminals with colour output, dashboards with charts. All of that is correct and valuable. But when an AI agent is the primary consumer of a tool\'s output — running tests, reading logs, parsing build results — human-oriented output formats become friction.

Pao applies this thinking to test runners. The same principle applies to linters (structured JSON errors rather than coloured diffs), build tools (machine-readable summaries rather than ASCII art progress), log formatters (structured fields rather than freeform strings). The pattern is: detect the consumer, emit the appropriate format.

This matters more as AI agents become participants in development loops rather than occasional helpers. An agent that writes code, runs tests, reads the results, and iterates — without a human in the loop for each cycle — needs tooling that speaks its language.

## Why it matters for this project specifically

The chat feature was developed with Claude acting as an active collaborator — suggesting implementations, running tests to verify them, reading failures and iterating. Pao made that loop faster and more reliable. Instead of the agent parsing terminal output heuristically, it received structured failure data it could act on directly.

That is the real argument for pao: not that it is technically clever, but that it closes a gap that quietly slows down human–agent collaboration in PHP projects.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-26-pao';

-- Category pivots
INSERT IGNORE INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-25-aina-agent';
INSERT IGNORE INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-26-pao';

-- Tag pivots
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'js';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'ai';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'rag';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'alpine';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'anthropic';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'qdrant';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'claude';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'redis';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'chat';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'voyage';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'ai';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'pest';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'agent';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'testowanie';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'php';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'pao';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'testing';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'nunomaduro';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'phpunit';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'developer-experience';

