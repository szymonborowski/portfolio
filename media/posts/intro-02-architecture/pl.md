---
title: "Architektura systemu — przegląd serwisów"
date: 2026-01-27
category: "Intro"
tags: [intro, architektura, microservices, traefik, rabbitmq, docker]
locale: pl
---

Zanim zacznę opisywać poszczególne funkcjonalności, chcę dać pełny obraz systemu — kto z kim rozmawia, jak przepływają dane i dlaczego poszczególne serwisy są tam, gdzie są. Ten post to mapa, do której można wracać czytając kolejne wpisy.

## Diagram

![Diagram architektury systemu](/architecture.svg)

Cały ruch zewnętrzny trafia do Traefika. On decyduje, do którego serwisu przekierować żądanie na podstawie hosta lub ścieżki URL. Serwisy nie widzą bezpośrednio internetu — rozmawiają ze sobą przez wewnętrzną sieć Dockera lub Kubernetes.

## Serwisy

**Frontend** to główna aplikacja webowa. Tutaj trafia użytkownik wchodzący na borowski.services. Frontend renderuje blog, obsługuje panel użytkownika, realizuje przepływ OAuth2 (logowanie przez SSO) i przechowuje sesje w Redis. Nie ma własnej bazy danych dla treści — wszystko pobiera z API innych serwisów.

**SSO** to serwer autoryzacji OAuth2, zbudowany na Laravel Passport. Obsługuje logowanie, rejestrację, wydawanie tokenów i ich odświeżanie. Kiedy użytkownik klika "zaloguj się" na Frontendzie, ląduje tutaj. Po uwierzytelnieniu wraca do Frontendu z kodem autoryzacyjnym, który jest wymieniany na token dostępu.

**Admin** to panel administracyjny oparty na FilamentPHP. Służy mi do zarządzania treścią bloga: pisania postów, zarządzania kategoriami, tagami i komentarzami. Admin jest odizolowany od reszty świata — dostęp tylko dla mnie.

**Users** zarządza kontami użytkowników, rolami i uprawnieniami (RBAC). To centralne źródło prawdy o tym, kto może co robić w systemie. Udostępnia wewnętrzne API dla innych serwisów i publikuje zdarzenia do RabbitMQ, gdy stan użytkownika się zmienia.

**Blog** to API bloga. Odpowiada za posty, kategorie z hierarchią, tagi i komentarze z moderacją. Komunikuje się z Users przez RabbitMQ, żeby synchronizować dane o autorach. Udostępnia JSON API konsumowane przez Frontend.

**Analytics** to mikroserwis oparty wyłącznie na konsumentach RabbitMQ. Nie ma własnego API dostępnego z zewnątrz — tylko nasłuchuje na zdarzenia (np. wyświetlenie posta) i zapisuje statystyki do swojej bazy danych. Taka architektura sprawia, że śledzenie wyświetleń jest asynchroniczne i nie spowalnia głównych serwisów.

**Infra** to nie jeden serwis, ale zestaw narzędzi: Traefik jako reverse proxy, RabbitMQ jako broker wiadomości, Prometheus + Loki + Grafana jako stos monitorowania.

## Komunikacja między serwisami

Używam trzech wzorców komunikacji. HTTP REST to standard dla żądań zewnętrznych — przeglądarka wywołuje Frontend, który wywołuje Blog API. Wewnętrzne API z kluczem API to mechanizm dla komunikacji serwis-do-serwisu, gdzie nie chcę wystawiać endpointów publicznie (np. SSO pytające Users o dane użytkownika). RabbitMQ obsługuje zdarzenia asynchroniczne — gdy Users zmieni status konta, publikuje zdarzenie, a Blog i Analytics konsumują je niezależnie.

## Dlaczego microservices?

Szczera odpowiedź: głównie po to, żeby się nauczyć. Taki system dla jednej osoby spokojnie mieściłby się w monolicie. Ale cel tego projektu to zdobycie praktycznego doświadczenia z technologiami, które są standardem w większych organizacjach. Separacja serwisów wymusiła na mnie myślenie o granicach odpowiedzialności, kontraktach między serwisami i tym, co się dzieje, gdy jeden serwis jest chwilowo niedostępny.

To nauka przez budowanie.
