---
title: "Comments, likes and tests"
date: 2026-03-30
category: "Dev Log"
tags: [Laravel, Alpine.js, Blade, comments, likes, tests, PHPUnit, Docker, microservices]
locale: en
---

This release closed several open threads at once: a comment form for authenticated users, real author names in comments, a fix for broken likes on both posts and comments, and test coverage for all of the above.

## Comment form

The post view showed a list of comments but offered no way to add one from the frontend. I added a form visible only to users with a role above `guest`. Guests see a login prompt instead.

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
    {{-- login prompt --}}
@endif
```

The Alpine.js character counter turns amber at 4 500 and red at 5 000. YouTube's limit is 10 000 — I settled on 5 000 as a reasonable middle ground.

A new `CommentController` in the `frontend` service handles submission: it validates the content, calls the blog API (`POST /api/v1/comments`), then immediately approves the comment (`PATCH /api/v1/comments/{id}/approve`). Comments go live without a moderation queue.

## Real author names

Comments displayed "User #1" instead of a name. The cause: `CommentResource` in the `blog` service only returned the `author_id` integer field.

The `blog` service has an `authors` table kept in sync with SSO via RabbitMQ. I added the relation to the model:

```php
public function author(): BelongsTo
{
    return $this->belongsTo(Author::class, 'author_id', 'user_id');
}
```

Same pattern as `Post` — `author_id` in the comments table maps to `user_id` in the authors table. `CommentController` eager-loads the relation and `CommentResource` exposes it conditionally:

```php
'author' => $this->whenLoaded('author', fn() => [
    'name' => $this->author->name,
]),
```

The `frontend` service passes `with=author` when fetching a post's comments. The view now shows a real name.

## Fixing likes

Likes were broken for both posts and comments. The diagnosis came in two stages:

**Problem 1 — session.** Three places in the frontend read `session('user_id')`, which always returns `null`. `OAuthController` stores user data as a nested array: `session(['user' => ['id' => ...]])`. The correct read uses Laravel's dot-notation: `session('user.id')`.

**Problem 2 — analytics database.** Docker logs revealed `SQLSTATE[HY000] [1045] Access denied for user 'analytics'`. The MySQL volume was initialised with user `app`, but the `analytics/.env` at the Docker Compose level had `DB_USERNAME=analytics`. The `environment:` section in `docker-compose.yml` overrides values from `src/.env` — fixing only the application env file was not enough. The fix was unifying the username to `app` in both env files.

**Problem 3 — error handling.** Before the fix, when analytics was unavailable `toggleLike()` returned HTTP 200 with `{liked: false, count: 0}`. JavaScript saw `res.ok = true` and "reset" the button state. I changed `AnalyticsApiService::toggleLike()` to return `null` on failure, and the `/likes/toggle` route now responds with HTTP 503. The frontend rolls back the optimistic update instead of incorrectly flipping the button.

## Tests

New features got test coverage:

**blog service** — `CommentApiTest`:
- `max:5000` validation returns 422
- comment list includes `author.name` when an author record exists
- `author` is `null` when no record exists in the `authors` table
- single comment view includes `author.name`

I also added the missing `AuthorFactory`.

**frontend service** — `BlogApiServiceTest` and a new `CommentControllerTest`:
- unauthenticated user → redirect to `/oauth/login`
- `guest` role → HTTP 403
- content too short / too long → validation error
- success → redirect with `comment_success` flash
- blog API failure → redirect with error message
- `createComment` and `approveComment` in `BlogApiService` — success and failure cases

## dev.sh — test subcommand

I added a `test` subcommand to `dev.sh`:

```bash
./dev.sh test                              # all services
./dev.sh test -- blog frontend             # selected services
./dev.sh test -- blog -- --filter Foo      # artisan filter
```

The script runs `php artisan test` inside each service's container, collects results and exits with code 1 along with a list of failing services.

## Versions

- `blog` → `v0.5.0` (new minor: author relation, new data in API)
- `frontend` → `v1.15.0` (new minor: comment form, likes fix)
