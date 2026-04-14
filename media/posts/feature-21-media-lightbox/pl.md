---
title: "Media management, lightbox i picker w edytorze"
date: 2026-04-05
category: "Dev Log"
tags: [Laravel, Intervention Image, WebP, CDN, Alpine.js, Blade, media, lightbox, microservices]
locale: pl
---

Trzy powiązane zmiany wokół obrazków: API do zarządzania mediami z automatycznym generowaniem wariantów, lightbox do powiększania zdjęć w postach i picker do wstawiania obrazków z poziomu edytora Markdown.

## Media API w serwisie blog

Do tej pory obrazki w postach były linkowane ręcznie jako URL-e. Brakowało centralnego miejsca do uploadu i zarządzania plikami. Nowy moduł media w serwisie `blog` dostarcza pełne CRUD przez internal API:

- `POST /api/internal/media` — upload z automatycznym przetwarzaniem
- `GET /api/internal/media` — lista z paginacją
- `PATCH /api/internal/media/{id}` — aktualizacja alt textu
- `DELETE /api/internal/media/{id}` — usunięcie pliku i wariantów
- `GET /api/v1/media` — publiczny endpoint dla zalogowanych (do media pickera)

### Warianty obrazków

Każdy upload przechodzi przez Intervention Image v3 (driver GD). Serwis generuje do trzech wariantów w formacie WebP:

```php
private const VARIANTS = [
    'thumbnail' => 150,   // miniaturka do grid view
    'medium'    => 768,   // do treści posta
    'large'     => 1200,  // do lightboxa
];
```

Wariant powstaje tylko gdy oryginał jest szerszy niż docelowa szerokość — nie ma sensu skalować 100px obrazka do 768px. Konwersja do WebP z quality 80 daje ~60-70% oszczędności rozmiaru względem PNG.

```php
$variant = clone $image;
$encoded = $variant
    ->scaleDown(width: $targetWidth)
    ->toWebp(quality: 80);

Storage::disk('public')->put($variantPath, (string) $encoded);
```

### CDN

Warianty serwowane są z dedykowanej subdomeny CDN. `MediaResource` buduje URL-e wariantów:

```php
'variant_urls' => $variants ? collect($variants)->mapWithKeys(
    fn ($path, $name) => [$name => $cdnUrl . '/storage/' . $path]
) : null,
```

Nginx na serwisie blog ma dodane nagłówki CORS dla `/storage/media/`, żeby frontend mógł pobierać obrazki z innej domeny.

## Image lightbox na frontendzie

Kliknięcie dowolnego obrazka w treści posta otwiera go w fullscreenowym overlay. Komponent Alpine.js nasłuchuje na custom event `open-lightbox`:

```blade
<div class="prose" @click="if ($event.target.tagName === 'IMG')
    $dispatch('open-lightbox', { src: $event.target.src, alt: $event.target.alt })">
    {!! Str::markdown($post['content']) !!}
</div>
```

Lightbox zamyka się na kliknięcie tła, przycisk X lub klawisz Escape. Żadnych dodatkowych zależności — Alpine.js już jest bundlowany z Livewire.

## Media picker w edytorze

Panel użytkownika do tworzenia postów dostał przycisk „wstaw obrazek" w toolbarze. Kliknięcie otwiera modal z siatką miniaturek pobranych z API (`GET /panel/media`). Po wybraniu obrazka wstawiany jest Markdown:

```
![alt text](https://cdn.example.com/storage/media/2026/04/uuid_large.webp)
```

Picker automatycznie wybiera wariant `large` (1200px) — najlepszy kompromis między jakością a rozmiarem dla treści bloga.

## Wersje

- `blog` → `v0.7.1` (media CRUD, warianty, CDN, 46 testów)
- `admin` → `v0.5.0` (strona media management, picker w edytorze)
- `frontend` → `v1.17.0` (lightbox), `v1.18.0` (media picker w panelu)
