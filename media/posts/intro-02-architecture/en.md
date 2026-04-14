---
title: "System architecture — a service overview"
date: 2026-01-27
category: "Intro"
tags: [intro, architecture, microservices, traefik, rabbitmq, docker]
locale: en
---

Before I start describing individual features, I want to give a complete picture of the system — who talks to whom, how data flows, and why each service sits where it does. Think of this post as a map to come back to while reading the rest of the series.

## Diagram

![System architecture diagram](/architecture.svg)

All external traffic enters through Traefik. It decides which service to route each request to, based on the hostname or URL path. The services themselves do not face the internet directly — they communicate with each other over Docker's internal network or Kubernetes cluster networking.

## Services

**Frontend** is the main web application. This is where a visitor arriving at borowski.services lands. Frontend renders the blog, handles the user panel, drives the OAuth2 flow (login via SSO), and stores sessions in Redis. It has no content database of its own — everything it displays comes from other services' APIs.

**SSO** is the OAuth2 authorization server, built on Laravel Passport. It handles login, registration, token issuance, and token refresh. When a user clicks "log in" on the Frontend, they are redirected here. After authentication they return to the Frontend with an authorization code, which is exchanged for an access token.

**Admin** is the administration panel built on FilamentPHP. I use it to manage blog content: writing posts, organizing categories, tags, and moderating comments. Admin is isolated from the public — access is for me only.

**Users** manages user accounts, roles, and permissions (RBAC). It is the single source of truth about who can do what in the system. It exposes an internal API for other services and publishes events to RabbitMQ whenever a user's state changes.

**Blog** is the blog API. It handles posts, hierarchical categories, tags, and comments with moderation. It synchronizes author data with Users via RabbitMQ and exposes a JSON API consumed by Frontend.

**Analytics** is a microservice built entirely around RabbitMQ consumers. It has no externally accessible API — it only listens for events (such as a post being viewed) and writes statistics to its own database. This architecture keeps view tracking asynchronous so it never slows down the main services.

**Infra** is not a single service but a collection of tools: Traefik as the reverse proxy, RabbitMQ as the message broker, and Prometheus + Loki + Grafana as the observability stack.

## How services communicate

I use three communication patterns. HTTP REST is the standard for external requests — the browser calls Frontend, which calls Blog API. Internal API with an API key is the mechanism for service-to-service calls where I do not want to expose endpoints publicly (for example, SSO querying Users for account data). RabbitMQ handles asynchronous events — when Users changes an account's status it publishes an event, and Blog and Analytics consume it independently.

## Why microservices?

The honest answer: mainly to learn. A system like this for a single person would fit comfortably inside a monolith. But the goal of this project is to gain hands-on experience with technologies that are standard in larger organizations. Splitting into services forced me to think about boundaries of responsibility, contracts between services, and what happens when one service is temporarily unavailable.

Learning by building.
