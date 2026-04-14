---
title: "Autor na postach i ciemny motyw domyślnie"
date: 2026-03-24
category: "Dev Log"
tags: [API, frontend, admin, author, dark-mode, UI, Blade, Laravel]
locale: pl
---

Posty nie pokazywały kto je napisał. API zwracało `author_id`, ale bez rozwinięcia relacji — frontend nie miał danych autora. Przy okazji zmieniłem domyślny motyw na ciemny dla nowych odwiedzających.

## Autor w API

Blog API miał relację `author` na modelu `Post`, ale kontroler nie ładował jej eager loadingiem. Odpowiedź zawierała `author_id` jako liczbę — bezużyteczne dla frontendu.

Dodałem `->with('author')` do zapytań w `PostController`:

```php
$posts = Post::with(['categories', 'tags', 'translations', 'author'])
    ->where('status', 'published')
    ->latest('published_at')
    ->paginate($perPage);
```

`PostResource` już miał wpis `'author' => new AuthorResource($this->author)`, ale zwracał `null` bo relacja nie była załadowana. Po dodaniu eager loadingu autor pojawił się w odpowiedzi z `name` i `id`.

## Autor na froncie

Na stronie posta autor wyświetla się między kategoriami a datą:

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

Na karcie posta w listingach — imię autora pojawia się w stopce obok daty. Warunek `@if` zabezpiecza przed brakiem autora — starsze posty seedowane mogą nie mieć przypisanego autora.

## Autor w panelu admina

W Filament dodałem kolumnę autora do tabeli postów. Admin widzi kto napisał dany post bez wchodzenia w szczegóły. Kolumna pobiera dane z relacji `author.name` przez Blog API.

## Ciemny motyw domyślnie

Nowi odwiedzający widzieli jasny motyw — biały ekran, czarny tekst. Zmiana na ciemny wymagała kliknięcia przełącznika. Dla bloga technicznego, gdzie większość czytelników to programiści, ciemny motyw jest bardziej naturalnym wyborem.

Logika w layoucie sprawdza `localStorage` przed pierwszym renderem:

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

Trzy ścieżki:
- `theme === 'light'` → jasny motyw
- `theme === 'auto'` → zgodnie z preferencjami systemowymi
- brak wartości (nowy użytkownik) → **ciemny motyw**

Skrypt wykonuje się w `<head>` przed renderowaniem — eliminuje efekt „białego flashu" przy ładowaniu strony.

## Rezultat

Posty pokazują autora. Admin widzi autorów w tabeli. Nowi odwiedzający widzą ciemny motyw bez konieczności zmiany ustawień. Przełącznik nadal działa — wybór zapisuje się w `localStorage` i jest respektowany przy kolejnych wizytach.
