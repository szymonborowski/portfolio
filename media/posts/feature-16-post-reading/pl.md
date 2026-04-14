---
title: "Typografia, sidebar i hero — czytelność przede wszystkim"
date: 2026-03-24
category: "Dev Log"
tags: [Tailwind, typography, Blade, components, UI, frontend, refactoring]
locale: pl
---

Posty na blogu wyglądały płasko. Nagłówki nie różniły się rozmiarem od zwykłego tekstu, bloki kodu nie miały żadnego formatowania, a listy zlewały się z akapitami. Dodałem plugin typografii, wyciągnąłem sidebar do współdzielonych komponentów i wymieniłem tło hero na gradient.

## Problem z renderowaniem treści

Treść postów jest pisana w Markdownie i konwertowana przez `Str::markdown()`. Wynik to czysty HTML — nagłówki `<h2>`, akapity `<p>`, bloki `<pre><code>`. Tailwind CSS domyślnie resetuje style wszystkich elementów, więc `<h2>` wygląda identycznie jak `<p>`. Żaden margines, żaden rozmiar czcionki.

## @tailwindcss/typography

Plugin `@tailwindcss/typography` dodaje klasę `prose`, która przywraca czytelne style dla treści generowanej z Markdowna:

```css
@import 'tailwindcss';
@plugin '@tailwindcss/typography';
```

W widoku posta wystarczyło owinąć treść:

```blade
<div class="prose prose-gray dark:prose-invert max-w-none">
    {!! \Illuminate\Support\Str::markdown($post['content'] ?? '') !!}
</div>
```

`prose-gray` ustawia neutralną paletę kolorów. `dark:prose-invert` odwraca kolory w trybie ciemnym. `max-w-none` wyłącza domyślne ograniczenie szerokości — layout kontroluje kolumna nadrzędna.

Efekt natychmiastowy: nagłówki mają hierarchię rozmiarów, akapity mają odstępy, bloki kodu dostały tło i zaokrąglenia, cytaty mają lewą krawędź, listy mają wcięcia i markery.

## Współdzielony sidebar

Sidebar z ostatnimi postami i kategoriami powtarzał się w trzech widokach: strona posta, strona kategorii, strona tagu. Kod był zduplikowany — te same pętle, te same style, ten sam `@forelse`. Zmiany wymagały edycji trzech plików.

Wyciągnąłem go do dwóch komponentów Blade:

```blade
<x-recent-posts-sidebar :recentPosts="$recentPosts" />
<x-category-grid :categories="$categories" />
```

Komponent `recent-posts-sidebar` renderuje listę ostatnich postów z kolorowymi literami kategorii. `category-grid` wyświetla siatkę kategorii z licznikami postów. Oba przyjmują dane przez props — widok nie musi wiedzieć skąd pochodzą.

Trzy widoki skurczyły się o ~60 linii każdy. Zmiana wyglądu sidebara wymaga teraz edycji jednego pliku.

## Gradient hero

Sekcja hero na stronie głównej miała statyczne ciemne tło. Wymieniłem je na gradient:

```blade
<section class="relative overflow-hidden bg-gradient-to-b from-slate-900 to-slate-950">
```

W tle wyświetla się obraz — osobny dla trybu jasnego i ciemnego — z niską przezroczystością (`opacity-25`). Gradient slate daje głębię bez odwracania uwagi od tekstu. Na wierzchu leży subtelna siatka (`opacity-[0.03]`) dodająca teksturę.

## Rezultat

Blog jest czytelny. Treść Markdowna ma poprawną typografię bez ręcznego stylowania każdego elementu. Sidebar jest współdzielony i spójny na wszystkich stronach z listami postów. Hero wygląda nowocześnie w obu trybach kolorystycznych.
