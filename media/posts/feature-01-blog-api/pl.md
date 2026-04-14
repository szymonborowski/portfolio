---
title: "Blog API — posty, kategorie, tagi, komentarze"
date: 2026-01-27
category: "Dev Update"
tags: [laravel, api, jwt, blog, testy, paginacja]
locale: pl
---

Czas na pierwsze prawdziwe API. Blog Service dostał pełny zestaw endpointów — od postów przez kategorie i tagi po komentarze z moderacją. Całość chroniona przez własnego guarda JWT.

**Serwis: Blog**

## Autoryzacja JWT

Zamiast sesji — stateless JWT. Napisałem własnego guarda, który odczytuje token z nagłówka `Authorization: Bearer`, weryfikuje podpis i wstrzykuje użytkownika do kontekstu żądania. Serwis Blog nie ma własnych kont użytkowników — token pochodzi z SSO.

Trasy publiczne są dostępne bez tokenu, mutacje wymagają uwierzytelnienia:

```php
// routes/api.php
Route::get('/posts', [PostController::class, 'index']);
Route::get('/posts/{id}', [PostController::class, 'show']);
Route::middleware('auth:jwt')->group(function () {
    Route::post('/posts', [PostController::class, 'store']);
    Route::put('/posts/{id}', [PostController::class, 'update']);
    Route::delete('/posts/{id}', [PostController::class, 'destroy']);
});
```

## Posty z paginacją i filtrowaniem

Endpoint `GET /posts` obsługuje paginację i filtrowanie po slugu. Dzięki filtrowi po slugu Frontend może pobrać pojedynczy post bez znajomości jego ID — wystarczy przyjazny URL.

```
GET /posts?slug=moj-post-o-laravelu
GET /posts?page=2&per_page=10
```

Odpowiedź zawsze zwraca metadane paginacji: `current_page`, `last_page`, `total`. Frontend wie, kiedy skończyły się wyniki.

## Hierarchiczne kategorie

Kategorie obsługują strukturę drzewiastą — każda kategoria może mieć rodzica. W bazie danych to kolumna `parent_id` z relacją self-referencing. API zwraca kategorie spłaszczone lub zagnieżdżone — zależy od parametru `?nested=true`.

## Tagi

CRUD tagów to proste API. Każdy post może mieć wiele tagów (relacja many-to-many). Dodałem endpoint zbiorczy do przypisywania tagów do posta w jednym żądaniu zamiast N osobnych wywołań.

## Komentarze z moderacją

Komentarze mają własny zestaw endpointów, w tym trasy moderatorskie. Moderator może zatwierdzić, odrzucić lub usunąć komentarz. Endpointy moderatorskie wymagają tokenu JWT z odpowiednią rolą — weryfikowaną przez guarda.

```
POST   /posts/{id}/comments
GET    /posts/{id}/comments
DELETE /comments/{id}           # moderator
PATCH  /comments/{id}/approve   # moderator
```

## Testy

Każdy moduł ma testy feature — posty, kategorie, tagi, komentarze. Testy pokrywają ścieżki sukcesu i błędów: brakujące pola, nieautoryzowany dostęp, nieistniejące zasoby. Uruchamiam je w izolowanej bazie SQLite, żeby nie dotykać dev MySQL.
