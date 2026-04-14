---
title: "Przełącznik języka, nowe strony i newsletter"
date: 2026-03-20
category: "Dev Update"
tags: [i18n, pl, en, newsletter, kontakt, strony, blog, admin, laravel]
locale: pl
---

Duża iteracja przekrojowa — obsługa dwóch języków (PL/EN) w całym systemie, nowe strony statyczne we Frontendzie, newsletter i tile z commitami GitHub na stronie głównej.

**Serwisy: Frontend, Blog, Admin**

## Przełącznik języka PL/EN

Dodałem routing do zmiany locale z zapisem w sesji:

```php
// Przełącznik języka
Route::get('/locale/{locale}', function (string $locale) {
    abort_if(! in_array($locale, ['pl', 'en']), 404);
    session(['locale' => $locale]);
    return redirect()->back();
});
```

Middleware `SetLocale` odczytuje wartość z sesji przy każdym żądaniu i ustawia `App::setLocale()`. Wszystkie stringi w widokach przechodzą przez `__()` lub `@lang()`. Tłumaczenia w `lang/pl/` i `lang/en/`.

## Nowe strony we Frontend

### O mnie

Strona z opisem autora, linkami do CV (PL/EN jako osobne pliki PDF) i linkami do GitHub, LinkedIn. Treść tłumaczona — każda wersja językowa ma osobny plik tłumaczeń.

### Kontakt

Formularz kontaktowy z walidacją po stronie serwera. Wiadomości wysyłane przez SMTP OVH. Honeypot przeciw spamowi.

### Współpraca

Strona opisująca możliwości współpracy: freelance, konsultacje, code review. Prosta strona statyczna z tłumaczeniami.

## Tile z commitami GitHub

Na stronie głównej pojawił się widget z ostatnimi commitami do repo projektu. Frontend odpytuje GitHub API, cacheuje odpowiedź przez 10 minut w Redis i wyświetla listę ostatnich 5 commitów z linkami.

## Blog: pole `locale` i `version`

Posty w Blog dostały dwa nowe pola:
- `locale` — język posta (`pl` lub `en`)
- `version` — wersja posta powiązana z tym samym tematem w drugim języku

Pozwala to na linkowanie między wersjami językowymi tego samego posta: "Czytaj po angielsku / Read in Polish".

## Blog: subskrybent newslettera

Nowy model `Subscriber` w Blog z polami: `email`, `locale`, `confirmed_at`. Endpoint `POST /newsletter/subscribe` z weryfikacją emaila przez link potwierdzający (SMTP OVH).

## Admin: filtry językowe w Manage Posts

Strona Manage Posts w Filament dostała:
- Filtr po `locale` — pokaż tylko polskie / tylko angielskie posty
- Selektor `version` — przypisanie wersji językowej do posta
- Kolumna `locale` w tabeli listingu
