---
title: "Complete Blog API, JWT authorization, and OAuth2"
date: 2026-01-27
category: "Feature Update"
tags: [blog, api, jwt, oauth2, laravel-passport, sso, frontend, tests]
locale: en
---

This step was one of the largest in the entire project. Blog API went from a skeleton to a complete set of endpoints with tests, SSO received a full OAuth2 implementation, and Frontend logged in a user for the first time. A lot happening at once — but all of it interconnected.

**Services: Blog, SSO, Frontend**

## Blog Service — complete API

The Blog API is made up of four modules:

**Post API** — full CRUD for posts. Endpoints for listing posts (with pagination, filtering by category and tag), fetching a single post, creating, editing, and deleting. Every write operation requires authorization.

**Category API** — categories with a parent-child hierarchy. This allows building category trees, giving flexibility in how content is organized.

**Tag API** — tags assigned to posts. Simple CRUD with name uniqueness validation.

**Comment API** — comments with moderation. After a comment is submitted it enters a "pending" state. A moderator (through the Admin panel) approves or rejects it. This prevents spam without requiring immediate manual review of every comment.

All four modules have tests — both unit and feature tests covering happy paths and error scenarios.

**JWT authorization with a custom guard** — the Blog API is stateless. Instead of sessions, each request carries a JWT in the `Authorization: Bearer` header. I wrote a custom Laravel guard that validates the token and establishes the user context without hitting the database on every request.

## SSO Service — OAuth2 implementation

Laravel Passport provides a solid implementation of the OAuth2 protocol. I configured the Authorization Code Grant flow — the same one used by "Login with Google." Frontend redirects to SSO with the request parameters, the user logs in, SSO returns an authorization code, and Frontend exchanges it for an access token and refresh token.

Passport handles token renewal automatically, which removes the need for Frontend to manage session lifetimes manually.

## Frontend Service — OAuth2 integration and homepage

Frontend implemented the OAuth2 client side: storing tokens, refreshing them, and handling logout. The homepage now displays a list of posts fetched from Blog API — the first inter-service connection visible to a user. Redis stores the session and tokens server-side, which is more secure than keeping them in the browser's localStorage.

## What I learned

Writing a custom JWT guard was straightforward in theory but required a precise understanding of how Laravel loads a guard through `Auth::guard()`. OAuth2 with Passport is well-documented, but you need to understand the difference between grant types — early on I was briefly tempted to use the simpler Client Credentials grant, which is not appropriate for authorizing on behalf of a user.
