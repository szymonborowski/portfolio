---
title: "Wdrożenie na OVH Managed Kubernetes"
date: 2026-03-16
category: "Feature Update"
tags: [kubernetes, ovh, kustomize, cert-manager, lets-encrypt, traefik, cicd, produkcja]
locale: pl
---

Przez kilka tygodni system działał lokalnie i w Docker Compose. Nadszedł czas, żeby trafił na prawdziwy klaster. Wdrożenie na OVH Managed Kubernetes wymagało kilku tygodni przygotowań: monorepo setup, Kustomize overlays, certyfikaty TLS i pipeline CI/CD.

**Serwisy: wszystkie (portfolio monorepo)**

## Portfolio monorepo setup

Zamiast zarządzać deploymentem każdego serwisu osobno, zbudowałem jedno repozytorium portfolio, które spinuje je wszystkie. Zawiera `docker-compose.prod.yml` dla środowiska produkcyjnego na Docker Compose (backup/alternatywa dla K8s), `install.sh` do automatycznego klonowania wszystkich serwisów i konfigurowania środowiska, oraz skrypty CI/CD do automatycznego deploymentu.

## Kustomize overlays

Każdy serwis ma teraz strukturę Kustomize z trzema overlayami:
- `base` — wspólna konfiguracja dla wszystkich środowisk
- `dev` — lokalna konfiguracja z development-specific ustawieniami
- `prod` — konfiguracja produkcyjna z limitami zasobów, replikami i production secrets

Kustomize pozwala na patch'owanie manifestów bez duplikacji kodu. Środowisko prod dziedziczy bazę i nadpisuje tylko to, co różni go od devu — adresy domen, liczba replik, resource limits.

## OVH Managed Kubernetes

Wybrałem OVH Managed Kubernetes jako platformę produkcyjną z kilku powodów: rozsądna cena dla małego klastra, pełna zgodność z Kubernetes API, dobra dokumentacja i data center w Europie (ważne z perspektywy RODO).

Klaster dostał namespace `portfolio`. Traefik zainstalowany przez Helm Chart jako IngressController obsługuje cały ruch zewnętrzny. Każdy serwis ma własny `Ingress` wskazujący na subdomenę `borowski.services`.

## TLS przez cert-manager i Let's Encrypt

cert-manager to kontroler Kubernetes zarządzający certyfikatami TLS. Skonfigurowałem `ClusterIssuer` używający protokołu ACME z Let's Encrypt. Każdy `Ingress` z odpowiednią adnotacją automatycznie dostaje certyfikat TLS — cert-manager sam go pobiera, odnawia i aktualizuje `Secret` w klastrze.

Dzięki temu wszystkie subdomeny `borowski.services` mają HTTPS bez żadnej ręcznej pracy przy certyfikatach.

## Czego się nauczyłem

Kubernetes na produkcji to zupełnie inny poziom niż lokalne ćwiczenia. Pierwsze wdrożenie zajęło mi znacznie więcej czasu niż zakładałem — głównie przez konfigurację sieci, certyfikatów i właściwe zrozumienie jak Traefik działa jako IngressController w K8s (w przeciwieństwie do standalone Docker Compose). Kustomize okazał się właściwym wyborem — alternatywa (kopiowanie manifestów dla każdego środowiska) szybko stałaby się niemożliwa do utrzymania.
