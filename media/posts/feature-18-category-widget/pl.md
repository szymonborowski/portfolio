---
title: "Redesign kafelka kategorii — Alpine.js i gradient fadeout"
date: 2026-03-25
category: "Dev Log"
tags: [Alpine.js, UI, Blade, Tailwind, categories, frontend, UX]
locale: pl
---

Kafelek kategorii na stronie głównej zajmował za dużo miejsca. Przy 22 kategoriach siatka rozciągała się poza widoczny obszar i dominowała nad resztą treści. Przeprojektowałem go: mniejsze elementy, ograniczona wysokość z gradientem fadeout i przycisk rozwijania przez Alpine.js.

## Mniejsze kafelki

Wcześniej każda kategoria to był duży blok z pełną nazwą, licznikiem postów i marginesami. Zmniejszyłem je do kompaktowych elementów w siatce 2-kolumnowej:

```blade
<a href="{{ route('category.show', $category['slug']) }}"
   class="flex items-center justify-between px-3 py-2.5 rounded-lg {{ $colorClasses }} transition-all hover:opacity-80 hover:scale-[1.02]">
    <span class="text-sm font-medium truncate">{{ $category['name'] }}</span>
    <span class="text-xs opacity-70 ml-1 shrink-0">{{ $category['posts_count'] ?? 0 }}</span>
</a>
```

Każdy kafelek ma kolor kategorii jako tło, nazwę po lewej i licznik postów po prawej. `truncate` ucina długie nazwy. `hover:scale-[1.02]` daje subtelny efekt powiększenia przy najechaniu.

## Ograniczona wysokość z gradient fadeout

Siatka ma domyślnie `max-h-[11rem]` — mieści około 4 wierszy (8 kategorii). Reszta jest ukryta. Na dolnej krawędzi leży gradient przechodzący z przezroczystego do koloru tła:

```blade
<div x-show="!expanded"
     class="absolute bottom-0 left-0 right-0 h-12 bg-gradient-to-t from-white dark:from-gray-800 to-transparent pointer-events-none">
</div>
```

`from-white dark:from-gray-800` dopasowuje kolor gradientu do tła karty w obu trybach. `pointer-events-none` sprawia, że gradient nie blokuje kliknięć na kategorie pod spodem.

## Alpine.js — rozwiń / zwiń

Stan rozwinięcia kontroluje Alpine.js:

```blade
<div x-data="{ expanded: false }">
    <div class="grid grid-cols-2 gap-2 overflow-hidden transition-[max-height] duration-300 ease-in-out"
         :class="expanded ? 'max-h-[80rem]' : 'max-h-[11rem]'">
        {{-- kategorie --}}
    </div>

    <button @click="expanded = !expanded"
            class="mt-4 inline-flex items-center text-sm font-medium text-sky-700 dark:text-sky-400">
        <span x-text="expanded ? '{{ __('general.less') }}' : '{{ __('general.more') }}'"></span>
        <svg class="ml-1 w-4 h-4 transition-transform duration-300"
             :class="expanded ? 'rotate-90' : ''" ...>
        </svg>
    </button>
</div>
```

Kliknięcie przycisku przełącza `expanded` między `true` i `false`. `transition-[max-height]` animuje zmianę wysokości. Gradient znika gdy kafelek jest rozwinięty (`x-show="!expanded"`). Tekst przycisku zmienia się między „Więcej" a „Mniej". Strzałka obraca się o 90° przy rozwinięciu.

## Fix: brakująca kategoria "Start Here"

Przy okazji naprawiłem problem z brakującą kategorią. API domyślnie zwracało 15 kategorii na stronę. Przy 22 kategoriach posortowanych alfabetycznie, "Start Here" była na pozycji 19 — poza pierwszą stroną.

```php
'per_page' => 100,
```

Jeden parametr w `BlogApiService::getCategories()` naprawił problem. Przy 22 kategoriach paginacja nie jest potrzebna.

## Rezultat

Kafelek kategorii jest kompaktowy i wyrównany z innymi widgetami na stronie głównej. Domyślnie pokazuje 8 kategorii z gradientowym fadeoutem. Przycisk „Więcej" rozwija pełną listę z płynną animacją. Wszystkie 22 kategorie — w tym „Start Here" — są teraz dostępne.
