---
title: "Dark mode, anonimowe polubienia i nowe UI"
date: 2026-03-19
category: "Dev Update"
tags: [dark-mode, likes, ui, sso, analytics, frontend, kategorie]
locale: pl
---

Seria ulepszeń UX: ciemny motyw w SSO, polubienia postów i komentarzy bez wymogu logowania, kolorowe kategorie i odświeżone karty postów. Plus usunięcie slidera hero, który nikt nie lubił.

**Serwisy: Frontend, Blog, SSO, Analytics**

## Dark mode w SSO

**SSO** — mimo że to głównie serwer autoryzacji — ma swój interfejs: strona logowania, ekran zgody OAuth2. Dodałem przełącznik motywu z zapisem preferencji w cookie. System operacyjny jako domyślny motyw (`prefers-color-scheme`), ręczny przełącznik jako nadpisanie.

Implementacja przez Tailwind CSS z klasą `dark:` — minimalna zmiana w HTML, całość zarządzana przez jeden atrybut `data-theme` na `<html>`.

## Anonimowe polubienia — identyfikacja po IP

Polubienia działają bez konta. Identyfikacja przez hash IP + user agent:

```php
// Anonimowe polubienie — identyfikacja po IP
$identifier = hash('sha256', $request->ip() . $request->userAgent());
Like::firstOrCreate([
    'post_id'    => $postId,
    'identifier' => $identifier,
]);
```

Jeśli użytkownik jest zalogowany — `identifier` to jego ID użytkownika zamiast hasha. Dzięki temu zalogowany użytkownik nie może polubić posta wielokrotnie z różnych IP.

**Analytics** przechowuje polubienia z opcjonalnym przypisaniem do użytkownika. **Frontend** odpytuje Analytics o liczby polubień i wyświetla je przy każdym poście i komentarzu.

## Kolorowe kategorie

Każda kategoria ma teraz pole `color` (hex). W kartach postów i tagach kategoria wyświetlana jest jako kolorowa plakietka. Admin może ustawić kolor przy tworzeniu kategorii.

## Nowe karty postów

Redesign kart postów na stronie głównej i w listingach:
- Miniatura posta (opcjonalna, fallback na gradient z koloru kategorii)
- Liczba wyświetleń i polubień pod tytułem
- Kolorowa plakietka kategorii
- Avatar autora

## Usunięcie slidera hero

Slider na stronie głównej zniknął. Zajmował dużo miejsca, ładował się wolno i nikt w niego nie klikał. Zastąpiłem go statycznym banerem z tytułem bloga i linkiem do sekcji Start Here.
