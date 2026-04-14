---
title: "Docker stabilization — vendor volumes, MySQL 8.0, and env unification"
date: 2026-03-22
category: "Dev Log"
tags: [Docker, docker-compose, MySQL, devops, configuration, vendor, environment]
locale: en
---

After weeks of building out the microservices, I hit a cluster of Docker issues that kept biting me on every fresh `docker compose up` -- disappearing vendor directories, MySQL authentication failures, and a mess of inconsistent database credentials. I spent a day fixing all of them across all six Laravel services.

## The vanishing vendor/ directory

This one was subtle. Each service's `docker-compose.yml` bind-mounts the `src/` directory for hot-reload during development. The Dockerfile runs `composer install` at build time, so vendor/ exists inside the image. But when the container starts, the bind mount overlays the entire `src/` with the host's version -- and on the host, `vendor/` is either empty or missing entirely. Result: Laravel boots, finds zero packages, and crashes immediately.

The fix is a **named volume** mounted at the vendor/ path inside the container. Named volumes take priority over bind mounts and preserve the contents from the image:

```yaml
services:
  app:
    volumes:
      - ./src:/var/www/html
      - vendor_data:/var/www/html/vendor

volumes:
  vendor_data:
```

On first start, Docker copies the vendor/ contents from the image into the named volume. Subsequent starts reuse the same volume. The bind mount on `src/` still works for live editing, but vendor/ is protected. When you run `composer require` inside the container, the changes persist in the volume across restarts.

## MySQL 8.4 breaks authentication

The second issue showed up as `Access denied` errors despite correct credentials. The root cause: `docker-compose.yml` specified `mysql:8`, which -- after a recent image pull -- resolved to MySQL 8.4. Version 8.4 changed the default authentication plugin from `mysql_native_password` to `caching_sha2_password`. Laravel's default PDO driver does not handle this plugin without extra configuration.

The straightforward fix -- **pin the image to mysql:8.0**:

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USERNAME}
      MYSQL_PASSWORD: ${DB_PASSWORD}
```

MySQL 8.0 defaults to `mysql_native_password`. When we are ready to migrate to a newer version, we will do it intentionally with proper plugin configuration rather than having it break silently on a pull.

## Unified database credentials

Every service had its own ad-hoc database username and password -- whatever I came up with when first creating each `.env`. Six services meant six different usernames, six passwords, and no easy way to tell which credentials belonged where when debugging connection issues.

I standardized on a simple pattern: **username equals service name**, shared dev password. For example, the blog service:

```env
DB_DATABASE=blog
DB_USERNAME=blog
DB_PASSWORD=secret_dev
```

Same pattern for sso, admin, users, analytics, and frontend. Each service still gets its own database and its own user, but the naming is predictable. Debugging becomes trivial -- if the blog service cannot connect, you know the credentials are `blog` / `secret_dev` without checking any file.

## bootstrap/cache in .gitignore

One last cleanup -- excluding `bootstrap/cache/` from version control. Laravel generates files in this directory (config cache, route cache, service manifest). Having them committed caused merge conflicts on almost every branch and added noise to diffs. Now `.gitignore` includes `bootstrap/cache/*` and each environment generates its own cache locally.

## Summary

Four changes rolled out to all six services: named volume for vendor/, MySQL pinned to 8.0, unified credentials, and a cleaned-up .gitignore. The dev environment now starts reliably without surprises.
