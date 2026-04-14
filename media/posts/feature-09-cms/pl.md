---
title: "Start Here widget i zarządzanie postami w panelu"
date: 2026-03-17
category: "Dev Update"
tags: [cms, filament, blog, frontend, admin, featured-posts]
locale: pl
---

Blog potrzebuje redakcji — nie tylko publikowania. W tej iteracji dodałem zarządzanie postami w panelu **Admin**, wyróżnione posty i sekcję **Start Here** na stronie głównej Frontendu.

**Serwisy: Admin, Blog, Frontend**

## Wewnętrzne API Blog dla CMS

Blog dostał nowy zestaw tras wewnętrznych dostępnych tylko dla Admina (klucz API):

```
GET  /internal/posts
POST /internal/posts
PUT  /internal/posts/{id}
GET  /internal/categories
GET  /internal/tags
```

Te trasy omijają JWT guard — nie są dla zalogowanych użytkowników, tylko dla serwisu Admin działającego jako klient.

## Tabela `featured_posts`

Nowa tabela w bazie Blog. Trzyma listę wyróżnionych postów z kolejnością wyświetlania. Relacja do `posts` przez `post_id`.

```sql
CREATE TABLE featured_posts (
    id         BIGINT PRIMARY KEY AUTO_INCREMENT,
    post_id    BIGINT NOT NULL,
    position   INT    NOT NULL DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id)
);
```

Admin może zmienić kolejność wyróżnionych postów przez drag-and-drop w Filament.

## Admin — strona Manage Posts

Nowa strona w **FilamentPHP** z listą wszystkich postów z Blog API. Kolumny: tytuł, autor, kategoria, status, data. Filtry: status, kategoria, autor. Akcje: edycja, usunięcie, zmiana statusu.

Tworzenie i edycja posta otwiera formularz z polami: tytuł, slug, treść (Markdown), kategoria, tagi, status (draft/published).

## Admin — strona Start Here

Osobna strona Filament do zarządzania listą "Start Here". Drag-and-drop do zmiany kolejności. Możliwość dodania posta z wyszukiwarki (autokompletowanie po tytule).

## Frontend — sekcja Start Here

Na stronie głównej Frontendu pojawia się sekcja z listą postów "Start Here". Frontend pobiera ją z Blog przez endpoint `/internal/featured-posts` — ta trasa jest wewnętrzna, nie wymaga JWT, ale jest dostępna tylko wewnątrz sieci Dockera/K8s.

Sekcja wyświetla karty postów: tytuł, miniatura, krótki opis, link do posta.
