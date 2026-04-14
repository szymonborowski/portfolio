---
title: "Panel użytkownika, RBAC i panel administracyjny"
date: 2026-01-31
category: "Feature Update"
tags: [frontend, users, admin, rbac, filamentphp, i18n, panel]
locale: pl
---

Ten krok skupił się na warstwie użytkownika: co widzi zalogowany użytkownik, jakie ma uprawnienia i jak ja — jako administrator — zarządzam systemem. Trzy serwisy, każdy z inną rolą w tym samym temacie.

**Serwisy: Frontend, Users, Admin**

## Frontend — panel użytkownika

Po zalogowaniu przez OAuth2 użytkownik trafia do panelu. Panel dostał sidebar z nawigacją, dropdown menu w nagłówku z opcjami konta oraz pierwsze elementy i18n — interfejs jest gotowy na obsługę więcej niż jednego języka.

Sidebar odpowiada za nawigację między sekcjami panelu, a jego widoczność i pozycja dostosowują się do szerokości okna. Dropdown w nagłówku zawiera informacje o koncie i opcję wylogowania. To nie jest skomplikowane UI, ale musi być spójne i działać niezawodnie — to pierwsza rzecz, którą widzi zalogowany użytkownik.

## Users — system RBAC

Role-Based Access Control to mechanizm definiowania tego, kto może co robić w systemie. Users dostał trzy podstawowe role: `admin`, `author` i `user`. Do ról przypisane są uprawnienia (`permissions`), które są sprawdzane przez inne serwisy przy autoryzacji operacji.

Implementacja jest oparta na własnym modelu zamiast gotowej paczki — chciałem rozumieć co się dzieje, a nie tylko wołać `$user->can('edit-post')` bez wiedzy co to sprawdza. Model `Role` i `Permission` z tablą pośrednią, klucz API do sprawdzania uprawnień przez inne serwisy.

## Admin — panel administracyjny z FilamentPHP

FilamentPHP to jeden z tych pakietów, które robią od razu dużo. Po konfiguracji dostałem panel administracyjny z gotowym layoutem, tabelami, formularzami i nawigacją — bez pisania ani jednego Blade template od zera.

Pierwszy panel obsługuje zarządzanie użytkownikami: lista użytkowników, podgląd i edycja konta, przypisywanie ról. Filament dostarcza komponenty tabeli z sortowaniem i filtrowaniem, formularze z walidacją i powiadomienia — wszystko spójne wizualnie i funkcjonalne od pierwszej linii kodu.

## Czego się nauczyłem

RBAC jest prosty w teorii, ale trudno jest określić właściwy poziom granularności uprawnień. Zbyt szczegółowe uprawnienia tworzą kombinatoryczną eksplozję możliwości; zbyt ogólne przestają dawać kontrolę. Doszedłem do prostego zestawu uprawnień powiązanych z zasobami (np. `posts.create`, `posts.delete`) i okazało się to wystarczające. FilamentPHP zaskoczył mnie jakością dokumentacji i tym, jak mało kodu trzeba napisać, żeby dostać działający panel.
