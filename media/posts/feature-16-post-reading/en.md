---
title: "Typography, sidebar & hero — readability first"
date: 2026-03-24
category: "Dev Log"
tags: [Tailwind, typography, Blade, components, UI, frontend, refactoring]
locale: en
---

Blog posts looked flat. Headings were the same size as body text, code blocks had no formatting, and lists blended into paragraphs. I added a typography plugin, extracted the sidebar into shared components, and replaced the hero background with a gradient.

## The content rendering problem

Post content is written in Markdown and converted via `Str::markdown()`. The output is plain HTML — `<h2>` headings, `<p>` paragraphs, `<pre><code>` blocks. Tailwind CSS resets all element styles by default, so an `<h2>` looks identical to a `<p>`. No margin, no font size difference.

## @tailwindcss/typography

The `@tailwindcss/typography` plugin adds a `prose` class that restores readable styles for Markdown-generated content:

```css
@import 'tailwindcss';
@plugin '@tailwindcss/typography';
```

In the post view, I just wrapped the content:

```blade
<div class="prose prose-gray dark:prose-invert max-w-none">
    {!! \Illuminate\Support\Str::markdown($post['content'] ?? '') !!}
</div>
```

`prose-gray` sets a neutral color palette. `dark:prose-invert` flips colors in dark mode. `max-w-none` disables the default max-width — the parent column handles the layout.

The effect was immediate: headings have a size hierarchy, paragraphs have spacing, code blocks got backgrounds and rounded corners, blockquotes have a left border, lists have indentation and markers.

## Shared sidebar

The sidebar with recent posts and categories was duplicated across three views: post page, category page, and tag page. Same loops, same styles, same `@forelse`. Any change required editing three files.

I extracted it into two Blade components:

```blade
<x-recent-posts-sidebar :recentPosts="$recentPosts" />
<x-category-grid :categories="$categories" />
```

The `recent-posts-sidebar` component renders a list of recent posts with colored category initials. `category-grid` displays a grid of categories with post counts. Both accept data via props — the view does not need to know where the data comes from.

Each of the three views shrunk by ~60 lines. Changing the sidebar appearance now means editing one file.

## Hero gradient

The homepage hero section had a static dark background. I replaced it with a gradient:

```blade
<section class="relative overflow-hidden bg-gradient-to-b from-slate-900 to-slate-950">
```

A background image sits behind the content — separate for light and dark modes — at low opacity (`opacity-25`). The slate gradient adds depth without competing with the text. A subtle grid overlay (`opacity-[0.03]`) adds texture.

## Result

The blog is readable. Markdown content has proper typography without manually styling each element. The sidebar is shared and consistent across all post listing pages. The hero looks modern in both color modes.
