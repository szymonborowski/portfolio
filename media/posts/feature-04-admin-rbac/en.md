---
title: "FilamentPHP admin panel and RBAC role system"
date: 2026-01-31
category: "Dev Update"
tags: [filament, admin, rbac, sso, oauth2, users, roles]
locale: en
---

A management system needs a panel. Instead of building one from scratch — **FilamentPHP**. At the same time, **Users** got a full role and permission system that serves as the reference point for all services.

**Services: Admin, Users**

## FilamentPHP as the admin panel

**FilamentPHP** is a Laravel library that generates a rich admin panel with minimal code. Resources, tables, forms, filters — all declarative. I chose it because I wanted to focus on business logic, not building yet another CRUD by hand.

The panel runs under a separate domain (`admin.portfolio.local` locally), as a separate Docker service with its own database.

## Login through SSO, not a custom form

Admin has no login system of its own. Clicking "Log in" redirects to **SSO** — the same OAuth2 flow as Frontend. After returning with a token, Filament checks whether the user has the `admin` role and lets them into the panel.

> This means one account = access to all services. Changing a password in one place works everywhere.

This required writing a custom authentication provider for Filament that, instead of checking a local database, queries SSO through the token.

## RBAC in Users Service

**Users** got a role and permission model. Each user can have one or more roles. Each role has a set of permissions. Roles include: `admin`, `editor`, `moderator`, `user`.

Database structure:
- `roles` — list of roles
- `permissions` — list of permissions
- `role_permissions` — permission-to-role assignments
- `user_roles` — role-to-user assignments

The JWT token issued by SSO contains the user's roles as a claim. Each service reads roles from the token without querying Users.

## User panel in Frontend

Frontend got a sidebar with a menu for logged-in users. Menu items depend on role — a moderator sees more options than a regular user. Views rendered server-side based on session data.
