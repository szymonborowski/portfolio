---
title: "Dark mode, anonimowe polubienia i nowe komponenty UI"
date: 2026-03-19
category: "Feature Update"
tags: [frontend, dark-mode, likes, ui, analytics, blog, admin, sso]
locale: pl
---

Kilka usprawnień UI i jedna nowa funkcjonalność — anonimowe polubienia postów i komentarzy. Zmiany dotyczą prawie wszystkich serwisów, bo dark mode to coś, co musi być spójne w całym systemie.

**Serwisy: Frontend, Blog, SSO, Admin, Analytics**

## SSO — dark mode z przełącznikiem

SSO jako serwis obsługujący widoki logowania i rejestracji dostał pełną implementację dark mode. Przełącznik w prawym górnym rogu formularzy zapamiętuje preferencję użytkownika (localStorage + klasa CSS na `<html>`). Domyślnie respektuje ustawienie systemu operacyjnego przez `prefers-color-scheme`.

To ważne, bo SSO widzi niezalogowanych użytkowników — jeśli mają dark mode w systemie, powinni dostać dark mode na formularzu logowania.

## Frontend — anonimowe przyciski "like"

Posty i komentarze dostały przyciski polubień dostępne bez logowania. Anonimowość opiera się na IP — jeden adres IP może polubić dany post raz. To nie jest idealne rozwiązanie (proxy, shared IP), ale jest wystarczające dla bloga z ograniczoną skalą.

Przycisk pokazuje aktualną liczbę polubień i zmienia wygląd po kliknięciu. Stan "czy polubiony" jest przechowywany po stronie klienta (localStorage) i po stronie serwera (Analytics).

## Frontend — nowe komponenty UI i dark mode

Strona główna i lista postów dostały nowe karty postów z kolorami kategorii — każda kategoria ma przypisany kolor, który pojawia się jako akcent na karcie. Karty postów zostały przebudowane: lepsza hierarchia informacji, wyraźniejsze wywołanie do akcji, responsywność.

Dark mode na Frontendzie działa spójnie z SSO — ten sam mechanizm przełącznika, te same tokeny kolorów w CSS, płynne przejścia między trybami.

## Analytics — system anonimowych polubień

Analytics dostał nowy moduł: tabela `post_likes` i `comment_likes` z de-duplikacją po IP i identyfikatorze zasobu. Endpoint przyjmuje zdarzenie polubienia (przez wewnętrzne API lub RabbitMQ), zapisuje je z odciskiem IP i zwraca aktualną liczbę polubień.

Oddzielenie logiki polubień do serwisu Analytics (zamiast Blog) jest celowe — to zdarzenie analityczne, nie zmiana w modelu treści.

## Blog i Admin — usunięcie hero slidera

Hero slider na stronie głównej — który pojawił się we wcześniejszych wersjach — został usunięty i zastąpiony przez widget "Start Here". To nie tylko zmiana estetyczna: slider wymagał dodatkowej logiki w Blog API i Adminie do zarządzania slajdami. Po usunięciu kod jest prostszy, a strona ładuje się szybciej.
