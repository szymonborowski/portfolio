---
title: "Project kickoff — the first four microservices"
date: 2026-01-26
category: "Feature Update"
tags: [kickoff, laravel, docker, microservices, blog, frontend, sso, users]
locale: en
---

Every project has a first day. This post describes what that looked like: standing up four initial services, configuring Docker, and defining what each service is responsible for.

**Services: Blog, Frontend, SSO, Users**

## Blog Service

Blog Service was the first to be created — it is the heart of the system. The setup is a standard Docker stack with PHP 8.5, Nginx as the web server, and MySQL as the database. At this stage the main goal was a development environment that would behave identically locally and in production. Laravel 12 as the framework, with a multi-stage Dockerfile planned for later. For now: it runs, it is containerized, it talks to a database.

## Frontend Service

Frontend is the main application users actually see. Similar Docker configuration — PHP 8.5, Nginx, Redis for session management. Laravel here runs as a traditional web application that renders server-side views rather than an API. This was a deliberate choice: I wanted the blog to work without a JavaScript-heavy SPA, with plain server-side rendering. Redis was included from the start because OAuth2 sessions need somewhere to live on the server side.

## SSO Service

SSO is the OAuth2 authorization server. This is where tokens are managed and the login flow is handled. At this stage: basic Docker and Laravel setup, ready for Laravel Passport installation in the next step. The service is meant to be the entry point for all identity-related operations.

## Users Service

Users is the registry of user accounts, roles, and permissions. As a separate service — instead of a `users` table in every database — it ensures user data has a single source of truth. At kickoff: basic setup identical to the other services, ready for further development.

## What comes next

Four services are up. Each has its own container, its own database, its own Nginx configuration. The next step is implementing Blog API from scratch, along with JWT authorization and the first OAuth2 integration between Frontend and SSO.
