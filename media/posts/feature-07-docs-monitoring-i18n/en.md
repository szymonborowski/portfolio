---
title: "API documentation, monitoring, and internationalization"
date: 2026-02-12
category: "Feature Update"
tags: [openapi, prometheus, loki, grafana, i18n, traefik, monitoring, documentation]
locale: en
---

A working system is not enough on its own. You also need to understand it — know how to use it (documentation), know what it is doing at any given moment (monitoring), and offer it in more than one language (i18n). This step added all three.

**Services: Blog, Users, SSO, Infra**

## Blog and Users — OpenAPI documentation

Both services received API documentation in OpenAPI 3.0 format. Every endpoint is described with a request schema, a response schema, possible error codes, and example data. The documentation is generated automatically from code annotations and hosted at a dedicated path routed through Traefik.

This means anyone who wants to integrate with Blog API or Users API has one place with an up-to-date specification — no need to read the source code.

## SSO — i18n translations for login views

SSO serves HTML — login, registration, and password reset forms. I added translations for Polish and English. Users see the interface in their own language, and the language switcher remembers the choice.

The login views are the first thing a new user sees. It is worth making sure they are in the right language.

## Infra — monitoring stack

I added four tools to the infrastructure:

**Prometheus** collects metrics from all Laravel services (through the `spatie/laravel-prometheus` package or custom `/metrics` endpoints). Metrics include response times, request counts, HTTP errors, and database connection status.

**Loki** is the log aggregator. Instead of logging into each pod and reading logs through `kubectl logs`, Loki collects all logs in one place and makes them searchable.

**Promtail** is the log-collecting agent — it runs on each cluster node, captures container logs, and ships them to Loki.

**Grafana** is the visualization layer. Dashboards display Prometheus metrics and Loki logs in a single interface. I set up basic dashboards: response time per service, 5xx errors over time, and RabbitMQ queue activity.

The entire monitoring stack is accessible only internally — through Traefik with authentication required, not exposed publicly.

## What I learned

Prometheus and Grafana are genuinely their own domain of knowledge. The PromQL query language is expressive but initially unintuitive. Loki is conceptually simpler, but it requires careful Promtail configuration to ensure logs have proper labels and are searchable. After the first working dashboard I understand why these tools are the standard — being able to filter logs from all services simultaneously by time range is invaluable when debugging.
