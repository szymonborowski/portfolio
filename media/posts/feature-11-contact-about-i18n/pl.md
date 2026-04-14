---
title: "Strona kontaktowa, O mnie, przełącznik języka i newsletter"
date: 2026-03-20
category: "Feature Update"
tags: [frontend, blog, admin, sso, i18n, kontakt, newsletter, cv, github]
locale: pl
---

To aktualnie najnowszy zestaw zmian — i chyba najbardziej widocznych dla odwiedzającego. Strona "O mnie", formularz kontaktowy, przełącznik języka, dynamiczne CV i przebudowana strona główna z kafetlem commitów GitHub. Plus obsługa newslettera i kilka ulepszeń po stronie Admina.

**Serwisy: Frontend, Blog, SSO, Admin**

## Frontend — strona "O mnie" i "Współpraca"

Strona "O mnie" dostępna w języku polskim i angielskim opisuje moje doświadczenie, stack technologiczny i kontekst tego projektu. To pierwsza strona, którą powinien zobaczyć rekruter albo potencjalny pracodawca — jasna, techniczna i bez zbędnego marketingowego języka.

Strona "Współpraca" opisuje, jak mogę pomóc i jak można się ze mną skontaktować w kontekście pracy freelance lub współpracy projektowej.

## Frontend — formularz kontaktowy (OVH SMTP)

Formularz kontaktowy wysyła wiadomości e-mail przez SMTP OVH. Laravel Mail z driverem SMTP, walidacja po stronie serwera, zabezpieczenie przed spamem (rate limiting per IP). Wiadomości trafiają bezpośrednio do mojej skrzynki pocztowej.

## Frontend — przełącznik języka PL/EN

Przełącznik języka oparty jest na sesji, a nie na URL. Użytkownik klika flagę, sesja zapamiętuje wybór, Middleware aplikuje odpowiedni locale do wszystkich widoków. Nie ma potrzeby tłumaczenia URL-i — ta sama ścieżka `/about` serwuje treść w aktywnym języku.

Blog pobiera posty z API z uwzględnieniem locale — jeśli użytkownik ma ustawiony język polski, Blog API zwraca polskie wersje treści.

## Frontend — dynamiczne CV do pobrania

Na stronie "O mnie" pojawił się przycisk pobierania CV. Plik PDF generowany jest dynamicznie na żądanie, dzięki czemu zawsze jest aktualny — nie muszę pamiętać o aktualizowaniu pliku statycznego przy każdej zmianie.

## Frontend — kafelek z commitami GitHub

Przebudowana strona główna zawiera teraz kafelek z ostatnimi commitami z repozytoriów projektu. Dane pobierane są z GitHub API i cachowane w Redis (żeby nie przekraczać limitu API). Kafelek pokazuje aktywność developerską w czasie rzeczywistym — rekruter widzi, że projekt jest żywy i aktywnie rozwijany.

## Blog — model newslettera i API subskrybentów

Blog dostał model `Newsletter` z tabelą subskrybentów. API obsługuje zapis na newsletter (walidacja e-mail, de-duplikacja), potwierdzenie przez e-mail i wypisanie. Subskrybenci newsletter będą dostawać powiadomienia o nowych postach.

Blog obsługuje teraz locale w postach — każdy post może mieć wersję PL i EN jako oddzielne rekordy powiązane przez pole `locale` i wspólny slug. Frontend wybiera odpowiednią wersję na podstawie aktywnego języka.

## Admin — filtr locale i zarządzanie kategoriami

Panel admina dostał filtr locale w liście postów (żeby widzieć oddzielnie polskie i angielskie wersje), zarządzanie kategoriami (dodawanie, edytowanie, hierarchia) oraz nową kolumnę "version" w tabeli postów pokazującą, czy post ma kompletną parę PL/EN.
