---
title: "Edytor Markdown i kolorowanie składni"
date: 2026-03-22
category: "Dev Log"
tags: [markdown, EasyMDE, highlight.js, admin, frontend, editor, Laravel]
locale: pl
---

Pisanie postów w czystym textarea to nic przyjemnego -- brak podglądu, brak formatowania, zero podpowiedzi. Dodałem EasyMDE jako edytor Markdown zarówno we Frontendzie, jak i w panelu Admin, a wyrenderowane posty dostały kolorowanie składni dzięki highlight.js.

**Serwisy: Frontend, Admin, Blog**

## EasyMDE we Frontend

Frontend ma formularz tworzenia i edycji postów dostępny dla zalogowanych autorów. Pole `content` było dotychczas zwykłym `<textarea>`. Zamieniłem je na instancję EasyMDE z paskiem narzędzi, podglądem na żywo i obsługą skrótów klawiszowych:

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

Autosave zapisuje szkic w `localStorage` co 5 sekund -- zabezpieczenie przed przypadkowym zamknięciem karty. Spellchecker wyłączony, bo posty zawierają dużo kodu i nazw technicznych.

## EasyMDE w panelu Admin (Filament)

W Filament domyślne pole Markdown to prosty edytor bez podglądu. Podmieniłem je na EasyMDE za pomocą niestandardowego komponentu Blade, który Filament ładuje jako Alpine.js widget:

```php
Textarea::make('content')
    ->label('Content (Markdown)')
    ->required()
    ->columnSpanFull()
    ->view('filament.forms.components.easymde-editor'),
```

Komponent Blade inicjalizuje EasyMDE na elemencie textarea i synchronizuje wartość z modelem Filament przez Alpine `$wire`. Dzięki temu edytor działa identycznie jak natywne pole Filament -- walidacja, zapis i podgląd formularza bez niespodzianek.

## Kolorowanie składni -- highlight.js

Posty są przechowywane jako surowy Markdown. Frontend renderuje je do HTML po stronie serwera. Bloki kodu (```` ``` ````) trafiają do przeglądarki jako `<pre><code>`, ale bez kolorowania wyglądają płasko. Dodałem highlight.js z automatyczną detekcją języka:

```js
import hljs from 'highlight.js';
import 'highlight.js/styles/github-dark.css';

document.querySelectorAll('pre code').forEach((block) => {
    hljs.highlightElement(block);
});
```

Wybrałem motyw **github-dark** -- pasuje do ciemnego trybu frontendu i dobrze wygląda przy jasnym tle po przełączeniu.

## Refaktor CategoryColor

Przy okazji uprościłem helper `CategoryColor`. Wcześniej mapował nazwy kategorii na klasy Tailwind przez rozbudowany switch. Teraz przyjmuje nazwę koloru bezpośrednio z pola `color` kategorii i zwraca odpowiednie klasy. Paleta rozrosła się o kilkanaście nowych kolorów Tailwind -- violet, fuchsia, rose, cyan, lime i inne.

## Podsumowanie

Edytor Markdown z podglądem na żywo to spory skok w komforcie pisania. Kolorowanie składni w opublikowanych postach sprawia, że fragmenty kodu są czytelne od razu, bez wklejania screenshotów. Obie zmiany dotknęły Frontendu i Admina, ale logika po stronie Blog API nie wymagała zmian -- Markdown jest przechowywany w tej samej kolumnie co wcześniej.
