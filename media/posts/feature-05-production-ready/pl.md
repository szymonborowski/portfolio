---
title: "Gotowość produkcyjna — Docker hardening, health checks i Kubernetes"
date: 2026-02-07
category: "Feature Update"
tags: [kubernetes, docker, production, health-checks, nginx, multi-stage, initcontainer, k8s]
locale: pl
---

Działające lokalnie serwisy to jedno. Gotowość na produkcję to zupełnie inna kategoria. Ten krok był poświęcony twardnieniu kontenerów, health checkom, graceful shutdown i pierwszym manifestom Kubernetes — we wszystkich serwisach naraz.

**Serwisy: wszystkie**

## Health checks — /health i /ready

Każdy serwis dostał dwa dedykowane endpointy. `/health` odpowiada `200 OK` jeżeli aplikacja w ogóle działa (podstawowy liveness check). `/ready` odpowiada `200 OK` tylko wtedy, gdy serwis jest gotowy przyjmować ruch — tzn. połączył się z bazą danych, Redis jest dostępny, kolejka działa. Kubernetes używa tych endpointów do podejmowania decyzji: czy restartować pod, czy kierować do niego ruch.

Bez health checków Kubernetes nie ma jak odróżnić pod, który się uruchamia, od poda, który się zawiesił.

## Production Dockerfiles — multi-stage build

Każdy serwis dostał produkcyjny Dockerfile z wieloetapowym budowaniem. Etap `builder` instaluje zależności Composera i buduje assety. Etap finalny kopiuje tylko to, co potrzebne — bez narzędzi deweloperskich, bez cache'u Composera, bez plików testowych. Wynikowy obraz jest lżejszy i bezpieczniejszy.

Do każdego kontenera PHP dodany jest Nginx jako sidecar — w jednym podzie Kubernetes działa zarówno PHP-FPM jak i Nginx, który obsługuje ruch HTTP i przekazuje żądania PHP do FPM przez socket.

## Graceful shutdown — preStop hook

Kubernetes może zakończyć pod w dowolnym momencie. Bez odpowiedniej obsługi prowadzi to do błędów 502 dla żądań w trakcie realizacji. Każdy serwis dostał `preStop` hook w manifeście Kubernetes — krótki `sleep` dający czas na zakończenie aktywnych żądań przed wysłaniem sygnału SIGTERM do procesu.

## Kubernetes manifests

Każdy serwis dostał zestaw manifestów K8s: `Deployment`, `Service`, `ConfigMap`, `Secret` (template), `Ingress` z konfiguracją Traefik. Namespace `portfolio` izoluje zasoby projektu od reszty klastra.

Automatyczne migracje bazy danych są realizowane przez `initContainer` — uruchamia się przed głównym kontenerem, wykonuje `php artisan migrate --force` i dopiero po jego sukcesie startuje aplikacja. Eliminuje to potrzebę ręcznego uruchamiania migracji po każdym deploymencie.

## Czego się nauczyłem

Kubernetes to zupełnie nowy świat. Zaczynałem od zera — nie wiedziałem co to `initContainer`, `preStop hook`, ani jak działa scheduling. Przeszedłem przez dokumentację, przez kilka tutoriali i przez sporo błędnych konfiguracji. Największy przełom to zrozumienie, że Kubernetes nie "odpala aplikacje" — zarządza stanem deklaratywnym. Opisujesz co chcesz mieć, a Kubernetes doprowadza klaster do tego stanu. To inne myślenie niż `docker run`.
