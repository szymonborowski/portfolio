---
title: "Markdown editor and syntax highlighting"
date: 2026-03-22
category: "Dev Log"
tags: [markdown, EasyMDE, highlight.js, admin, frontend, editor, Laravel]
locale: en
---

Writing blog posts in a plain textarea is not a great experience -- no preview, no toolbar, no formatting hints. I replaced the raw textarea with EasyMDE in both the Frontend and Admin panel, and added highlight.js so that published code blocks get proper syntax coloring.

**Services: Frontend, Admin, Blog**

## EasyMDE in the Frontend

The Frontend has a post creation and editing form available to logged-in authors. The `content` field was a bare `<textarea>`. I swapped it for an EasyMDE instance with a formatting toolbar, live side-by-side preview, and keyboard shortcuts:

```js
import EasyMDE from 'easymde';

const editor = new EasyMDE({
    element: document.getElementById('content'),
    spellChecker: false,
    autosave: {
        enabled: true,
        uniqueId: 'post-content',
        delay: 5000,
    },
    toolbar: [
        'bold', 'italic', 'heading', '|',
        'code', 'quote', 'unordered-list', 'ordered-list', '|',
        'link', 'image', '|',
        'preview', 'side-by-side', 'fullscreen',
    ],
});
```

The autosave option writes a draft to `localStorage` every 5 seconds -- a safety net against accidental tab closures. Spellchecker is off because posts are full of code identifiers and technical terms that trigger false positives.

## EasyMDE in the Admin panel (Filament)

Filament ships with a basic Markdown field, but it lacks a live preview and a proper toolbar. I replaced it with a custom Blade component that initializes EasyMDE on the underlying textarea and wires the value back to Filament through Alpine.js:

```php
Textarea::make('content')
    ->label('Content (Markdown)')
    ->required()
    ->columnSpanFull()
    ->view('filament.forms.components.easymde-editor'),
```

The Blade view boots EasyMDE on mount and syncs every keystroke with the Livewire model via `$wire`. This keeps Filament's validation, dirty-state tracking, and save flow intact -- the editor behaves exactly like a native Filament field.

## Syntax highlighting with highlight.js

Posts are stored as raw Markdown in the Blog database. The Frontend renders them to HTML server-side. Fenced code blocks end up as `<pre><code>` tags, but without highlighting they look flat and hard to scan. I added highlight.js with automatic language detection:

```js
import hljs from 'highlight.js';
import 'highlight.js/styles/github-dark.css';

document.querySelectorAll('pre code').forEach((block) => {
    hljs.highlightElement(block);
});
```

I picked the **github-dark** theme because it pairs well with the Frontend's dark mode and still looks clean when the user switches to a light theme.

## CategoryColor refactor

While working on the Frontend I simplified the `CategoryColor` helper. Previously it used a verbose switch statement to map category names to Tailwind classes. Now it accepts the color name directly from the category's `color` field and returns the matching utility classes. The palette grew with new Tailwind colors -- violet, fuchsia, rose, cyan, lime, and several more.

## Wrap-up

A proper Markdown editor with live preview makes writing posts noticeably more comfortable. Syntax highlighting on published posts means code snippets are readable at a glance instead of being monochrome walls of text. Both changes touched Frontend and Admin, but the Blog API itself needed no modifications -- Markdown is stored in the same column as before, rendering is purely a presentation concern.
