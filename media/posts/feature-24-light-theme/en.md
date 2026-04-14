---
title: "Softening the light theme"
date: 2026-04-08
category: "Dev Log"
tags: [Tailwind CSS, UI, UX, accessibility, contrast, WCAG, Blade, design]
locale: en
---

User feedback: the light theme has too much contrast and is uncomfortable to browse. The diagnosis confirmed the issue — pure white (`#ffffff`) card backgrounds and near-black text (`text-gray-900`) produced a contrast ratio of ~19.5:1. WCAG requires a minimum of 4.5:1. Technically accessible, but visually harsh and tiring for the eyes.

## The problem

The light theme palette relied on three values:
- Page background: `bg-gray-50` (`#f9fafb`)
- Cards: `bg-white` (`#ffffff`)
- Text: `text-gray-900` (`#111827`)

White cards on a near-white background = minimal surface differentiation. Black text on white = maximum contrast. The result: a clinical look that strained the eyes during longer reading sessions.

## The fix

Instead of CSS custom properties or a color system refactor, I went with direct Tailwind class replacements. The scale is manageable (~17 Blade files), and every change targets light mode only — all `dark:` classes remain untouched.

Mapping table:

| Element | Before | After |
|---------|--------|-------|
| Page background | `bg-gray-50` | `bg-gray-100` |
| Cards | `bg-white` | `bg-gray-50` |
| Header | `bg-white/80` | `bg-gray-50/80` |
| Primary text | `text-gray-900` | `text-gray-800` |
| Inner borders | `border-gray-100` | `border-gray-200` |
| Tags | `bg-gray-100` | `bg-gray-200/60` |
| Hero background | `#fefefe` | `#f3f4f6` |

The new text contrast of `text-gray-800` on `bg-gray-50` = ~15:1. Still WCAG AAA, but subjectively much softer.

## Exceptions

Not everything moved from `bg-white` to `bg-gray-50`:
- **Form inputs** — kept `bg-white` to create an "inset" effect against the `bg-gray-50` card
- **Dropdown menus** — `bg-white` for an "elevated" feel (overlay element)
- **Newsletter CTA** — dark gradient section, untouched by this change

## Gradient fade in categories

The `category-grid` component has a gradient masking the bottom edge of the list:

```blade
<div class="bg-gradient-to-t from-white dark:from-gray-800 to-transparent"></div>
```

After changing the card to `bg-gray-50`, the `from-white` gradient created a visible boundary. Changing it to `from-gray-50` restored the smooth fade.

## Scope of changes

17 Blade files: layout, hero, 5 card components, 6 page views, pagination, sidebar and the like button. No CSS or Tailwind config changes — utility classes in templates only.

## Versions

- `frontend` → `v1.21.1` (patch: light theme contrast correction)
