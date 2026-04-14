---
title: "Why I built this blog"
date: 2026-01-26
category: "Intro"
tags: [intro, magento, laravel, microservices, portfolio]
locale: en
---

For the past ten years I have been writing PHP inside the Magento world. Magento 1.x — versions 1.6 through 1.9 — then about a year and a half with Magento 2. I have a solid understanding of its event-observer architecture, the XML layout system, and custom module development. I know where to look when something breaks.

There is just one problem: Magento is a very specific ecosystem. When a job interview reaches the "show me your code" moment, what I can show is code deeply entangled with the framework, living inside a project that needs a full e-commerce infrastructure to make any sense at all. It is hard to evaluate from the outside, and even harder to demonstrate that my skills go beyond knowing one particular framework well.

I decided to change that.

## What I wanted to learn

The list was long. Modern Laravel — I had worked with older versions before, but the ecosystem has evolved significantly. Microservices — I understood the concept of splitting a system into small, independent services, but I had never actually built something like that from scratch. RabbitMQ — message queues, asynchronous events, consumers. Kubernetes — a completely new topic for me, starting from absolute zero. All things I had heard about at conferences and in podcasts but never touched in my day-to-day work.

I could have built a simple to-do app. I could have made a minimal CRUD project just to "go through the material." I decided differently: I wanted to build something real. Something that runs in production, that has genuine problems to solve, that I can show with pride.

## Why a blog?

A blog is a format I understand well — it reads like a real product, it is obvious what works and what does not. At the same time it is technically complex enough to be interesting: it needs authentication, content management, comments, analytics, an admin panel. It is a natural fit for every technology I wanted to learn.

Instead of a monolithic Laravel application, I built a system of six microservices. Frontend handles the user interface and OAuth2. A dedicated SSO service acts as the authorization server. Blog API manages posts, categories, tags, and comments. Users handles user management and permissions. Analytics tracks page views through a RabbitMQ queue. Admin is my own control panel, built on FilamentPHP.

Each service is a separate Laravel application running in its own Docker container. Traefik ties everything together as the reverse proxy, and Kubernetes is the orchestration platform.

## A dual purpose

This blog serves two goals that reinforce each other. First, it is a learning platform — every technical decision, every problem to solve, every integration is something new I am figuring out. Second, it is a portfolio — you can read here about what I am building, how I am building it, and why I am making the choices I make.

I am not writing to look clever. I am writing to have a record of what I went through — the successes, the mistakes, and everything in between.

Welcome.
