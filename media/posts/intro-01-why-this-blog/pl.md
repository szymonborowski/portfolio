---
title: "Dlaczego stworzyłem ten blog?"
date: 2026-01-26
category: "Intro"
tags: [intro, magento, laravel, microservices, portfolio]
locale: pl
---

Przez ostatnie dziesięć lat pisałem PHP w świecie Magento. Magento 1.x, wersje od 1.6 do 1.9, potem półtora roku z Magento 2. Dobrze orientuję się w jego architekturze event-observer, systemie layoutów XML i tworzeniu customowych modułów. Wiem, gdzie szukać, gdy coś się psuje.

Jest tylko jeden problem: Magento to bardzo specyficzny ekosystem. Kiedy przychodzi na rozmowie kwalifikacyjnej pytanie "pokaż mi swój kod", pokazuję kod głęboko spleciony z frameworkiem, w projekcie, który wymaga całej infrastruktury sklepowej, żeby w ogóle miał sens. Trudno to ocenić z zewnątrz, trudno też pokazać, że znam coś więcej niż tylko "ten jeden framework".

Postanowiłem to zmienić.

## Czego chciałem się nauczyć

Lista była długa. Nowoczesny Laravel — pracowałem wcześniej z jego starszymi wersjami, ale ekosystem zmienił się znacznie. Microservices — idea podziału systemu na małe, niezależne serwisy była mi znana teoretycznie, ale nigdy nie budowałem czegoś takiego od zera. RabbitMQ — kolejki wiadomości, zdarzenia asynchroniczne, konsumenci. Kubernetes — zupełnie nowy temat, zaczynałem od absolutnego zera. Wszystko to rzeczy, o których słyszałem na konferencjach i w podcastach, ale których nie dotknąłem w codziennej pracy.

Mógłbym napisać prostą aplikację todolist. Mógłbym zrobić minimalny CRUD żeby "przejść przez materiał". Zdecydowałem inaczej: chciałem zbudować coś realnego. Coś, co będzie działać na produkcji, co ma prawdziwe problemy do rozwiązania, co można pokazać z dumą.

## Dlaczego blog?

Blog to forma, którą dobrze rozumiem — czyta się go jak użytkownik, widać wyraźnie co działa, a co nie. Jednocześnie jest wystarczająco złożony technicznie: musi mieć autoryzację, zarządzanie treścią, komentarze, analitykę, panel administracyjny. To naturalne pole do zastosowania wszystkich technologii, których chciałem się nauczyć.

Zamiast budować monolityczną aplikację Laravel, zbudowałem system sześciu mikroserwisów. Frontend obsługuje interfejs użytkownika i OAuth2. Osobny serwis SSO to serwer autoryzacji. Blog API odpowiada za posty, kategorie, tagi i komentarze. Users zarządza użytkownikami i uprawnieniami. Analytics śledzi wyświetlenia przez kolejkę RabbitMQ. Admin to panel dla mnie — oparty na FilamentPHP.

Każdy serwis to osobna aplikacja Laravel w osobnym kontenerze Docker. Wszystko spina Traefik jako reverse proxy i Kubernetes jako platforma orkiestracji.

## Podwójny cel

Ten blog ma dwa cele, które wzajemnie się wzmacniają. Po pierwsze, to platforma nauki — każda decyzja techniczna, każdy problem do rozwiązania, każda integracja to coś nowego, czego się uczę. Po drugie, to portfolio — możesz tutaj czytać o tym, co buduję, jak buduję i dlaczego podejmuję takie, a nie inne decyzje.

Nie piszę o tym, żeby wyglądać mądrze. Piszę, żeby mieć dokument tego, przez co przeszedłem — sukcesów, błędów i wszystkiego pomiędzy.

Zapraszam do lektury.
