---
title: "Formularz kontaktowy z powiadomieniami email"
date: 2026-04-07
category: "Dev Log"
tags: [Laravel, formularz, email, Mailable, Alpine.js, Filament, microservices, internal API]
locale: pl
---

Strona kontaktowa miała formularz, ale kliknięcie „Wyślij" nie robiło nic — brakowało backendu. Ten release dodaje pełny pipeline: walidacja, zapis do bazy, wysyłka maila i panel administracyjny do przeglądania zgłoszeń.

## Formularz i walidacja

Formularz na `/contact` wysyła dane AJAX-em (Alpine.js `fetch`). `ContactController` waliduje pola:

```php
$validator = Validator::make($request->all(), [
    'name'    => ['required', 'string', 'max:100'],
    'email'   => ['required', 'email', 'max:150'],
    'phone'   => ['nullable', 'string', 'max:20'],
    'subject' => ['required', 'string', 'max:200'],
    'message' => ['required', 'string', 'min:10', 'max:5000'],
]);
```

Walidacja zwraca JSON z błędami per-pole — Alpine.js wyświetla je pod odpowiednimi inputami bez przeładowania strony. Na sukces pojawia się zielony komunikat potwierdzenia.

## Akcja SubmitForm

Zamiast tłustego kontrolera wyciągnąłem logikę do reużywalnej akcji `SubmitForm`. Przyjmuje typ formularza, dane i obiekt Mailable:

```php
class SubmitForm
{
    public function handle(string $formType, array $data, Mailable $mailable): void
    {
        $submission = FormSubmission::create([
            'form_type' => $formType,
            'url'       => request()->url(),
            'payload'   => $data,
            'sent_at'   => null,
        ]);

        Mail::to(config('mail.contact_to'))->send($mailable);

        $submission->update(['sent_at' => now()]);
    }
}
```

Dlaczego akcja a nie serwis? Logika jest jednorazowa i liniowa — nie ma stanu ani zależności. Gdyby w przyszłości pojawił się formularz newslettera lub formularz współpracy, ten sam `SubmitForm` obsłuży go z innym `Mailable`.

Pole `sent_at` ustawiane jest dopiero po wysyłce — jeśli mail nie dojdzie (SMTP timeout), zgłoszenie jest w bazie ze `sent_at = null`, co pozwala na retry.

## Email notification

`ContactNotification` to standardowy Laravel Mailable renderowany jako Blade template. Mail trafia na skonfigurowany adres (`MAIL_CONTACT_TO` w `.env`).

Konfiguracja SMTP na produkcji wymagała dodania zmiennych mailowych do ConfigMap i Secret w Kubernetes, oraz aktualizacji deployment.yaml z nowym obrazem.

## Internal API dla zgłoszeń

Żeby panel administracyjny (serwis `admin`) mógł przeglądać zgłoszenia, dodałem internal API w serwisie `frontend`:

- `GET /api/internal/form-submissions` — lista z paginacją, filtrowaniem po `form_type` i wyszukiwaniem
- `GET /api/internal/form-submissions/{id}` — szczegóły zgłoszenia
- `DELETE /api/internal/form-submissions/{id}` — usunięcie

Endpoints chronione są middleware `VerifyInternalApiKey` — ten sam wzorzec co w pozostałych serwisach.

## Panel administracyjny

W serwisie `admin` powstała nowa strona Filament `ManageFormSubmissions`. Pobiera dane z frontend service przez `FrontendApiService` i wyświetla tabelę z paginacją, wyszukiwaniem i filtrami. Kliknięcie wiersza rozwija szczegóły payload w modalu.

## Wersje

- `frontend` → `v1.21.0` (formularz kontaktowy, mail, internal API, model FormSubmission)
- `admin` → `v0.6.0` (strona zarządzania zgłoszeniami, FrontendApiService)
