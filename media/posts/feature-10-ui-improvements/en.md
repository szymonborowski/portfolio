---
title: "Dark mode, anonymous likes, and new UI"
date: 2026-03-19
category: "Dev Update"
tags: [dark-mode, likes, ui, sso, analytics, frontend, categories]
locale: en
---

A series of UX improvements: dark theme in SSO, post and comment likes without requiring login, colorful categories, and refreshed post cards. Plus the removal of the hero slider that nobody liked.

**Services: Frontend, Blog, SSO, Analytics**

## Dark mode in SSO

**SSO** — even though it's primarily an authorization server — has its own interface: the login page and OAuth2 consent screen. I added a theme toggle that saves the preference in a cookie. The operating system provides the default theme (`prefers-color-scheme`), and the manual toggle overrides it.

Implemented via Tailwind CSS `dark:` classes — minimal HTML change, the whole thing managed by a single `data-theme` attribute on `<html>`.

## Anonymous likes — IP-based identification

Likes work without an account. Identification is done via an IP + user agent hash:

```php
// Anonymous like — IP-based identification
$identifier = hash('sha256', $request->ip() . $request->userAgent());
Like::firstOrCreate([
    'post_id'    => $postId,
    'identifier' => $identifier,
]);
```

If the user is logged in — `identifier` is their user ID instead of the hash. This prevents a logged-in user from liking a post multiple times from different IPs.

**Analytics** stores likes with an optional user assignment. **Frontend** queries Analytics for like counts and displays them next to each post and comment.

## Colorful categories

Each category now has a `color` field (hex). In post cards and tags, the category is displayed as a colored badge. Admin can set the color when creating a category.

## New post cards

Redesigned post cards on the homepage and in listings:
- Post thumbnail (optional, with a fallback gradient using the category color)
- View and like counts below the title
- Colored category badge
- Author avatar

## Removing the hero slider

The homepage slider is gone. It took up a lot of space, loaded slowly, and nobody clicked it. I replaced it with a static banner showing the blog title and a link to the Start Here section.
