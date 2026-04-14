---
title: "Start Here widget and post management in the admin panel"
date: 2026-03-17
category: "Dev Update"
tags: [cms, filament, blog, frontend, admin, featured-posts]
locale: en
---

A blog needs editorial management — not just publishing. In this iteration I added post management in the **Admin** panel, featured posts, and a **Start Here** section on the Frontend homepage.

**Services: Admin, Blog, Frontend**

## Internal Blog API for CMS

Blog got a new set of internal routes accessible only to Admin (API key):

```
GET  /internal/posts
POST /internal/posts
PUT  /internal/posts/{id}
GET  /internal/categories
GET  /internal/tags
```

These routes bypass the JWT guard — they are not for logged-in users, only for the Admin service acting as a client.

## The `featured_posts` table

A new table in the Blog database. It holds the list of featured posts with their display order. Related to `posts` via `post_id`.

```sql
CREATE TABLE featured_posts (
    id         BIGINT PRIMARY KEY AUTO_INCREMENT,
    post_id    BIGINT NOT NULL,
    position   INT    NOT NULL DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id)
);
```

Admin can reorder featured posts via drag-and-drop in Filament.

## Admin — Manage Posts page

A new page in **FilamentPHP** with a list of all posts from the Blog API. Columns: title, author, category, status, date. Filters: status, category, author. Actions: edit, delete, change status.

Creating and editing a post opens a form with fields: title, slug, content (Markdown), category, tags, status (draft/published).

## Admin — Start Here page

A separate Filament page for managing the "Start Here" list. Drag-and-drop to reorder. Ability to add a post via a search widget (autocomplete by title).

## Frontend — Start Here section

The Frontend homepage now has a "Start Here" section. Frontend fetches it from Blog through the `/internal/featured-posts` endpoint — this route is internal, requires no JWT, but is only accessible within the Docker/K8s network.

The section displays post cards: title, thumbnail, short description, link to the post.
