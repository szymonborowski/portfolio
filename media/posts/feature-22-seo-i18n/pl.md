---
title: "SEO meta tagi i tłumaczenia stron"
date: 2026-04-06
category: "Dev Log"
tags: [SEO, Open Graph, Twitter Card, i18n, Blade, Laravel, meta tagi]
locale: pl
---

Dwie niezależne zmiany poprawiające widoczność i dostępność strony: meta tagi Open Graph / Twitter Card dla podglądów linków oraz tłumaczenia kolejnych podstron.

## Open Graph i Twitter Card

Udostępnienie linka do bloga na Slacku, Discordzie czy Facebooku dawało generyczny podgląd bez tytułu, opisu ani obrazka. Brakowało meta tagów OG i Twitter Card.

Dodałem je w głównym layoucie (`app.blade.php`) z rozsądnymi domyślnymi wartościami:

```blade
<meta property="og:type" content="@yield('og_type', 'website')">
<meta property="og:title" content="@yield('og_title', 'Extended\Mind::Thesis()')">
<meta property="og:description" content="@yield('og_description', 'Blog techniczny...')">
<meta property="og:image" content="@yield('og_image', url('/images/og-cover.png'))">

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="@yield('og_title', 'Extended\Mind::Thesis()')">
```

Widok posta nadpisuje wartości dynamicznie:

```blade
@section('og_type', 'article')
@section('og_title', $post['title'])
@section('og_description', Str::limit(strip_tags(Str::markdown($post['content'])), 160))
@section('og_image', $post['cover_image'])
```

Domyślny obrazek `og-cover.png` (1200x630px) wyświetla się dla stron bez dedykowanego obrazka — strona główna, about, kontakt. Posty z cover image dostają swój obrazek.

Kluczowe: `twitter:card` ustawione na `summary_large_image` daje duży podgląd obrazka na Twitterze/X. `og:locale` zmienia się dynamicznie w zależności od aktywnego języka (`pl_PL` / `en_US`).

## Tłumaczenia strony collaboration

Strona `/collaboration` miała hardkodowane polskie teksty w szablonie. Przeniosłem je do plików tłumaczeń:

- `lang/pl/collaboration.php` — 20 kluczy
- `lang/en/collaboration.php` — 20 kluczy

Obejmuje to sekcje: nagłówek, co oferuję (dev, code review, consulting), jak wygląda proces współpracy (4 kroki) i CTA.

```blade
{{-- Przed --}}
<h2>Co oferuję</h2>
<p>Tworzenie aplikacji webowych w Laravel...</p>

{{-- Po --}}
<h2>{{ __('collaboration.offer_heading') }}</h2>
<p>{{ $service['desc'] }}</p>
```

## Wersje

- `frontend` → `v1.19.0` (tłumaczenia collaboration), `v1.20.0` (meta tagi OG/Twitter)
