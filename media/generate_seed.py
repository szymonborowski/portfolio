#!/usr/bin/env python3
"""Generate seed.sql from markdown post files."""

import os
import re
import uuid
from pathlib import Path

BASE = Path(__file__).parent / "posts"
OUT  = Path(__file__).parent / "seed.sql"

# Author emails
SZYMON = "szymon.borowski@gmail.com"
AINA   = "aina@borowski.services"

# Post definitions: {dir, locale, category_slug, date[, status[, author_email]]}
# status defaults to "published", author defaults to AINA
POSTS = [
    ("intro-01-why-this-blog",   "pl", "start-here", "2026-01-26", "published", SZYMON),
    ("intro-01-why-this-blog",   "en", "start-here", "2026-01-26", "published", SZYMON),
    ("intro-02-architecture",    "pl", "start-here", "2026-01-27", "published", SZYMON),
    ("intro-02-architecture",    "en", "start-here", "2026-01-27", "published", SZYMON),
    ("intro-03-how-to-run",     "pl", "start-here", "2026-01-28", "draft",     SZYMON),
    ("intro-03-how-to-run",     "en", "start-here", "2026-01-28", "draft",     SZYMON),
    ("article-01-why-microservices","pl","architektura","2026-01-29","published",SZYMON),
    ("article-01-why-microservices","en","architektura","2026-01-29","published",SZYMON),
    ("feature-01-blog-api",      "pl", "dev-log",    "2026-01-27"),
    ("feature-01-blog-api",      "en", "dev-log",    "2026-01-27"),
    ("feature-02-oauth2-sso",    "pl", "dev-log",    "2026-01-27"),
    ("feature-02-oauth2-sso",    "en", "dev-log",    "2026-01-27"),
    ("feature-03-rabbitmq-users","pl", "dev-log",    "2026-01-28"),
    ("feature-03-rabbitmq-users","en", "dev-log",    "2026-01-28"),
    ("article-02-traefik-reverse-proxy","pl","devops","2026-02-01","published",SZYMON),
    ("article-02-traefik-reverse-proxy","en","devops","2026-02-01","published",SZYMON),
    ("feature-04-admin-rbac",    "pl", "dev-log",    "2026-01-31"),
    ("feature-04-admin-rbac",    "en", "dev-log",    "2026-01-31"),
    ("article-03-oauth2-sso-passport","pl","backend","2026-02-04","published",SZYMON),
    ("article-03-oauth2-sso-passport","en","backend","2026-02-04","published",SZYMON),
    ("feature-05-kubernetes",    "pl", "dev-log",    "2026-02-08"),
    ("feature-05-kubernetes",    "en", "dev-log",    "2026-02-08"),
    ("article-04-docker-multi-stage","pl","devops",  "2026-02-09","published",SZYMON),
    ("article-04-docker-multi-stage","en","devops",  "2026-02-09","published",SZYMON),
    ("feature-06-analytics",     "pl", "dev-log",    "2026-02-11"),
    ("feature-06-analytics",     "en", "dev-log",    "2026-02-11"),
    ("feature-07-monitoring",    "pl", "dev-log",    "2026-02-12"),
    ("feature-07-monitoring",    "en", "dev-log",    "2026-02-12"),
    ("article-05-kubernetes-migration","pl","devops", "2026-02-18","published",SZYMON),
    ("article-05-kubernetes-migration","en","devops", "2026-02-18","published",SZYMON),
    ("article-06-github-actions-cicd","pl","devops",  "2026-03-18","published",SZYMON),
    ("article-06-github-actions-cicd","en","devops",  "2026-03-18","published",SZYMON),
    ("article-07-monitoring-stack","pl","devops",     "2026-03-21","published",SZYMON),
    ("article-07-monitoring-stack","en","devops",     "2026-03-21","published",SZYMON),
    ("article-08-analytics-service","pl","backend",   "2026-03-24","published",SZYMON),
    ("article-08-analytics-service","en","backend",   "2026-03-24","published",SZYMON),
    ("feature-08-production-deploy","pl","dev-log",  "2026-03-16"),
    ("feature-08-production-deploy","en","dev-log",  "2026-03-16"),
    ("feature-09-cms",           "pl", "dev-log",    "2026-03-17"),
    ("feature-09-cms",           "en", "dev-log",    "2026-03-17"),
    ("feature-10-ui-improvements","pl","dev-log",    "2026-03-19"),
    ("feature-10-ui-improvements","en","dev-log",    "2026-03-19"),
    ("feature-11-pages-i18n",    "pl", "dev-log",    "2026-03-20"),
    ("feature-11-pages-i18n",    "en", "dev-log",    "2026-03-20"),
    ("feature-12-install-sh",    "pl", "dev-log",    "2026-03-21"),
    ("feature-12-install-sh",    "en", "dev-log",    "2026-03-21"),
    ("feature-13-easymde-editor","pl", "dev-log",    "2026-03-22"),
    ("feature-13-easymde-editor","en", "dev-log",    "2026-03-22"),
    ("feature-14-docker-fixes",  "pl", "dev-log",    "2026-03-22"),
    ("feature-14-docker-fixes",  "en", "dev-log",    "2026-03-22"),
    ("feature-15-i18n-translations","pl","dev-log",  "2026-03-23"),
    ("feature-15-i18n-translations","en","dev-log",  "2026-03-23"),
    ("feature-16-post-reading",  "pl", "dev-log",    "2026-03-24"),
    ("feature-16-post-reading",  "en", "dev-log",    "2026-03-24"),
    ("feature-17-author-dark-mode","pl","dev-log",   "2026-03-24"),
    ("feature-17-author-dark-mode","en","dev-log",   "2026-03-24"),
    ("feature-18-category-widget","pl","dev-log",    "2026-03-25"),
    ("feature-18-category-widget","en","dev-log",    "2026-03-25"),
    ("feature-19-comments-likes","pl","dev-log",    "2026-03-30"),
    ("feature-19-comments-likes","en","dev-log",    "2026-03-30"),
    ("feature-20-production-monitoring","pl","dev-log","2026-04-01"),
    ("feature-20-production-monitoring","en","dev-log","2026-04-01"),
    ("feature-21-media-lightbox","pl","dev-log",    "2026-04-05"),
    ("feature-21-media-lightbox","en","dev-log",    "2026-04-05"),
    ("feature-22-seo-i18n",     "pl","dev-log",    "2026-04-06"),
    ("feature-22-seo-i18n",     "en","dev-log",    "2026-04-06"),
    ("feature-23-contact-form", "pl","dev-log",    "2026-04-07"),
    ("feature-23-contact-form", "en","dev-log",    "2026-04-07"),
    ("feature-24-light-theme",  "pl","dev-log",    "2026-04-08"),
    ("feature-24-light-theme",  "en","dev-log",    "2026-04-08"),
    ("feature-25-aina-agent",   "pl","dev-log",    "2026-04-10"),
    ("feature-25-aina-agent",   "en","dev-log",    "2026-04-10"),
    ("feature-26-pao",          "pl","dev-log",    "2026-04-11"),
    ("feature-26-pao",          "en","dev-log",    "2026-04-11"),
]

# Featured posts — referenced by locale-agnostic slug
FEATURED_SLUGS = [
    "intro-01-why-this-blog",
    "intro-02-architecture",
]


def esc(s):
    """Escape string for SQL single-quoted value."""
    s = s.replace("\\", "\\\\")
    s = s.replace("'", "\\'")
    return s


def parse_md(path):
    text = path.read_text(encoding="utf-8")
    parts = text.split("---", 2)
    if len(parts) < 3:
        raise ValueError(f"No frontmatter in {path}")
    fm_raw = parts[1].strip()
    content = parts[2].strip()

    fm = {}
    for line in fm_raw.splitlines():
        if ":" in line:
            k, _, v = line.partition(":")
            fm[k.strip()] = v.strip().strip('"')

    tags_raw = fm.get("tags", "[]")
    tags = re.findall(r'[\w\-]+', tags_raw.replace("[","").replace("]",""))

    title   = fm.get("title", "")
    excerpt = fm.get("excerpt", "")
    locale  = fm.get("locale", "pl")

    if not excerpt:
        first = content.split("\n\n")[0].strip()
        first = re.sub(r'^#+\s+', '', first)
        first = re.sub(r'\*+', '', first)
        first = first[:255]
        excerpt = first

    return title, excerpt, content, locale, tags


def slugify_tag(name):
    return re.sub(r'[^a-z0-9]+', '-', name.lower()).strip('-')


def main():
    all_tags = {}   # slug -> name
    # Group by dirname: one post row, multiple translations
    posts_by_dir = {}   # dirname -> {uuid, cat_slug, pub_at, translations: [{locale, title, ...}], tags: set}

    for entry in POSTS:
        dirname, locale, cat_slug, date = entry[0], entry[1], entry[2], entry[3]
        status = entry[4] if len(entry) > 4 else "published"
        author_email = entry[5] if len(entry) > 5 else AINA
        md_path = BASE / dirname / f"{locale}.md"
        if not md_path.exists():
            print(f"MISSING: {md_path}")
            continue

        title, excerpt, content, _, tags = parse_md(md_path)
        pub_at = f"{date} 12:00:00"

        for tag in tags:
            ts = slugify_tag(tag)
            if ts and ts not in all_tags:
                all_tags[ts] = tag

        if dirname not in posts_by_dir:
            posts_by_dir[dirname] = {
                "uuid":       str(uuid.uuid4()),
                "slug":       dirname,
                "cat_slug":   cat_slug,
                "status":     status,
                "author_email": author_email,
                "pub_at":     pub_at,
                "translations": [],
                "tags":       set(),
            }

        posts_by_dir[dirname]["translations"].append({
            "locale":   locale,
            "title":    title,
            "excerpt":  excerpt,
            "content":  content,
        })

        for tag in tags:
            ts = slugify_tag(tag)
            if ts:
                posts_by_dir[dirname]["tags"].add(ts)

    rows = list(posts_by_dir.values())

    lines = []
    a = lines.append

    a("-- ============================================================")
    a("-- Blog seed — generated from media/posts/")
    a("-- Run on: blog service database")
    a("-- ============================================================")
    a("")
    a("SET NAMES utf8mb4;")
    a("SET CHARACTER SET utf8mb4;")
    a("SET FOREIGN_KEY_CHECKS = 0;")
    a("TRUNCATE TABLE featured_posts;")
    a("TRUNCATE TABLE post_tag;")
    a("TRUNCATE TABLE category_post;")
    a("TRUNCATE TABLE comments;")
    a("TRUNCATE TABLE post_translations;")
    a("TRUNCATE TABLE posts;")
    a("SET FOREIGN_KEY_CHECKS = 1;")
    a("")
    a("-- ------------------------------------------------------------")
    a("-- Categories (INSERT IGNORE — preserves existing)")
    a("-- ------------------------------------------------------------")
    a("INSERT IGNORE INTO categories (name, slug, color, icon) VALUES")
    a("  ('Start Here',   'start-here',   'indigo',  'star'),")
    a("  ('Dev Log',      'dev-log',      'emerald', 'command-line'),")
    a("  ('Architektura', 'architektura', 'sky',     'cube'),")
    a("  ('DevOps',       'devops',       'amber',   'server'),")
    a("  ('Backend',      'backend',      'violet',  'circle-stack');")
    a("UPDATE categories SET icon = 'star'         WHERE slug = 'start-here'   AND (icon IS NULL OR icon = '');")
    a("UPDATE categories SET icon = 'command-line' WHERE slug = 'dev-log'      AND (icon IS NULL OR icon = '');")
    a("UPDATE categories SET icon = 'cube'         WHERE slug = 'architektura' AND (icon IS NULL OR icon = '');")
    a("UPDATE categories SET icon = 'server'       WHERE slug = 'devops'       AND (icon IS NULL OR icon = '');")
    a("UPDATE categories SET icon = 'circle-stack' WHERE slug = 'backend'      AND (icon IS NULL OR icon = '');")
    a("")
    a("-- ------------------------------------------------------------")
    a("-- Tags")
    a("-- ------------------------------------------------------------")
    if all_tags:
        tag_values = ",\n".join(
            f"  ('{esc(name)}', '{esc(slug)}')"
            for slug, name in sorted(all_tags.items())
        )
        a(f"INSERT IGNORE INTO tags (name, slug) VALUES\n{tag_values};")
    a("")
    a("-- ------------------------------------------------------------")
    a("-- Posts (locale-agnostic slug)")
    a("-- ------------------------------------------------------------")

    for r in rows:
        email = esc(r['author_email'])
        a(f"-- {r['slug']}")
        a("INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (")
        a(f"  '{r['uuid']}',")
        a(f"  (SELECT user_id FROM authors WHERE email = '{email}'),")
        a(f"  '{esc(r['slug'])}',")
        a(f"  '{r['status']}',")
        pub_at = r['pub_at'] if r['status'] == 'published' else 'NULL'
        if pub_at == 'NULL':
            a(f"  {pub_at},")
        else:
            a(f"  '{pub_at}',")
        a(f"  '{r['pub_at']}',")
        a(f"  '{r['pub_at']}'")
        a(");")
        a("")

    a("-- ------------------------------------------------------------")
    a("-- Post translations (title, excerpt, content per locale)")
    a("-- ------------------------------------------------------------")

    for r in rows:
        for t in r["translations"]:
            a(f"-- {r['slug']} [{t['locale']}]")
            a("INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)")
            a(f"  SELECT id, '{t['locale']}', '{esc(t['title'])}', '{esc(t['excerpt'][:255])}',")
            a(f"         '{esc(t['content'])}', 1, NOW(), NOW()")
            a(f"  FROM posts WHERE slug = '{esc(r['slug'])}';")
            a("")

    a("-- ------------------------------------------------------------")
    a("-- Category → Post pivots")
    a("-- ------------------------------------------------------------")
    for r in rows:
        a(f"INSERT INTO category_post (category_id, post_id)")
        a(f"  SELECT c.id, p.id FROM categories c, posts p")
        a(f"  WHERE c.slug = '{r['cat_slug']}' AND p.slug = '{r['slug']}';")
    a("")

    a("-- ------------------------------------------------------------")
    a("-- Tag → Post pivots")
    a("-- ------------------------------------------------------------")
    for r in rows:
        for tag_slug in r["tags"]:
            if tag_slug in all_tags:
                a(f"INSERT INTO post_tag (post_id, tag_id)")
                a(f"  SELECT p.id, t.id FROM posts p, tags t")
                a(f"  WHERE p.slug = '{r['slug']}' AND t.slug = '{tag_slug}';")
    a("")

    a("-- ------------------------------------------------------------")
    a("-- Featured posts")
    a("-- ------------------------------------------------------------")
    for i, slug in enumerate(FEATURED_SLUGS, start=1):
        a(f"INSERT INTO featured_posts (post_id, position, created_at, updated_at)")
        a(f"  SELECT id, {i}, NOW(), NOW() FROM posts WHERE slug = '{slug}';")
    a("")
    a("-- Done.")

    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Written: {OUT} ({len(rows)} posts, {len(all_tags)} tags)")


if __name__ == "__main__":
    main()
