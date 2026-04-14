---
title: "Panel administracyjny FilamentPHP i system ról RBAC"
date: 2026-01-31
category: "Dev Update"
tags: [filament, admin, rbac, sso, oauth2, users, role]
locale: pl
---

System zarządzania potrzebuje panelu. Zamiast budować go od zera — **FilamentPHP**. Jednocześnie **Users** dostał pełny system ról i uprawnień, który jest punktem odniesienia dla wszystkich serwisów.

**Serwisy: Admin, Users**

## FilamentPHP jako panel admina

**FilamentPHP** to biblioteka dla Laravela, która generuje bogaty panel administracyjny z minimalną ilością kodu. Resources, tabele, formularze, filtry — wszystko deklaratywne. Wybrałem go, bo chciałem skupić się na logice biznesowej, a nie na budowaniu kolejnego CRUDa ręcznie.

Panel działa pod osobną domeną (`admin.portfolio.local` lokalnie), jako oddzielny serwis Dockera z własną bazą danych.

## Logowanie przez SSO, nie własny formularz

Admin nie ma własnego systemu logowania. Kliknięcie "Zaloguj się" przekierowuje do **SSO** — ten sam OAuth2 flow co Frontend. Po powrocie z tokenem Filament weryfikuje, czy użytkownik ma rolę `admin`, i wpuszcza do panelu.

> Dzięki temu jedno konto = dostęp do wszystkich serwisów. Zmiana hasła w jednym miejscu działa wszędzie.

Wymagało to napisania własnego providera uwierzytelniania dla Filament, który zamiast sprawdzać bazę lokalną, odpytuje SSO przez token.

## RBAC w Users Service

**Users** dostał model ról i uprawnień. Każdy użytkownik może mieć jedną lub więcej ról. Każda rola ma zestaw uprawnień. Role to np.: `admin`, `editor`, `moderator`, `user`.

Struktura w bazie danych:
- `roles` — lista ról
- `permissions` — lista uprawnień
- `role_permissions` — przypisanie uprawnień do ról
- `user_roles` — przypisanie ról do użytkowników

Token JWT emitowany przez SSO zawiera role użytkownika jako claim. Każdy serwis odczytuje role z tokenu bez odpytywania Users.

## Panel użytkownika we Frontend

Frontend dostał sidebar z menu dla zalogowanych użytkowników. Elementy menu zależą od roli — moderator widzi więcej opcji niż zwykły użytkownik. Widoki renderowane server-side na podstawie danych z sesji.
