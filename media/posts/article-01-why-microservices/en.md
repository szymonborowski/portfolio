---
title: "Why microservices for a blog? Analyzing an architectural decision"
date: 2026-01-29
category: "Architektura"
tags: [microservices, Laravel, architecture, Docker, RabbitMQ]
locale: en
---

## Where did the idea come from?

When I started building my portfolio, I faced a classic choice: a Laravel monorepo that works from day one, or something more ambitious. I chose the latter — and I have mixed feelings about it, but in a positive sense.

The goal was not "the best architecture for a blog." The goal was **to create a platform that serves as a living demo of my skills**. The blog is just a pretext.

## What does the system consist of?

The system is made up of 6 services:

- **Frontend** — Laravel + Blade, serves pages to users
- **Blog** — Laravel API, manages posts, comments, categories, tags
- **Users** — Laravel API, manages users, RBAC
- **SSO** — OAuth2 server based on Laravel Passport
- **Admin** — admin panel based on FilamentPHP
- **Analytics** — collects post views and aggregates statistics

Each service has its own MySQL database, its own container, its own tests.

## Communication between services

Services communicate in two ways:

### HTTP (synchronous)
Frontend calls the Blog API and Users API directly over Docker's internal network. I use `X-Internal-Api-Key` as a simple authorization mechanism between services.

### RabbitMQ (asynchronous)
When a user views a post, Frontend publishes a `post.viewed` event to RabbitMQ. The Analytics consumer picks it up and writes it to the database. When a user updates their data in Users, a `user.updated` event is sent to Blog, which updates its local copy of the author.

```
Frontend ──HTTP──▶ Blog API
Frontend ──HTTP──▶ Users API
Frontend ──RabbitMQ──▶ Analytics
Users ──RabbitMQ──▶ Blog (author synchronization)
```

## Was it a good idea?

**Pros:**
- Each service can be deployed independently
- Natural separation of responsibilities
- Great material for learning Kubernetes, ArgoCD, CI/CD
- A demo you can show at a job interview

**Cons:**
- A lot of boilerplate upfront (the same scaffolding 6 times over)
- Debugging over the network is harder than in a monolith
- Infrastructure overhead (RabbitMQ, Traefik, separate databases)

If I were building a "real" product from scratch, I would probably choose a monolith. But this is not a "real" product — it is a platform for learning and demonstration. And as such, it does its job remarkably well.
