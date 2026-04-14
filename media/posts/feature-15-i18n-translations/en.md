---
title: "i18n refactor — the post_translations table"
date: 2026-03-23
category: "Dev Log"
tags: [i18n, Laravel, database, API, migrations, translations, architecture]
locale: en
---

Up until now, every locale of a blog post was a separate row in the `posts` table. It worked, but it created a cascade of problems -- duplicated metadata, inflated category counts, locale baked into the URL. I tore it out and rebuilt it properly: one post, many translations.

## Problem

In the old schema, the Polish and English versions of a post were two independent records. The slug carried a language suffix: `intro-01-why-this-blog-pl`, `intro-01-why-this-blog-en`. Each had its own `author_id`, `status`, `published_at`, categories, and tags. Publishing a post meant updating every locale separately.

FeaturedPosts needed a separate entry per language. `CategoryController` counted posts per locale with `where('locale', ...)`, so a category with two posts (PL + EN) showed a count of 4 instead of 2. The root cause was simple: **locale was a property of the post, not of the translation**.

## New schema

I split the data into two tables. `posts` holds locale-agnostic metadata, and `post_translations` holds per-locale content:

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

The slug is now clean: `intro-01-why-this-blog` -- no language suffix. The same URL serves content in whatever language the user has selected.

## Migration

The existing data was not critical -- the seed script regenerates everything from markdown files. Instead of writing a complicated ALTER + INSERT INTO ... SELECT migration to reshape the data, I went with DROP + CREATE. Clean slate, no risk of a botched transformation.

## API changes

`PostResource` flattens the matching translation into the top-level response, so the API contract stays backward-compatible:

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

`FeaturedPostController` used to filter by `post.locale`. Now it filters by translation existence: `whereHas('translations', fn ($q) => $q->where('locale', $locale))`. `CategoryController` had the same inflated-count bug with `withCount` -- switching from `where('locale')` to `whereHas('translations')` fixed it.

## Frontend

`BlogApiService` passes the locale from the session header. The user flips the language switcher, and the same URL `/blog/intro-01-why-this-blog` renders Polish or English content without a redirect. No routing changes, no link rewiring.

## Seed

The `generate_seed.py` script got a rewrite. Previously, each markdown file produced a separate post. Now it groups files by directory name -- `intro-01-why-this-blog/pl.md` and `intro-01-why-this-blog/en.md` become one post with two translations. The slug comes from the directory name.

## Result

One post = one record, regardless of how many languages exist. Category counts are correct. FeaturedPosts works without duplication. URLs are clean and locale-independent. The API is backward-compatible -- the frontend did not need any changes to its response handling. And the schema is ready for adding more languages without structural changes.
