---
title: "Zmiękczenie jasnego motywu"
date: 2026-04-08
category: "Dev Log"
tags: [Tailwind CSS, UI, UX, dostępność, kontrast, WCAG, Blade, design]
locale: pl
---

Feedback od użytkownika: jasny motyw strony ma zbyt duży kontrast i jest niewygodny w przeglądaniu. Diagnoza potwierdziła problem — czysto biały (`#ffffff`) tekst na kartach i prawie czarny tekst (`text-gray-900`) dawały stosunek kontrastu ~19.5:1. WCAG wymaga minimum 4.5:1. Technicznie dostępne, ale wizualnie ostre i męczące dla oczu.

## Problem

Paleta jasnego motywu opierała się na trzech wartościach:
- Tło strony: `bg-gray-50` (`#f9fafb`)
- Karty: `bg-white` (`#ffffff`)
- Tekst: `text-gray-900` (`#111827`)

Biała karta na prawie białym tle = minimalne rozróżnienie powierzchni. Czarny tekst na białym = maksymalny kontrast. Efekt: strona wyglądała klinicznie i oślepiała przy dłuższym czytaniu.

## Rozwiązanie

Zamiast CSS custom properties czy refaktoru systemu kolorów, zdecydowałem się na bezpośrednią zamianę klas Tailwind. Skala zmian jest zarządzalna (~17 plików Blade), a każda zmiana dotyczy wyłącznie light mode — klasy `dark:` pozostały nietknięte.

Tabela mapowania:

| Element | Przed | Po |
|---------|-------|------|
| Tło strony | `bg-gray-50` | `bg-gray-100` |
| Karty | `bg-white` | `bg-gray-50` |
| Header | `bg-white/80` | `bg-gray-50/80` |
| Tekst główny | `text-gray-900` | `text-gray-800` |
| Wewnętrzne bordy | `border-gray-100` | `border-gray-200` |
| Tagi | `bg-gray-100` | `bg-gray-200/60` |
| Hero tło | `#fefefe` | `#f3f4f6` |

Nowy kontrast tekstu `text-gray-800` na `bg-gray-50` = ~15:1. Wciąż WCAG AAA, ale subiektywnie łagodniejszy.

## Wyjątki

Nie wszystko przeszło z `bg-white` na `bg-gray-50`:
- **Inputy formularzy** — zostały `bg-white`, żeby tworzyły efekt „wgłębienia" na tle karty `bg-gray-50`
- **Dropdown menu** — `bg-white` dla efektu „uniesienia" (element nakładkowy)
- **Newsletter CTA** — sekcja z ciemnym gradientem, nie dotknięta zmianą

## Gradient fade w kategoriach

Komponent `category-grid` ma gradient maskujący dolną krawędź listy:

```blade
<div class="bg-gradient-to-t from-white dark:from-gray-800 to-transparent"></div>
```

Po zmianie karty na `bg-gray-50`, gradient `from-white` tworzył widoczną granicę. Zmiana na `from-gray-50` przywróciła płynne zanikanie.

## Zakres zmian

17 plików Blade: layout, hero, 5 komponentów kart, 6 widoków stron, paginacja, sidebar i like button. Żadnych zmian w CSS ani konfiguracji Tailwind — wyłącznie klasy utility w szablonach.

## Wersje

- `frontend` → `v1.21.1` (patch: korekta kontrastu jasnego motywu)
