---
title: "GitHub Actions CI/CD — tests, building images and pushing to GHCR"
date: 2026-02-25
category: "DevOps"
tags: [GitHub-Actions, CI-CD, Docker, GHCR, testing, automation]
locale: en
---

## Pipeline structure

The pipeline is split into two stages:

1. **CI** — runs on every PR and push to `master`; must pass before merging is allowed
2. **CD** — runs only on push to `master`; builds and publishes images

```yaml
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  test:
    # CI — always runs
  build-and-push:
    needs: test
    if: github.ref == 'refs/heads/master'
    # CD — only on master after tests pass
```

## CI — running tests

Each PHP service has its own job. For the Blog service:

```yaml
test-blog:
  runs-on: ubuntu-latest
  services:
    mysql:
      image: mysql:8
      env:
        MYSQL_DATABASE: blog_test
        MYSQL_ROOT_PASSWORD: secret
      options: --health-cmd="mysqladmin ping" --health-interval=10s

  steps:
    - uses: actions/checkout@v4
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: "8.5"
        extensions: pdo_mysql, mbstring, redis
    - name: Install dependencies
      run: composer install --no-interaction
      working-directory: blog/src
    - name: Run tests
      run: php artisan test --parallel
      working-directory: blog/src
      env:
        DB_DATABASE: blog_test
        DB_USERNAME: root
        DB_PASSWORD: secret
```

## CD — building and pushing to GHCR

```yaml
build-and-push:
  strategy:
    matrix:
      service: [frontend, blog, users, sso, admin, analytics]

  steps:
    - name: Login to GHCR
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: ./${{ matrix.service }}
        file: ./${{ matrix.service }}/Dockerfile
        push: true
        tags: |
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:${{ github.sha }}
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:latest
        platforms: linux/amd64,linux/arm64
```

## Docker layer caching

Without caching, every build pulls `composer install` from scratch (~2 min). With cache:

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

GitHub Actions Cache stores Docker layers. On the next build, if `composer.lock` hasn't changed, the vendor layer is pulled from cache. Build time drops from ~8 minutes to ~2 minutes.

## Pipeline execution time

Thanks to `matrix` and parallelization, 6 services build simultaneously. Total CI+CD time: **~6 minutes** from push to published images.
