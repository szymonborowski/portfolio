---
title: "Author info on posts and dark mode by default"
date: 2026-03-24
category: "Dev Log"
tags: [API, frontend, admin, author, dark-mode, UI, Blade, Laravel]
locale: en
---

Posts did not show who wrote them. The API returned `author_id` as a number, but the author relation was never eager-loaded — the frontend had no author data. While I was at it, I switched the default theme to dark mode for new visitors.

## Author in the API

The Blog API had an `author` relation on the `Post` model, but the controller never loaded it. The response included `author_id` as an integer — useless for the frontend.

I added `->with('author')` to the queries in `PostController`:

```php
$posts = Post::with(['categories', 'tags', 'translations', 'author'])
    ->where('status', 'published')
    ->latest('published_at')
    ->paginate($perPage);
```

`PostResource` already had `'author' => new AuthorResource($this->author)`, but it returned `null` because the relation was not loaded. Adding eager loading made the author appear in the response with `name` and `id`.

## Author on the frontend

On the post page, the author displays between the categories and the date:

```blade
<div class="flex items-center text-sm text-gray-500 dark:text-gray-400 mb-4">
    @if($post['author']['name'] ?? null)
        <span>{{ $post['author']['name'] }}</span>
        <span class="mx-2">&middot;</span>
    @endif
    <time datetime="{{ $post['published_at'] }}">
        {{ \Carbon\Carbon::parse($post['published_at'])->format('d F Y') }}
    </time>
</div>
```

On post cards in listings, the author name appears in the footer next to the date. The `@if` guard handles posts without an author — older seeded posts may not have one assigned.

## Author in the admin panel

In Filament, I added an author column to the posts table. Admins can see who wrote a given post without drilling into the detail view. The column fetches data from the `author.name` relation via the Blog API.

## Dark mode by default

New visitors saw the light theme — white background, dark text. Switching to dark mode required clicking the toggle. For a tech blog where most readers are developers, dark mode is the more natural default.

The layout script checks `localStorage` before the first paint:

```javascript
(function(){
    var t = localStorage.getItem('theme');
    if (t === 'light' ? false : (t === 'auto'
        ? window.matchMedia('(prefers-color-scheme: dark)').matches
        : true)) {
        document.documentElement.classList.add('dark');
    }
})();
```

Three paths:
- `theme === 'light'` → light mode
- `theme === 'auto'` → follows system preferences
- no stored value (new visitor) → **dark mode**

The script runs in `<head>` before rendering — it eliminates the white flash on page load.

## Result

Posts show their author. Admins see authors in the table. New visitors get dark mode without touching any settings. The toggle still works — the choice is saved in `localStorage` and respected on subsequent visits.
