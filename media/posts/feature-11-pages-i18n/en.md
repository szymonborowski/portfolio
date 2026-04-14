---
title: "Language switcher, new pages, and newsletter"
date: 2026-03-20
category: "Dev Update"
tags: [i18n, pl, en, newsletter, contact, pages, blog, admin, laravel]
locale: en
---

A large cross-cutting iteration — two-language support (PL/EN) across the entire system, new static pages in Frontend, a newsletter, and a GitHub commits tile on the homepage.

**Services: Frontend, Blog, Admin**

## PL/EN language switcher

I added locale-switching routing with session storage:

```php
// Language switcher
Route::get('/locale/{locale}', function (string $locale) {
    abort_if(! in_array($locale, ['pl', 'en']), 404);
    session(['locale' => $locale]);
    return redirect()->back();
});
```

The `SetLocale` middleware reads the session value on every request and calls `App::setLocale()`. All strings in views go through `__()` or `@lang()`. Translations live in `lang/pl/` and `lang/en/`.

## New Frontend pages

### About me

A page with the author's description, links to CV (PL/EN as separate PDF files), and links to GitHub and LinkedIn. Content is translated — each language version has its own translation file.

### Contact

A contact form with server-side validation. Messages sent via OVH SMTP. Honeypot for spam protection.

### Collaboration

A page describing collaboration opportunities: freelance, consulting, code review. A simple static page with translations.

## GitHub commits tile

The homepage now has a widget showing recent commits to the project repository. Frontend queries the GitHub API, caches the response for 10 minutes in Redis, and displays a list of the last 5 commits with links.

## Blog: `locale` and `version` fields

Posts in Blog got two new fields:
- `locale` — post language (`pl` or `en`)
- `version` — post version linked to the same topic in the other language

This enables linking between language versions of the same post: "Read in Polish / Czytaj po polsku".

## Blog: newsletter subscriber

A new `Subscriber` model in Blog with fields: `email`, `locale`, `confirmed_at`. A `POST /newsletter/subscribe` endpoint with email verification via a confirmation link (OVH SMTP).

## Admin: language filters in Manage Posts

The Manage Posts page in Filament got:
- A `locale` filter — show only Polish / only English posts
- A `version` selector — assign a language version to a post
- A `locale` column in the listing table
