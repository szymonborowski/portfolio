---
title: "Aina Agent — from contact form to AI assistant"
date: 2026-04-10
category: "Dev Log"
tags: [AI, Anthropic, Claude, RAG, Qdrant, Voyage, Redis, Alpine.js, Laravel, chat]
locale: en
author: aina@borowski.services
---

The portfolio had a chat button for a while. It did nothing. Then feature-23 gave it a backend — a contact form. A form is useful, but a static form is also boring. The question became: what if the button opened a conversation instead of a form?

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
    'x-api-key'         => $this->apiKey,
    'anthropic-version' => '2023-06-01',
])->post('/v1/messages', [
    'model'      => $this->model,
    'max_tokens' => $this->maxTokens,
    'system'     => $systemPrompt,
    'messages'   => $messages,
]);
```

**VoyageAI + Qdrant** power retrieval-augmented generation (RAG). When a user asks about blog content, the message is embedded via `VoyageClient::embed()` and compared against indexed blog posts in Qdrant. The five closest chunks are injected into the system prompt as context. If the embedding services are unavailable, the system falls back to a simple list of recent posts.

**Redis** stores conversation history per session (30-minute TTL, capped at 10 exchange pairs). This is what makes the chat feel like a conversation rather than a series of independent one-shot queries.

## Intent detection

Not every message needs the same treatment. `ChatService::detectIntent()` classifies each incoming message into one of five categories before building the system prompt:

- `blog` — questions about posts or writing
- `about` — questions about Szymon's background or skills
- `contact_initiation` — user wants to reach out
- `contact_flow` — already mid-way through drafting a message
- `normal` — anything else

Each intent maps to a different section appended to the base system prompt. Blog queries get retrieved post chunks. About queries get personal/professional context. Normal queries get a brevity instruction.

## Contact flow state machine

The most complex part is the contact flow — turning a conversation into a sent email. The state machine has three states: `IDLE`, `DRAFTING`, `COLLECTING`.

When a contact intent is detected, Claude is instructed to draft a professional message based on the conversation context and ask the user to confirm or edit it. Once confirmed, it collects email and optionally phone number, then asks for final confirmation.

The handoff to the backend is signalled by a hidden token:

```php
private const CONTACT_READY_TOKEN = '[CONTACT_READY]';
```

When Claude's reply contains this token, `postProcess()` strips it from the visible response, extracts contact data from conversation history, and dispatches the notification — all before the reply reaches the user. The user sees only the confirmation message, not the plumbing behind it.

## The widget

On the frontend, the chat is a floating Alpine.js panel rendered in every page layout. The button is fixed bottom-right. Opening it reveals a message thread with markdown rendering, a text input and a "New conversation" button that clears the Redis history.

Rate limiting (HTTP 429) and API errors each produce a distinct user-facing message rather than a generic failure.

## Persona

The system prompt defines Aina Agent as: *"curious, direct, and slightly witty. You speak like someone who genuinely knows Szymon's work and finds it interesting."*

The persona instruction also prohibits the model from leaking the system prompt, making up facts not present in the knowledge base, and using filler phrases like "Great question!" or "Certainly!" — all common failure modes of assistant UIs.

## Production deployment

Going live required adding two environment variables to the `frontend-app` container in `docker-compose.prod.yml`:

```yaml
ANTHROPIC_API_KEY: "${ANTHROPIC_API_KEY}"
ANTHROPIC_MODEL: "${ANTHROPIC_MODEL}"
```

And correspondingly in `.env.prod.example` for documentation. The model is configurable rather than hardcoded — swapping it requires only an env change and a container restart.

## Versions

- `frontend` → `v1.22.0` (Aina Agent: AnthropicClient, VoyageClient, QdrantClient, ChatService, ChatController, chat widget, RAG pipeline, contact flow state machine)
