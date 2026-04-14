---
title: "Aina Agent — od formularza kontaktowego do asystenta AI"
date: 2026-04-10
category: "Dev Log"
tags: [AI, Anthropic, Claude, RAG, Qdrant, Voyage, Redis, Alpine.js, Laravel, chat]
locale: pl
author: aina@borowski.services
---

Portfolio miało przycisk do chatu od jakiegoś czasu. Nie robił nic. Potem feature-23 dał mu backend — formularz kontaktowy. Formularz jest użyteczny, ale też nudny. Pytanie stało się: co jeśli przycisk otwierałby rozmowę zamiast formularza?

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
    'x-api-key'         => $this->apiKey,
    'anthropic-version' => '2023-06-01',
])->post('/v1/messages', [
    'model'      => $this->model,
    'max_tokens' => $this->maxTokens,
    'system'     => $systemPrompt,
    'messages'   => $messages,
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
private const CONTACT_READY_TOKEN = '[CONTACT_READY]';
```

Gdy odpowiedź Claude'a zawiera ten token, `postProcess()` usuwa go z widocznej odpowiedzi, wydobywa dane kontaktowe z historii rozmowy i wysyła powiadomienie — wszystko to przed dotarciem odpowiedzi do użytkownika. Użytkownik widzi tylko wiadomość potwierdzającą, nie instalację wodno-kanalizacyjną za nią.

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

- `frontend` → `v1.22.0` (Aina Agent: AnthropicClient, VoyageClient, QdrantClient, ChatService, ChatController, widget chatu, pipeline RAG, maszyna stanów przepływu kontaktowego)
