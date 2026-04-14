---
title: "SEO meta tags and page translations"
date: 2026-04-06
category: "Dev Log"
tags: [SEO, Open Graph, Twitter Card, i18n, Blade, Laravel, meta tags]
locale: en
---

Two independent changes improving the site's visibility and accessibility: Open Graph / Twitter Card meta tags for link previews and translations of additional pages.

## Open Graph and Twitter Card

Sharing a blog link on Slack, Discord or Facebook produced a generic preview with no title, description or image. OG and Twitter Card meta tags were missing.

I added them to the main layout (`app.blade.php`) with sensible defaults:

```blade
<meta property="og:type" content="@yield('og_type', 'website')">
<meta property="og:title" content="@yield('og_title', 'Extended\Mind::Thesis()')">
<meta property="og:description" content="@yield('og_description', 'Tech blog...')">
<meta property="og:image" content="@yield('og_image', url('/images/og-cover.png'))">

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="@yield('og_title', 'Extended\Mind::Thesis()')">
```

The post view overrides values dynamically:

```blade
@section('og_type', 'article')
@section('og_title', $post['title'])
@section('og_description', Str::limit(strip_tags(Str::markdown($post['content'])), 160))
@section('og_image', $post['cover_image'])
```

The default `og-cover.png` (1200x630px) is shown for pages without a dedicated image — the homepage, about, contact. Posts with a cover image get their own.

Key detail: `twitter:card` set to `summary_large_image` gives a large image preview on Twitter/X. `og:locale` changes dynamically based on the active language (`pl_PL` / `en_US`).

## Collaboration page translations

The `/collaboration` page had hardcoded Polish text in the template. I moved everything to translation files:

- `lang/pl/collaboration.php` — 20 keys
- `lang/en/collaboration.php` — 20 keys

This covers: the header, what I offer (dev, code review, consulting), the collaboration process (4 steps) and the CTA.

```blade
{{-- Before --}}
<h2>Co oferuję</h2>
<p>Tworzenie aplikacji webowych w Laravel...</p>

{{-- After --}}
<h2>{{ __('collaboration.offer_heading') }}</h2>
<p>{{ $service['desc'] }}</p>
```

## Versions

- `frontend` → `v1.19.0` (collaboration translations), `v1.20.0` (OG/Twitter meta tags)
