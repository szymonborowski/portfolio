---
title: "Contact page, About me, language switcher, and newsletter"
date: 2026-03-20
category: "Feature Update"
tags: [frontend, blog, admin, sso, i18n, contact, newsletter, cv, github]
locale: en
---

This is the most recent set of changes — and probably the most visible to a visitor. An "About me" page, a contact form, a language switcher, a dynamic CV download, and a rebuilt homepage with a GitHub commits tile. Plus newsletter support and several Admin improvements.

**Services: Frontend, Blog, SSO, Admin**

## Frontend — "About me" and "Work with me" pages

The "About me" page, available in Polish and English, describes my experience, technical stack, and the context of this project. It is the first page a recruiter or potential employer should see — clear, technical, and free of unnecessary marketing language.

The "Work with me" page describes how I can help and how to reach me for freelance or project collaboration.

## Frontend — contact form (OVH SMTP)

The contact form sends emails through OVH SMTP. Laravel Mail with the SMTP driver, server-side validation, and spam protection via rate limiting per IP. Messages arrive directly in my inbox.

## Frontend — PL/EN language switcher

The language switcher is session-based rather than URL-based. The user clicks a flag, the session stores the choice, and Middleware applies the corresponding locale to all views. There is no need to translate URLs — the same `/about` path serves content in the active language.

The blog fetches posts from the API with locale awareness — if the user has Polish selected, Blog API returns Polish versions of the content.

## Frontend — dynamic CV download

A CV download button appeared on the "About me" page. The PDF is generated dynamically on demand, so it is always up to date — I do not need to remember to update a static file every time something changes.

## Frontend — GitHub commits tile

The rebuilt homepage now includes a tile showing recent commits from the project repositories. Data is fetched from the GitHub API and cached in Redis (to stay within API rate limits). The tile shows developer activity in real time — a recruiter can see that the project is alive and actively developed.

## Blog — newsletter model and subscriber API

Blog received a `Newsletter` model with a subscriber table. The API handles newsletter sign-up (email validation, deduplication), email confirmation, and unsubscription. Newsletter subscribers will receive notifications about new posts.

Blog now handles locale in posts — each post can have a PL and EN version as separate records linked by a `locale` field and a shared slug. Frontend picks the appropriate version based on the active language.

## Admin — locale filter and category management

The admin panel received a locale filter on the post list (to see Polish and English versions separately), a full category management view (adding, editing, hierarchy), and a new "version" column in the posts table showing whether a post has a complete PL/EN pair.
