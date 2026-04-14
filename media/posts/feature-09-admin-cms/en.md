---
title: "CMS in the admin panel — managing blog content"
date: 2026-03-17
category: "Feature Update"
tags: [admin, filamentphp, blog, cms, frontend, featured-posts]
locale: en
---

I wanted a convenient way to write and manage posts without going into the database. This step turned the admin panel into a proper CMS and added a "Start Here" widget to the homepage — manually curated posts that are a good starting point for new readers.

**Services: Blog, Admin, Frontend**

## Blog — internal API routes

Blog received a new set of routes accessible only through the internal network, secured with an API key. Admin communicates with Blog through these endpoints to manage content — without exposing write operations publicly.

The new endpoints cover full CRUD for posts (with status handling: draft, published, scheduled), category and tag management, and operations on `featured_posts`. The `featured_posts` table stores a list of selected posts with their display order — this feeds the "Start Here" widget.

## Admin — "Manage Posts" page

The admin panel received a full post management page built in FilamentPHP. A posts table with sorting, filtering by status and category, and full-text search. An edit form with a Markdown editor (or rich text), category and tag selection, status setting, and a publish date picker.

A "Start Here" widget was also added to the panel — a special view that lets me select which posts appear on the homepage as a recommended starting point for new readers. Drag-and-drop reordering, with the ability to enable or disable each entry.

## Frontend — "Start Here" widget

The "Start Here" widget appeared on the Frontend homepage, replacing the previous featured post. The widget fetches the list of curated posts from Blog API and displays them as cards with a title, short description, and link.

The concept is simple: instead of a random or latest post at the top, a new reader gets a hand-picked path through the project. I can point them to: "start with the architecture post, then move to feature-01, feature-02..."

## What I learned

FilamentPHP once again showed its power — drag-and-drop reordering in the admin panel was a matter of a few lines of configuration, not an implementation from scratch. While designing the internal API for Admin I realized that the boundary between "what belongs in the API and what is Admin logic" requires careful thought. I ended up keeping the logic close to the data — Admin is just a client calling the API.
