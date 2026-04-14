---
title: "CMS w panelu admina — zarządzanie treścią bloga"
date: 2026-03-17
category: "Feature Update"
tags: [admin, filamentphp, blog, cms, frontend, featured-posts]
locale: pl
---

Chciałem mieć wygodny sposób na pisanie i zarządzanie postami bez wchodzenia do bazy danych. Ten krok zamienił panel admina w pełnoprawny CMS i dodał do strony głównej widget "Start Here" — ręcznie wybrane posty, od których warto zacząć lekturę.

**Serwisy: Blog, Admin, Frontend**

## Blog — wewnętrzne API routes

Blog dostał nowy zestaw route'ów dostępnych wyłącznie przez wewnętrzną sieć, zabezpieczonych kluczem API. Admin komunikuje się z Blog przez te endpointy, żeby zarządzać treścią — bez wystawiania operacji modyfikujących publicznie.

Nowe endpointy obejmują pełny CRUD postów (z obsługą statusów: draft, published, scheduled), zarządzanie kategoriami i tagami oraz operacje na `featured_posts`. Tabela `featured_posts` przechowuje listę wybranych postów z kolejnością wyświetlania — to ona zasila widget "Start Here".

## Admin — strona "Manage Posts"

Panel admina dostał pełną stronę zarządzania postami zbudowaną w FilamentPHP. Tabela postów z sortowaniem, filtrowaniem po statusie i kategorii, wyszukiwaniem. Formularz edycji z edytorem Markdown (lub rich text), wyborem kategorii i tagów, ustawianiem statusu i daty publikacji.

Do panelu dodany został też widget "Start Here" — specjalny widok pozwalający mi wybrać posty, które pojawią się na stronie głównej jako rekomendowany punkt startowy dla nowych czytelników. Drag-and-drop do zmiany kolejności, możliwość włączenia i wyłączenia każdego wpisu.

## Frontend — widget "Start Here"

Na stronie głównej Frontendu pojawił się widget "Start Here" zastępujący poprzedni featured post. Widget pobiera listę oznaczonych postów z Blog API i wyświetla je w formie kart z tytułem, krótkim opisem i linkiem.

Koncepcja jest prosta: zamiast losowego lub najnowszego posta na górze, nowy czytelnik dostaje ręcznie dobraną ścieżkę przez projekt. Mogę wskazać: "zacznij od architektury, potem przejdź do feature-01, feature-02..."

## Czego się nauczyłem

FilamentPHP kolejny raz pokazał swoją moc — drag-and-drop reorder w panelu admina był kwestią kilku linii konfiguracji, nie implementacji od zera. Projektując wewnętrzne API dla Admina zdałem sobie sprawę, że granica "co jest w API, a co jest logiką Admina" wymaga starannego przemyślenia. Ostatecznie trzymam logikę blisko danych — Admin jest tylko klientem, który wywołuje API.
