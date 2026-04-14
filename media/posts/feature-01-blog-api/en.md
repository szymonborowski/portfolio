---
title: "Blog API — posts, categories, tags, comments"
date: 2026-01-27
category: "Dev Update"
tags: [laravel, api, jwt, blog, tests, pagination]
locale: en
---

Time for the first real API. Blog Service got a full set of endpoints — from posts through categories and tags to comments with moderation. Everything protected by a custom JWT guard.

**Service: Blog**

## JWT Authorization

No sessions — stateless JWT. I wrote a custom guard that reads the token from the `Authorization: Bearer` header, verifies the signature, and injects the user into the request context. Blog Service has no user accounts of its own — the token comes from SSO.

Public routes are accessible without a token, mutations require authentication:

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

## Posts with pagination and filtering

The `GET /posts` endpoint supports pagination and slug-based filtering. Thanks to slug filtering, Frontend can fetch a single post without knowing its ID — a friendly URL is enough.

```
GET /posts?slug=my-post-about-laravel
GET /posts?page=2&per_page=10
```

The response always returns pagination metadata: `current_page`, `last_page`, `total`. Frontend knows when the results run out.

## Hierarchical categories

Categories support a tree structure — each category can have a parent. In the database it's a `parent_id` column with a self-referencing relation. The API returns categories flat or nested — depending on the `?nested=true` parameter.

## Tags

Tag CRUD is a simple API. Each post can have many tags (many-to-many relation). I added a bulk endpoint for assigning tags to a post in a single request instead of N separate calls.

## Comments with moderation

Comments have their own set of endpoints, including moderator routes. A moderator can approve, reject, or delete a comment. Moderator endpoints require a JWT token with the appropriate role — verified by the guard.

```
POST   /posts/{id}/comments
GET    /posts/{id}/comments
DELETE /comments/{id}           # moderator
PATCH  /comments/{id}/approve   # moderator
```

## Tests

Each module has feature tests — posts, categories, tags, comments. Tests cover success and error paths: missing fields, unauthorized access, non-existent resources. I run them against an isolated SQLite database to avoid touching dev MySQL.
