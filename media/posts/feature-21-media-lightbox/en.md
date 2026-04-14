---
title: "Media management, lightbox and editor picker"
date: 2026-04-05
category: "Dev Log"
tags: [Laravel, Intervention Image, WebP, CDN, Alpine.js, Blade, media, lightbox, microservices]
locale: en
---

Three related changes around images: a media management API with automatic variant generation, a lightbox for enlarging images in posts, and a picker for inserting images from the Markdown editor.

## Media API in the blog service

Until now, images in posts were linked manually as URLs. There was no central place to upload and manage files. The new media module in the `blog` service provides full CRUD through the internal API:

- `POST /api/internal/media` — upload with automatic processing
- `GET /api/internal/media` — paginated list
- `PATCH /api/internal/media/{id}` — update alt text
- `DELETE /api/internal/media/{id}` — delete file and variants
- `GET /api/v1/media` — public endpoint for authenticated users (for the media picker)

### Image variants

Every upload goes through Intervention Image v3 (GD driver). The service generates up to three WebP variants:

```php
private const VARIANTS = [
    'thumbnail' => 150,   // grid view thumbnail
    'medium'    => 768,   // post content
    'large'     => 1200,  // lightbox
];
```

A variant is only created when the original is wider than the target width — there is no point scaling a 100px image up to 768px. WebP conversion at quality 80 saves ~60-70% compared to PNG.

```php
$variant = clone $image;
$encoded = $variant
    ->scaleDown(width: $targetWidth)
    ->toWebp(quality: 80);

Storage::disk('public')->put($variantPath, (string) $encoded);
```

### CDN

Variants are served from a dedicated CDN subdomain. `MediaResource` builds variant URLs:

```php
'variant_urls' => $variants ? collect($variants)->mapWithKeys(
    fn ($path, $name) => [$name => $cdnUrl . '/storage/' . $path]
) : null,
```

Nginx on the blog service has CORS headers added for `/storage/media/` so the frontend can fetch images from a different domain.

## Image lightbox on the frontend

Clicking any image in post content opens it in a fullscreen overlay. The Alpine.js component listens for a custom `open-lightbox` event:

```blade
<div class="prose" @click="if ($event.target.tagName === 'IMG')
    $dispatch('open-lightbox', { src: $event.target.src, alt: $event.target.alt })">
    {!! Str::markdown($post['content']) !!}
</div>
```

The lightbox closes on backdrop click, X button or the Escape key. No extra dependencies — Alpine.js is already bundled with Livewire.

## Media picker in the editor

The user panel post editor got an "insert image" button in the toolbar. Clicking it opens a modal with a thumbnail grid fetched from the API (`GET /panel/media`). After selecting an image, Markdown is inserted:

```
![alt text](https://cdn.example.com/storage/media/2026/04/uuid_large.webp)
```

The picker automatically selects the `large` variant (1200px) — the best trade-off between quality and file size for blog content.

## Versions

- `blog` → `v0.7.1` (media CRUD, variants, CDN, 46 tests)
- `admin` → `v0.5.0` (media management page, editor picker)
- `frontend` → `v1.17.0` (lightbox), `v1.18.0` (media picker in panel)
