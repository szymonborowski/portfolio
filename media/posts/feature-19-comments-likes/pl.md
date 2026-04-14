---
title: "Komentarze, polubienia i testy"
date: 2026-03-30
category: "Dev Log"
tags: [Laravel, Alpine.js, Blade, komentarze, polubienia, testy, PHPUnit, Docker, microservices]
locale: pl
---

Ten release zamknął kilka otwartych tematów naraz: formularz komentarzy dla zalogowanych użytkowników, wyświetlanie prawdziwej nazwy autora, naprawa polubień dla postów i komentarzy oraz pokrycie nowych funkcji testami.

## Formularz komentarzy

Widok posta pokazywał listę komentarzy, ale nie dawał możliwości ich dodania z poziomu frontendu. Dodałem formularz widoczny wyłącznie dla użytkowników z rolą wyższą niż `guest`. Gościom wyświetla się zaproszenie do logowania.

```blade
@if(session('access_token') && $canComment)
    <form method="POST" action="{{ route('post.comments.store', $post['id']) }}"
          x-data="{ chars: {{ strlen(old('content', '')) }} }">
        @csrf
        <textarea name="content" maxlength="5000"
                  @input="chars = $el.value.length"
                  placeholder="{{ __('comments.content_placeholder') }}">{{ old('content') }}</textarea>

        <div :class="chars >= 5000 ? 'text-red-500' : chars >= 4500 ? 'text-amber-500' : 'text-gray-400'">
            <span x-text="chars"></span> / 5000
        </div>

        <button type="submit">{{ __('comments.add_comment') }}</button>
    </form>
@elseif(!session('access_token'))
    {{-- zaproszenie do logowania --}}
@endif
```

Licznik znaków Alpine.js zmienia kolor na bursztynowy przy 4500 i czerwony przy 5000. Limit YouTube to 10 000 znaków — zdecydowałem się na 5000 jako rozsądny środek.

Nowy `CommentController` w serwisie `frontend` obsługuje zapis: waliduje treść, wywołuje API bloga (`POST /api/v1/comments`), a następnie natychmiast zatwierdza komentarz (`PATCH /api/v1/comments/{id}/approve`). Komentarze publikują się bez kolejki moderacji.

## Prawdziwa nazwa autora

Komentarze wyświetlały „User #1" zamiast nazwy. Przyczyna: `CommentResource` w serwisie `blog` zwracał tylko pole `author_id` — sam integer.

Serwis `blog` ma tabelę `authors` zsynchronizowaną z SSO przez RabbitMQ. Dodałem relację w modelu:

```php
public function author(): BelongsTo
{
    return $this->belongsTo(Author::class, 'author_id', 'user_id');
}
```

Ten sam wzorzec co `Post` — `author_id` w tabeli komentarzy odpowiada `user_id` w tabeli autorów. `CommentController` ładuje relację, `CommentResource` ekspozuje ją warunkowo:

```php
'author' => $this->whenLoaded('author', fn() => [
    'name' => $this->author->name,
]),
```

Serwis `frontend` przekazuje `with=author` przy pobieraniu komentarzy do posta. Teraz widok pokazuje prawdziwe imię i nazwisko.

## Naprawa polubień

Polubienia nie działały ani dla postów, ani dla komentarzy. Diagnoza w dwóch etapach:

**Problem 1 — sesja.** Trzy miejsca w kodzie frontendu odczytywały `session('user_id')`, które zawsze zwracało `null`. `OAuthController` zapisuje dane użytkownika jako zagnieżdżoną tablicę: `session(['user' => ['id' => ...]])`. Prawidłowy odczyt to notacja kropkowa Laravel: `session('user.id')`.

**Problem 2 — baza danych analytics.** Logi Docker ujawniły `SQLSTATE[HY000] [1045] Access denied for user 'analytics'`. Kontener MySQL był zainicjalizowany z użytkownikiem `app`, ale plik `analytics/.env` na poziomie Docker Compose miał `DB_USERNAME=analytics`. Sekcja `environment:` w `docker-compose.yml` nadpisuje wartości z `src/.env` — zmiana pliku aplikacyjnego nie wystarczyła. Poprawka: ujednolicenie nazwy użytkownika na `app` w obu plikach env.

**Problem 3 — obsługa błędów.** Przed naprawą, gdy analytics był niedostępny, `toggleLike()` zwracał HTTP 200 z `{liked: false, count: 0}`. JavaScript widział `res.ok = true` i „resetował" stan przycisku. Zmieniłem `AnalyticsApiService::toggleLike()` na zwracanie `null` przy błędzie, a trasa `/likes/toggle` odpowiada teraz HTTP 503. Frontend cofa optymistyczną aktualizację zamiast błędnie zmieniać stan.

## Testy

Nowe funkcje dostały pokrycie testami:

**Serwis blog** — `CommentApiTest`:
- walidacja `max:5000` zwraca 422
- lista komentarzy zawiera `author.name` gdy rekord autora istnieje
- `author` jest `null` gdy brak rekordu w tabeli `authors`
- widok pojedynczego komentarza zawiera `author.name`

Przy okazji dodałem brakującą `AuthorFactory`.

**Serwis frontend** — `BlogApiServiceTest` i nowy `CommentControllerTest`:
- niezalogowany użytkownik → przekierowanie na `/oauth/login`
- rola `guest` → HTTP 403
- za krótka / za długa treść → błąd walidacji
- sukces → przekierowanie z flashem `comment_success`
- błąd API bloga → przekierowanie z komunikatem błędu
- `createComment` i `approveComment` w `BlogApiService` — sukces i niepowodzenie

## Skrypt dev.sh — podpolecenie `test`

Dodałem subkomendę `test` do `dev.sh`:

```bash
./dev.sh test                              # wszystkie serwisy
./dev.sh test -- blog frontend             # wybrane serwisy
./dev.sh test -- blog -- --filter Foo      # filtr artisan
```

Skrypt uruchamia `php artisan test` wewnątrz kontenera każdego serwisu, zbiera wyniki i na końcu zwraca exit code 1 z listą serwisów, które nie przeszły.

## Wersje

- `blog` → `v0.5.0` (nowy minor: relacja autora, nowe dane w API)
- `frontend` → `v1.15.0` (nowy minor: formularz komentarzy, naprawa polubień)
