---
title: "Refaktor i18n — tabela post_translations"
date: 2026-03-23
category: "Dev Log"
tags: [i18n, Laravel, database, API, migrations, translations, architecture]
locale: pl
---

Dotychczas każda wersja językowa posta to był osobny wiersz w tabeli `posts`. Działało, ale generowało dużo problemów -- duplikacja metadanych, nadmuchane liczniki kategorii, oddzielne URL-e per język. Przebudowałem to od podstaw: jeden post, wiele tłumaczeń.

## Problem

W starym schemacie post polski i angielski to dwa niezależne rekordy. Slug zawierał sufiks języka: `intro-01-why-this-blog-pl`, `intro-01-why-this-blog-en`. Każdy miał swoje `author_id`, `status`, `published_at`, kategorie i tagi. Zmiana statusu posta wymagała aktualizacji każdej wersji językowej osobno.

FeaturedPosts potrzebował oddzielnych wpisów per język. `CategoryController` liczył posty per locale przez `where('locale', ...)`, co oznaczało że kategoria z dwoma postami (PL + EN) pokazywała licznik 4 zamiast 2. Wszystko było powiązane z tym, że **locale było właściwością posta, a nie tłumaczenia**.

## Nowy schemat

Rozdzieliłem dane na dwie tabele. `posts` przechowuje metadane niezależne od języka, a `post_translations` -- treść per locale:

```sql
CREATE TABLE posts (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    slug VARCHAR(255) UNIQUE NOT NULL,
    author_id BIGINT UNSIGNED NOT NULL,
    status VARCHAR(20) DEFAULT 'draft',
    published_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

CREATE TABLE post_translations (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_id BIGINT UNSIGNED NOT NULL,
    locale VARCHAR(5) NOT NULL,
    title VARCHAR(255) NOT NULL,
    excerpt TEXT NULL,
    content LONGTEXT NOT NULL,
    version INT UNSIGNED DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    UNIQUE (post_id, locale),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);
```

Slug jest teraz czysty: `intro-01-why-this-blog` -- bez sufiksu języka. Ten sam URL pokazuje treść w języku wybranym przez użytkownika.

## Migracja

Dane w bazie nie były krytyczne (seed generuje je od nowa), więc zamiast pisać skomplikowaną migrację ALTER + INSERT INTO ... SELECT, użyłem podejścia DROP + CREATE. Prosta, czysta migracja bez ryzyka błędu w transformacji danych.

## Zmiany w API

`PostResource` spłaszcza tłumaczenie do odpowiedzi API -- klient dostaje `title`, `excerpt`, `content` na najwyższym poziomie, jakby nic się nie zmieniło:

```php
class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $locale = app()->getLocale();
        $translation = $this->translations->firstWhere('locale', $locale);

        return [
            'id'           => $this->id,
            'slug'         => $this->slug,
            'title'        => $translation?->title,
            'excerpt'      => $translation?->excerpt,
            'content'      => $translation?->content,
            'status'       => $this->status,
            'published_at' => $this->published_at,
            'author'       => new AuthorResource($this->author),
            'categories'   => CategoryResource::collection($this->categories),
            'tags'         => TagResource::collection($this->tags),
        ];
    }
}
```

`FeaturedPostController` filtrował posty po `post.locale`. Teraz filtruje po istnieniu tłumaczenia: `whereHas('translations', fn ($q) => $q->where('locale', $locale))`. `CategoryController` miał ten sam problem z `withCount` -- zmiana z `where('locale')` na `whereHas('translations')` naprawiła liczniki.

## Frontend

`BlogApiService` przekazuje locale z sesji w nagłówku zapytania. Użytkownik zmienia język przełącznikiem -- ten sam URL `/blog/intro-01-why-this-blog` pokazuje treść po polsku lub angielsku bez przekierowania. Nie trzeba było zmieniać routingu ani linków w nawigacji.

## Seed

Skrypt `generate_seed.py` został przebudowany. Wcześniej każdy plik markdown to osobny post. Teraz pliki są grupowane po nazwie katalogu -- `intro-01-why-this-blog/pl.md` i `intro-01-why-this-blog/en.md` tworzą jeden post z dwoma tłumaczeniami. Slug pochodzi z nazwy katalogu.

## Rezultat

Jeden post = jeden rekord, niezależnie od liczby języków. Liczniki kategorii są poprawne. FeaturedPosts działa bez duplikacji. URL-e są czyste i niezależne od locale. API jest wstecznie kompatybilne -- frontend nie wymagał zmian w strukturze odpowiedzi. Architektura jest gotowa na dodanie kolejnych języków bez zmian w schemacie.
