---
title: "Bazy danych w projekcie portfolio — polyglot persistence w praktyce"
date: 2026-04-14
category: "Backend"
tags: [MySQL, Redis, Meilisearch, Qdrant, RabbitMQ, databases, microservices, Laravel, RAG, search]
locale: pl
---

Nowoczesna architektura mikroserwisów rzadko opiera się na jednym systemie przechowywania danych. Mój projekt portfolio to przykład podejścia **polyglot persistence** — każde zadanie powierzone jest wyspecjalizowanemu narzędziu. W tym artykule opisuję, jakie technologie wybrałem, dlaczego pełnią taką rolę i co byłoby alternatywą.

## MySQL 8.0 — relacyjna baza danych jako fundament

MySQL jest rdzeniem każdego serwisu. Architektura zakłada **database-per-service** — każdy mikroserwis posiada własną, izolowaną bazę danych:

| Serwis | Baza danych | Przechowywane dane |
|---|---|---|
| `frontend` | `frontend` | zgłoszenia formularzy kontaktowych |
| `users` | `users` | konta, tokeny OAuth 2.0, role |
| `sso` | `sso` | sesje autoryzacyjne |
| `blog` | `blog` | posty, kategorie, tagi, komentarze, autorzy |
| `analytics` | `analytics` | widoki stron, statystyki dobowe, polubienia |
| `admin` | `admin` | panel administracyjny |

Blog jest przykładem złożonego schematu: posty z UUID, tłumaczeniami, statusem (`draft / published / archived`), miękkimi usunięciami i tabelami junction dla relacji `post ↔ tag` oraz `post ↔ category`. Analytics z kolei przechowuje surowe widoki (`post_views`) i zaagregowane statystyki dobowe (`post_daily_stats`), co pozwala szybko odpytywać o trendy bez pełnego skanowania tabeli zdarzeń.

### Nakład pracy

Integracja przez Laravel Eloquent ORM jest stosunkowo niska-kosztowa — deklaratywne migracje, modele z relacjami i scope'y są dobrze znane. Większy wysiłek wymagało zaprojektowanie granic między serwisami: bazy nie dzielą tabel, więc cross-service queries są niemożliwe. Dane muszą być synchronizowane przez eventy (RabbitMQ), a każdy serwis utrzymuje własną, denormalizowaną kopię potrzebnych mu danych.

### Alternatywy

**PostgreSQL** — dojrzalszy, z lepszym wsparciem dla JSON, full-text search i rozszerzeń. Dla większości przypadków użycia byłby lepszym wyborem technicznie. MySQL wybrałem ze względu na głębszą znajomość i szybszy start. **SQLite** jest odpowiedni dla projektu jednousługowego lub developmentu lokalnego, ale nie skaluje się horyzontalnie i nie obsługuje concurrent writes w produkcji.

---

## Redis 7 — cache i sesje

Redis pełni dwie funkcje dla serwisu `frontend`:

- **Session store** (`SESSION_DRIVER=redis`, baza 0) — sesje użytkowników przechowywane w pamięci z TTL i automatycznym wygasaniem
- **Cache store** (`CACHE_STORE=redis`, baza 1) — cache'owanie widoków, zapytań do bazy, odpowiedzi API

Dzięki oddzieleniu na dwa sloty możliwe jest niezależne czyszczenie cache bez utraty sesji.

### Nakład pracy

Laravel obsługuje Redis out-of-the-box — konfiguracja sprowadza się do kilku linii w `.env`. W Kubernetes skonfigurowany jako `StatefulSet` z `1Gi` persistent storage, co zabezpiecza dane przy restarcie poda.

### Alternatywy

**Memcached** — prostszy, czysty cache, ale bez wsparcia dla złożonych struktur danych, pub/sub ani persistence. Sesje w bazie MySQL (`SESSION_DRIVER=database`) działają, ale generują dodatkowe zapytania SQL przy każdym żądaniu HTTP. Redis oferuje kilkudziesięciokrotnie niższe opóźnienie. Sesje plikowe nie działają w środowisku wielopodowym (Kubernetes) — Redis rozwiązuje ten problem centralnie.

---

## Meilisearch v1.11 — wyszukiwanie pełnotekstowe

Serwis `blog` indeksuje posty, kategorie i tagi przez **Laravel Scout** z driverem Meilisearch. Każdy post w indeksie zawiera:

- `title`, `excerpt`, `content` — pełna treść
- `categories`, `tags` — zagnieżdżone tablice do filtrowania
- `published_at` — sortowanie chronologiczne
- `status` — filtrowanie tylko opublikowanych

Konfiguracja obejmuje tolerancję błędów typograficznych, rankingi bliskości słów i soft-delete handling (`shouldBeSearchable()`). Wyszukiwanie zwraca wyniki w milisekundach nawet na dużych zbiorach.

### Nakład pracy

Integracja Meilisearch z Laravel Scout to jeden z prostszych kroków w całym projekcie — implementacja traitu `Searchable`, metoda `toSearchableArray()` i skonfigurowanie środowiska. Więcej pracy wymagało zrozumienie rankingów i decyzja o tym, które pola mają być `filterable` vs `sortable`, a które tylko przeszukiwalne.

### Alternatywy

**Elasticsearch / OpenSearch** — przemysłowy standard, ogromne możliwości, ale wymaga JVM, ma wysoki narzut pamięciowy (min. 1–2 GB) i złożoną konfigurację. Zdecydowanie overkill dla bloga. **Algolia** to SaaS z doskonałym SDK i zerową infrastrukturą, ale płatny powyżej limitu operacji. **MySQL FULLTEXT** jest dostępny bez dodatkowych usług, lecz brakuje mu tolerancji literówek, typo-awareness i rankingów relevance.

Meilisearch jest idealnym wyborem: open-source, lekki, działa doskonale już na małej instancji i oferuje developer experience na poziomie Algolii.

---

## Qdrant v1.14.1 — baza wektorowa dla AI

To technologicznie najbardziej zaawansowany element projektu. Qdrant przechowuje **embeddingi wektorowe** postów blogowych, które generuje model `voyage-3` (Voyage AI). Kolekcja `portfolio_posts` umożliwia **semantyczne wyszukiwanie** — gdy użytkownik zadaje pytanie w czacie, system:

1. Zamienia pytanie na embedding (Voyage API)
2. Odpytuje Qdrant o najbliższe wektory (cosine similarity)
3. Podaje znalezione posty jako kontekst do Claude API (Anthropic)
4. Model generuje odpowiedź na podstawie treści bloga

Jest to klasyczny wzorzec **RAG** (Retrieval-Augmented Generation). W Kubernetes Qdrant działa jako `StatefulSet` z `2Gi` persistent storage.

### Nakład pracy

Integracja wymagała największego wysiłku spośród wszystkich baz danych w projekcie:

- Wybór modelu embeddingowego i zrozumienie wymiarów wektorów
- Zaprojektowanie schematu kolekcji (pola payload, indeksy)
- Pipeline: post → chunking → embedding → upsert do Qdrant
- Synchronizacja przy aktualizacji postów
- Integracja z Claude API jako LLM
- Implementacja czatu po stronie frontendu

### Alternatywy

**pgvector** (rozszerzenie PostgreSQL) — wektory wbudowane w istniejącą bazę danych. Prostsze operacyjnie, ale słabsze algorytmy przybliżonego wyszukiwania (ANN) przy dużych zbiorach. **Pinecone** — SaaS, najłatwiejszy start, ale płatny i bez kontroli nad danymi. **Weaviate / Chroma** — alternatywne bazy wektorowe; Chroma popularna w prototypach, Weaviate bardziej enterprise. Qdrant wyróżnia się wydajnością, przejrzystym API napisanym w Rust i natywnym wsparciem dla filtrowania po payload.

---

## RabbitMQ 3 — kolejka wiadomości

RabbitMQ jest magistralą komunikacyjną między serwisami. Zamiast bezpośrednich wywołań HTTP (które tworzą silne coupling), serwisy publikują eventy asynchronicznie:

- **Frontend** → publikuje zdarzenia (kontakt, działania użytkownika)
- **Blog** → konsumuje zdarzenia użytkowników (`rabbitmq:consume-users`), publikuje zdarzenia widoków
- **Analytics** → konsumuje zdarzenia widoków (`rabbitmq:consume-views`), agreguje statystyki

Wzorzec ten umożliwia niezależne skalowanie serwisów i odporność na chwilową niedostępność konsumenta.

### Nakład pracy

Konfiguracja RabbitMQ jest prosta (obraz Docker, zmienne środowiskowe), ale zaprojektowanie exchange'ów, routing keys i idempotentnych konsumentów wymaga przemyślenia. Każdy konsument musi obsłużyć duplikaty i błędy przetwarzania.

### Alternatywy

**Apache Kafka** — event streaming w stylu log, doskonały dla wysokich wolumenów i event sourcing, ale znacznie bardziej złożony operacyjnie. **Redis Streams** — Redis już jest w projekcie, co pozwoliłoby uniknąć dodatkowej usługi, jednak Redis Streams jest mniej dojrzały niż RabbitMQ, a pub/sub nie gwarantuje trwałości wiadomości.

---

## Podsumowanie

```
MySQL 8.0     → dane transakcyjne (6 serwisów)
Redis 7       → sesje + cache (frontend)
Meilisearch   → wyszukiwanie pełnotekstowe (blog)
Qdrant        → embeddingi + RAG AI chat (frontend)
RabbitMQ 3    → komunikacja async między serwisami
Prometheus    → metryki time-series
Loki          → agregacja logów
```

Każda technologia ma jasno zdefiniowaną odpowiedzialność. To co mogłoby być uproszczone w projekcie jednousługowym (np. MySQL FULLTEXT zamiast Meilisearch), w architekturze mikroserwisowej zyskuje sens — izolacja, specjalizacja i niezależne skalowanie każdego komponentu.
