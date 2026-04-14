---
title: "User panel, RBAC, and the admin panel"
date: 2026-01-31
category: "Feature Update"
tags: [frontend, users, admin, rbac, filamentphp, i18n, panel]
locale: en
---

This step focused on the user layer: what a logged-in user sees, what permissions they have, and how I — as the administrator — manage the system. Three services, each playing a different role in the same theme.

**Services: Frontend, Users, Admin**

## Frontend — user panel

After logging in through OAuth2, the user lands in a panel. The panel received a sidebar navigation, a header dropdown with account options, and the first i18n groundwork — the interface is now ready to support more than one language.

The sidebar handles navigation between panel sections, adjusting its visibility and position to the window width. The header dropdown shows account information and a logout option. This is not complex UI, but it needs to be consistent and reliable — it is the first thing a logged-in user sees.

## Users — RBAC system

Role-Based Access Control is the mechanism for defining who can do what in the system. Users received three basic roles: `admin`, `author`, and `user`. Permissions are assigned to roles and checked by other services when authorizing operations.

The implementation is based on a custom model rather than an off-the-shelf package — I wanted to understand what is actually happening, not just call `$user->can('edit-post')` without knowing what that checks. A `Role` and `Permission` model with a pivot table, and an API key endpoint for other services to verify permissions.

## Admin — admin panel with FilamentPHP

FilamentPHP is one of those packages that immediately does a lot. After configuration I had an admin panel with a ready layout, tables, forms, and navigation — without writing a single Blade template from scratch.

The first panel handles user management: a user list, account detail view and editing, and role assignment. Filament provides table components with sorting and filtering, forms with validation, and notifications — all visually consistent and functional from the first line of code.

## What I learned

RBAC is simple in theory but it is hard to choose the right level of permission granularity. Too fine-grained and you end up with a combinatorial explosion of options; too coarse and you lose meaningful control. I settled on a simple set of resource-oriented permissions (such as `posts.create`, `posts.delete`) and that turned out to be enough. FilamentPHP surprised me with the quality of its documentation and how little code you need to write to get a working panel.
