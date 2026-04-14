---
title: "Dark mode, anonymous likes, and new UI components"
date: 2026-03-19
category: "Feature Update"
tags: [frontend, dark-mode, likes, ui, analytics, blog, admin, sso]
locale: en
---

Several UI improvements and one new feature — anonymous post and comment likes. Changes touch almost every service, because dark mode needs to be consistent across the entire system.

**Services: Frontend, Blog, SSO, Admin, Analytics**

## SSO — dark mode with a toggle

SSO, as the service that renders login and registration views, received a full dark mode implementation. A toggle in the top-right corner of forms remembers the user's preference (localStorage + a CSS class on `<html>`). By default it respects the operating system setting via `prefers-color-scheme`.

This matters because SSO deals with unauthenticated users — if they have dark mode enabled in their OS, they should get a dark mode login form.

## Frontend — anonymous "like" buttons

Posts and comments received like buttons accessible without logging in. Anonymity is based on IP address — one IP can like a given post once. This is not a perfect solution (proxies, shared IPs), but it is sufficient for a blog at this scale.

The button shows the current like count and changes appearance after being clicked. The "liked" state is stored client-side (localStorage) and server-side (Analytics).

## Frontend — new UI components and dark mode

The homepage and post listing received new post cards with category colors — each category has an assigned color that appears as an accent on the card. The post cards were redesigned: better information hierarchy, clearer call to action, improved responsiveness.

Dark mode on Frontend works consistently with SSO — the same toggle mechanism, the same CSS color tokens, smooth transitions between modes.

## Analytics — anonymous likes system

Analytics received a new module: `post_likes` and `comment_likes` tables with IP and resource identifier deduplication. An endpoint accepts a like event (via internal API or RabbitMQ), stores it with an IP fingerprint, and returns the current like count.

Separating the likes logic into Analytics (rather than Blog) is intentional — a like is an analytics event, not a change in the content model.

## Blog and Admin — hero slider removal

The hero slider on the homepage — which appeared in earlier versions — was removed and replaced by the "Start Here" widget. This is not just an aesthetic change: the slider required additional logic in Blog API and Admin to manage slides. With it gone the code is simpler and the page loads faster.
