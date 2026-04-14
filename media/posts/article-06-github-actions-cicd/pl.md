---
title: "GitHub Actions CI/CD — testy, budowanie obrazów i push do GHCR"
date: 2026-02-25
category: "DevOps"
tags: [GitHub-Actions, CI-CD, Docker, GHCR, testing, automation]
locale: pl
---

## Struktura pipeline

Pipeline podzielony jest na dwa etapy:

1. **CI** — uruchamia się na każdym PR i pushu do `master`; musi przejść żeby można było mergować
2. **CD** — uruchamia się tylko na pushu do `master`; buduje i publikuje obrazy

```yaml
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  test:
    # CI — uruchamia się zawsze
  build-and-push:
    needs: test
    if: github.ref == 'refs/heads/master'
    # CD — tylko na master po przejściu testów
```

## CI — uruchamianie testów

Każdy serwis PHP ma własny job. Dla Blog serwisu:

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

## CD — budowanie i push do GHCR

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

## Caching warstw Dockera

Bez cachowania każdy build ściąga `composer install` od nowa (~2 min). Z cache:

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

GitHub Actions Cache przechowuje warstwy Dockera. Przy kolejnym buildzie, jeśli `composer.lock` się nie zmienił, warstwa vendor jest wzięta z cache. Czas buildu spada z ~8 minut do ~2 minut.

## Czas wykonania pipeline

Dzięki `matrix` i parallelizacji, 6 serwisów buduje się jednocześnie. Łączny czas CI+CD: **~6 minut** od pusha do opublikowanych obrazów.
