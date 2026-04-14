---
title: "Inter-service communication — RabbitMQ and internal networks"
date: 2026-01-28
category: "Feature Update"
tags: [rabbitmq, microservices, users, blog, sso, infra, internal-api, docker-network]
locale: en
---

Isolated services are only half the story. The real challenge starts when you need to make them talk to each other — securely, reliably, and without creating a spaghetti of mutual dependencies. This step introduced RabbitMQ as an event broker and an internal API secured with an API key.

**Services: Users, Blog, SSO, Infra**

## Users Service — publishing events

Users became the first service to publish events to RabbitMQ. When a user account changes state — registration, email address change, account deactivation — Users publishes a message to the appropriate queue. Other services can subscribe to these events and react asynchronously, without being tightly coupled to Users.

At the same time, Users gained an internal API for SSO: a dedicated set of endpoints accessible only through the internal network, secured with an API key rather than OAuth2 tokens. SSO can ask Users "does a user with this email address exist?" without exposing that question to the outside world.

## Blog Service — RabbitMQ consumer

Blog needs to know about user changes because it stores a local copy of author data (name, avatar) alongside posts. Instead of querying Users on every request, Blog listens to the queue from Users and updates its local copy when an event arrives.

This is the eventual consistency pattern — Blog might briefly hold stale data, but it will always catch up. In practice the delay is imperceptible.

## SSO Service — migrating auth to Users API

At this stage SSO underwent an important refactoring: it stopped managing its own user records and started relying on Users API as the source of truth. Login through Passport now verifies credentials via an internal request to Users rather than its own `users` table. An `/api/user` endpoint was also added, returning the currently authenticated user's data based on the token — a standard endpoint required by OAuth2 clients.

## Infra — internal network and secured RabbitMQ

Docker Compose received a dedicated internal network called `microservices`. Services that communicate with each other are attached to this network but do not expose ports outside the host. Traefik is the sole external entry point.

RabbitMQ was configured with authentication: a dedicated vhost for the project, a dedicated user with limited permissions, and the default `guest` account disabled on all interfaces other than localhost. The management UI is accessible through Traefik for my use only.

## What I learned

RabbitMQ turned out to be less intimidating than I expected. Laravel has a ready integration through `php-amqplib/php-amqplib`, and the concepts of queues, exchanges, and bindings became clear after the first working example. The harder part was the design decision: where does the boundary lie between what goes through RabbitMQ (events) and what goes through the internal API (synchronous queries)? The rule I settled on: asynchronous when the receiver does not need to reply immediately; synchronous when the caller is waiting for a result.
