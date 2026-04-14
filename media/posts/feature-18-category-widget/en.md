---
title: "Category widget redesign — Alpine.js and gradient fadeout"
date: 2026-03-25
category: "Dev Log"
tags: [Alpine.js, UI, Blade, Tailwind, categories, frontend, UX]
locale: en
---

The category widget on the homepage took up too much space. With 22 categories, the grid stretched beyond the visible area and dominated the rest of the content. I redesigned it: smaller elements, constrained height with a gradient fadeout, and an expand/collapse button powered by Alpine.js.

## Smaller tiles

Previously, each category was a large block with a full name, post count, and generous margins. I shrunk them into compact elements in a 2-column grid:

```blade
<a href="{{ route('category.show', $category['slug']) }}"
   class="flex items-center justify-between px-3 py-2.5 rounded-lg {{ $colorClasses }} transition-all hover:opacity-80 hover:scale-[1.02]">
    <span class="text-sm font-medium truncate">{{ $category['name'] }}</span>
    <span class="text-xs opacity-70 ml-1 shrink-0">{{ $category['posts_count'] ?? 0 }}</span>
</a>
```

Each tile uses the category color as its background, with the name on the left and the post count on the right. `truncate` clips long names. `hover:scale-[1.02]` gives a subtle zoom effect on hover.

## Constrained height with gradient fadeout

The grid defaults to `max-h-[11rem]` — roughly 4 rows (8 categories). The rest is hidden. A gradient overlay sits at the bottom edge, fading from transparent to the background color:

```blade
<div x-show="!expanded"
     class="absolute bottom-0 left-0 right-0 h-12 bg-gradient-to-t from-white dark:from-gray-800 to-transparent pointer-events-none">
</div>
```

`from-white dark:from-gray-800` matches the gradient to the card background in both modes. `pointer-events-none` ensures the gradient does not block clicks on categories underneath.

## Alpine.js — expand / collapse

The expanded state is controlled by Alpine.js:

```blade
<div x-data="{ expanded: false }">
    <div class="grid grid-cols-2 gap-2 overflow-hidden transition-[max-height] duration-300 ease-in-out"
         :class="expanded ? 'max-h-[80rem]' : 'max-h-[11rem]'">
        {{-- categories --}}
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

Clicking the button toggles `expanded` between `true` and `false`. `transition-[max-height]` animates the height change. The gradient disappears when the widget is expanded (`x-show="!expanded"`). The button text switches between "More" and "Less". The arrow rotates 90 degrees on expand.

## Fix: missing "Start Here" category

While working on this, I fixed a missing category bug. The API returned 15 categories per page by default. With 22 categories sorted alphabetically, "Start Here" landed at position 19 — beyond the first page.

```php
'per_page' => 100,
```

One parameter in `BlogApiService::getCategories()` fixed it. With 22 categories, pagination is not needed.

## Result

The category widget is compact and aligned with other widgets on the homepage. By default it shows 8 categories with a gradient fadeout. The "More" button expands the full list with a smooth animation. All 22 categories — including "Start Here" — are now accessible.
