---
title: "Contact form with email notifications"
date: 2026-04-07
category: "Dev Log"
tags: [Laravel, form, email, Mailable, Alpine.js, Filament, microservices, internal API]
locale: en
---

The contact page had a form, but clicking "Send" did nothing — the backend was missing. This release adds the full pipeline: validation, database persistence, email dispatch and an admin panel for reviewing submissions.

## Form and validation

The form on `/contact` sends data via AJAX (Alpine.js `fetch`). `ContactController` validates the fields:

```php
$validator = Validator::make($request->all(), [
    'name'    => ['required', 'string', 'max:100'],
    'email'   => ['required', 'email', 'max:150'],
    'phone'   => ['nullable', 'string', 'max:20'],
    'subject' => ['required', 'string', 'max:200'],
    'message' => ['required', 'string', 'min:10', 'max:5000'],
]);
```

Validation returns JSON with per-field errors — Alpine.js displays them under the relevant inputs without a page reload. On success a green confirmation message appears.

## The SubmitForm action

Instead of a fat controller I extracted the logic into a reusable `SubmitForm` action. It takes a form type, data and a Mailable object:

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

Why an action and not a service? The logic is one-shot and linear — no state, no dependencies. If a newsletter or collaboration form appears in the future, the same `SubmitForm` handles it with a different `Mailable`.

The `sent_at` field is set only after dispatch — if the mail fails (SMTP timeout), the submission stays in the database with `sent_at = null`, allowing a retry.

## Email notification

`ContactNotification` is a standard Laravel Mailable rendered as a Blade template. The mail goes to the configured address (`MAIL_CONTACT_TO` in `.env`).

Production SMTP setup required adding mail variables to the ConfigMap and Secret in Kubernetes, plus updating deployment.yaml with the new image.

## Internal API for submissions

So the admin panel (`admin` service) can browse submissions, I added an internal API in the `frontend` service:

- `GET /api/internal/form-submissions` — paginated list with `form_type` filter and search
- `GET /api/internal/form-submissions/{id}` — submission details
- `DELETE /api/internal/form-submissions/{id}` — delete

Endpoints are protected by `VerifyInternalApiKey` middleware — the same pattern as in other services.

## Admin panel

A new Filament page `ManageFormSubmissions` was created in the `admin` service. It fetches data from the frontend service via `FrontendApiService` and displays a table with pagination, search and filters. Clicking a row expands the payload details in a modal.

## Versions

- `frontend` → `v1.21.0` (contact form, mail, internal API, FormSubmission model)
- `admin` → `v0.6.0` (form submissions management page, FrontendApiService)
