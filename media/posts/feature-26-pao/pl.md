---
title: "nunomaduro/pao — gdy testy rozmawiają z agentem"
date: 2026-04-11
category: "Dev Log"
tags: [PHP, PHPUnit, Pest, testowanie, AI, agent, nunomaduro, pao, Laravel, developer-experience]
locale: pl
author: aina@borowski.services
---

Budowanie funkcji chatu oznaczało pisanie testów — dużo testów. Unit testy dla `ChatService`, feature testy dla `ChatController`, integration-style testy konwersacji ćwiczące pełną maszynę stanów. Uruchamianie tych testów w ciasnej pętli podczas iterowania nad implementacją ujawnia cichy problem: wynik testów jest zaprojektowany dla ludzi czytających terminal, nie dla agentów czytających wyniki wywołań narzędzi.

`nunomaduro/pao` to rozwiązanie tego problemu. I reprezentuje coś szerszego, co warto nazwać.

Pakiet stworzył [Nuno Maduro](https://nunomaduro.com) — twórca Laravel Pint, Collision i Pest. Koncepcję przedstawił w prezentacji, którą warto obejrzeć: [Agent-Optimized PHP Tooling](https://www.youtube.com/watch?v=aOA1m9dFEww).

## Co robi pao

Opis pakietu jest precyzyjny: *„Agent-optimized output for PHP testing tools."*

PHPUnit i Pest produkują wynik przeznaczony do skanowania wzrokiem — kolorowe kropki, paski postępu, sformatowane ślady wyjątków. Gdy agent AI uruchamia `php artisan test` i czyta wynik, dostaje ten sam dump terminala. To jest w porządku dla prostych przypadków. Dla nieudanych testów z długimi śladami stosu, zagnieżdżonymi wyjątkami lub równoległym wynikiem testów stosunek sygnału do szumu spada.

Pao przechwytuje pipeline wyjściowy i reformatuje go w strukturę, którą agenci mogą niezawodnie parsować: czysty JSON gdy uruchamiany w kontekście agentycznym (wykrytym przez `shipfastlabs/agent-detector`), niezmodyfikowany czytelny dla człowieka wynik gdy nie. Przełącznik jest automatyczny — żadnych flag, żadnej konfiguracji.

```json
{
  "status": "failed",
  "tests": 42,
  "assertions": 187,
  "failures": [
    {
      "test": "Tests\\Unit\\ChatServiceTest::history_is_capped_at_max_pairs",
      "message": "Expected 20 messages, got 22.",
      "file": "tests/Unit/ChatServiceTest.php",
      "line": 94
    }
  ]
}
```

Agent dostaje dokładnie to, czego potrzebuje, żeby zlokalizować błąd i go zrozumieć. Żadnych kodów ANSI, żadnych pasków postępu, żadnych dekoracyjnych obramowań.

## Jak się integruje

Pao dostarcza Laravel `ServiceProvider` i plugin Pest, oba rejestrowane automatycznie przez extras w `composer.json`. Po `composer require --dev nunomaduro/pao` nie ma nic więcej do konfiguracji. Runner testów wykrywa kontekst wykonania i wybiera odpowiedni driver wyjściowy.

Oba serwisy — `frontend` i `blog` — otrzymały pakiet jako dev dependency. Wpływa tylko na uruchomienia testów — zero wpływu na produkcję, zero narzutu w czasie działania.

## Koncepcja pao

"Pao" to skrót od szerszej idei: **tooling zoptymalizowany pod agenta**.

Przemysł oprogramowania spędził dekady budując narzędzia dla ludzkich developerów — IDE z podświetlaniem składni, terminale z kolorowym wynikiem, dashboardy z wykresami. To wszystko jest słuszne i wartościowe. Ale gdy agent AI jest głównym konsumentem wyjścia narzędzia — uruchamia testy, czyta logi, parsuje wyniki buildu — formaty wyjściowe zorientowane na człowieka stają się tarciem.

Pao stosuje to myślenie do runnerów testów. Ten sam princyp dotyczy linterów (ustrukturyzowane błędy JSON zamiast kolorowych diffów), narzędzi buildujących (czytelne maszynowo podsumowania zamiast ASCII-art postępu), formaterów logów (ustrukturyzowane pola zamiast swobodnych stringów). Wzorzec jest taki: wykryj konsumenta, wyemituj odpowiedni format.

Ma to coraz większe znaczenie, gdy agenci AI stają się uczestnikami pętli developmentu, a nie jedynie okazjonalnymi pomocnikami. Agent, który pisze kod, uruchamia testy, czyta wyniki i iteruje — bez człowieka w pętli przy każdym cyklu — potrzebuje toolingu, który mówi jego językiem.

## Dlaczego ma znaczenie konkretnie dla tego projektu

Funkcja chatu była rozwijana z Claudem jako aktywnym współpracownikiem — sugerującym implementacje, uruchamiającym testy w celu ich weryfikacji, czytającym błędy i iterującym. Pao sprawiło, że ta pętla była szybsza i bardziej niezawodna. Zamiast parsować wynik terminala heurystycznie, agent otrzymywał ustrukturyzowane dane o błędach, na których mógł działać bezpośrednio.

To jest prawdziwy argument za pao: nie to, że jest technicznie sprytne, ale to, że zamyka lukę, która po cichu spowalnia współpracę człowiek-agent w projektach PHP.
