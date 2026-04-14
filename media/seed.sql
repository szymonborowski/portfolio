-- ============================================================
-- Blog seed — generated from media/posts/
-- Run on: blog service database
-- ============================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE featured_posts;
TRUNCATE TABLE post_tag;
TRUNCATE TABLE category_post;
TRUNCATE TABLE comments;
TRUNCATE TABLE post_translations;
TRUNCATE TABLE posts;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- Categories (INSERT IGNORE — preserves existing)
-- ------------------------------------------------------------
INSERT IGNORE INTO categories (name, slug, color, icon) VALUES
  ('Start Here',   'start-here',   'indigo',  'star'),
  ('Dev Log',      'dev-log',      'emerald', 'command-line'),
  ('Architektura', 'architektura', 'sky',     'cube'),
  ('DevOps',       'devops',       'amber',   'server'),
  ('Backend',      'backend',      'violet',  'circle-stack');
UPDATE categories SET icon = 'star'         WHERE slug = 'start-here'   AND (icon IS NULL OR icon = '');
UPDATE categories SET icon = 'command-line' WHERE slug = 'dev-log'      AND (icon IS NULL OR icon = '');
UPDATE categories SET icon = 'cube'         WHERE slug = 'architektura' AND (icon IS NULL OR icon = '');
UPDATE categories SET icon = 'server'       WHERE slug = 'devops'       AND (icon IS NULL OR icon = '');
UPDATE categories SET icon = 'circle-stack' WHERE slug = 'backend'      AND (icon IS NULL OR icon = '');

-- ------------------------------------------------------------
-- Tags
-- ------------------------------------------------------------
INSERT IGNORE INTO tags (name, slug) VALUES
  ('accessibility', 'accessibility'),
  ('admin', 'admin'),
  ('agent', 'agent'),
  ('AI', 'ai'),
  ('Alpine', 'alpine'),
  ('analytics', 'analytics'),
  ('Anthropic', 'anthropic'),
  ('api', 'api'),
  ('architecture', 'architecture'),
  ('architektura', 'architektura'),
  ('authentication', 'authentication'),
  ('author', 'author'),
  ('authorization', 'authorization'),
  ('automation', 'automation'),
  ('autoryzacja', 'autoryzacja'),
  ('bash', 'bash'),
  ('Blade', 'blade'),
  ('blog', 'blog'),
  ('Card', 'card'),
  ('categories', 'categories'),
  ('CDN', 'cdn'),
  ('cert-manager', 'cert-manager'),
  ('chat', 'chat'),
  ('CI-CD', 'ci-cd'),
  ('Claude', 'claude'),
  ('cms', 'cms'),
  ('comments', 'comments'),
  ('components', 'components'),
  ('configuration', 'configuration'),
  ('contact', 'contact'),
  ('containers', 'containers'),
  ('contrast', 'contrast'),
  ('CSS', 'css'),
  ('dark-mode', 'dark-mode'),
  ('database', 'database'),
  ('deployment', 'deployment'),
  ('design', 'design'),
  ('developer-experience', 'developer-experience'),
  ('devops', 'devops'),
  ('docker', 'docker'),
  ('docker-compose', 'docker-compose'),
  ('Dockerfile', 'dockerfile'),
  ('dostępność', 'dost-pno'),
  ('EasyMDE', 'easymde'),
  ('editor', 'editor'),
  ('email', 'email'),
  ('en', 'en'),
  ('environment', 'environment'),
  ('events', 'events'),
  ('eventy', 'eventy'),
  ('featured-posts', 'featured-posts'),
  ('filament', 'filament'),
  ('form', 'form'),
  ('formularz', 'formularz'),
  ('frontend', 'frontend'),
  ('GHCR', 'ghcr'),
  ('GitHub-Actions', 'github-actions'),
  ('grafana', 'grafana'),
  ('Graph', 'graph'),
  ('hardening', 'hardening'),
  ('health-check', 'health-check'),
  ('Helm', 'helm'),
  ('highlight', 'highlight'),
  ('i18n', 'i18n'),
  ('Image', 'image'),
  ('infra', 'infra'),
  ('infrastructure', 'infrastructure'),
  ('instalacja', 'instalacja'),
  ('install', 'install'),
  ('installation', 'installation'),
  ('internal', 'internal'),
  ('Intervention', 'intervention'),
  ('intro', 'intro'),
  ('js', 'js'),
  ('jwt', 'jwt'),
  ('k8s', 'k8s'),
  ('kategorie', 'kategorie'),
  ('komentarze', 'komentarze'),
  ('kontakt', 'kontakt'),
  ('kontrast', 'kontrast'),
  ('kubernetes', 'kubernetes'),
  ('kustomize', 'kustomize'),
  ('laravel', 'laravel'),
  ('lightbox', 'lightbox'),
  ('likes', 'likes'),
  ('local-dev', 'local-dev'),
  ('loki', 'loki'),
  ('magento', 'magento'),
  ('Mailable', 'mailable'),
  ('markdown', 'markdown'),
  ('media', 'media'),
  ('meta', 'meta'),
  ('microservices', 'microservices'),
  ('migration', 'migration'),
  ('migrations', 'migrations'),
  ('mikroserwisy', 'mikroserwisy'),
  ('mkcert', 'mkcert'),
  ('monitoring', 'monitoring'),
  ('MySQL', 'mysql'),
  ('newsletter', 'newsletter'),
  ('nginx', 'nginx'),
  ('nginx-ingress', 'nginx-ingress'),
  ('nunomaduro', 'nunomaduro'),
  ('oauth2', 'oauth2'),
  ('observability', 'observability'),
  ('Open', 'open'),
  ('ovh', 'ovh'),
  ('pages', 'pages'),
  ('paginacja', 'paginacja'),
  ('pagination', 'pagination'),
  ('pao', 'pao'),
  ('passport', 'passport'),
  ('Pest', 'pest'),
  ('PHP', 'php'),
  ('PHPUnit', 'phpunit'),
  ('pkce', 'pkce'),
  ('pl', 'pl'),
  ('polubienia', 'polubienia'),
  ('portfolio', 'portfolio'),
  ('production', 'production'),
  ('produkcja', 'produkcja'),
  ('prometheus', 'prometheus'),
  ('promtail', 'promtail'),
  ('Qdrant', 'qdrant'),
  ('rabbitmq', 'rabbitmq'),
  ('RAG', 'rag'),
  ('rbac', 'rbac'),
  ('Redis', 'redis'),
  ('refactoring', 'refactoring'),
  ('reverse-proxy', 'reverse-proxy'),
  ('role', 'role'),
  ('roles', 'roles'),
  ('security', 'security'),
  ('SEO', 'seo'),
  ('sso', 'sso'),
  ('StatefulSet', 'statefulset'),
  ('statistics', 'statistics'),
  ('statystyki', 'statystyki'),
  ('strony', 'strony'),
  ('tagi', 'tagi'),
  ('tags', 'tags'),
  ('Tailwind', 'tailwind'),
  ('testing', 'testing'),
  ('testowanie', 'testowanie'),
  ('tests', 'tests'),
  ('testy', 'testy'),
  ('TLS', 'tls'),
  ('traefik', 'traefik'),
  ('translations', 'translations'),
  ('tutorial', 'tutorial'),
  ('Twitter', 'twitter'),
  ('typography', 'typography'),
  ('ui', 'ui'),
  ('users', 'users'),
  ('UX', 'ux'),
  ('vendor', 'vendor'),
  ('Voyage', 'voyage'),
  ('WCAG', 'wcag'),
  ('WebP', 'webp');

-- ------------------------------------------------------------
-- Posts (locale-agnostic slug)
-- ------------------------------------------------------------
-- intro-01-why-this-blog
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '58ed9b99-d869-4c31-be6f-5cc637a299d5',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'intro-01-why-this-blog',
  'published',
  '2026-01-26 12:00:00',
  '2026-01-26 12:00:00',
  '2026-01-26 12:00:00'
);

-- intro-02-architecture
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '6f48317e-e7dd-4126-affc-8b91948a0e4a',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'intro-02-architecture',
  'published',
  '2026-01-27 12:00:00',
  '2026-01-27 12:00:00',
  '2026-01-27 12:00:00'
);

-- intro-03-how-to-run
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '11798714-be67-4282-828b-dd1c66a40388',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'intro-03-how-to-run',
  'draft',
  NULL,
  '2026-01-28 12:00:00',
  '2026-01-28 12:00:00'
);

-- article-01-why-microservices
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '86c41e52-4227-4a88-aaf9-a8b5010114aa',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-01-why-microservices',
  'published',
  '2026-01-29 12:00:00',
  '2026-01-29 12:00:00',
  '2026-01-29 12:00:00'
);

-- feature-01-blog-api
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'b448d781-2b06-4469-ae0f-b38bac40511c',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-01-blog-api',
  'published',
  '2026-01-27 12:00:00',
  '2026-01-27 12:00:00',
  '2026-01-27 12:00:00'
);

-- feature-02-oauth2-sso
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '788c0354-2113-403d-86cf-5490137b2b82',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-02-oauth2-sso',
  'published',
  '2026-01-27 12:00:00',
  '2026-01-27 12:00:00',
  '2026-01-27 12:00:00'
);

-- feature-03-rabbitmq-users
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'fc0a112e-d1ba-436a-a302-906eeaaca5f0',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-03-rabbitmq-users',
  'published',
  '2026-01-28 12:00:00',
  '2026-01-28 12:00:00',
  '2026-01-28 12:00:00'
);

-- article-02-traefik-reverse-proxy
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '8d89c12d-5c00-49df-9f8a-413ba2d3f628',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-02-traefik-reverse-proxy',
  'published',
  '2026-02-01 12:00:00',
  '2026-02-01 12:00:00',
  '2026-02-01 12:00:00'
);

-- feature-04-admin-rbac
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '75499a50-f95b-4b7b-b236-bdad7f75f2a6',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-04-admin-rbac',
  'published',
  '2026-01-31 12:00:00',
  '2026-01-31 12:00:00',
  '2026-01-31 12:00:00'
);

-- article-03-oauth2-sso-passport
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '3878be62-9263-4af7-b2fa-e2f377b0128c',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-03-oauth2-sso-passport',
  'published',
  '2026-02-04 12:00:00',
  '2026-02-04 12:00:00',
  '2026-02-04 12:00:00'
);

-- feature-05-kubernetes
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'ab79097f-3753-4866-a3f7-7bfddc50dd23',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-05-kubernetes',
  'published',
  '2026-02-08 12:00:00',
  '2026-02-08 12:00:00',
  '2026-02-08 12:00:00'
);

-- article-04-docker-multi-stage
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '714158f8-20f2-4bed-8df9-b7e047fa44fa',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-04-docker-multi-stage',
  'published',
  '2026-02-09 12:00:00',
  '2026-02-09 12:00:00',
  '2026-02-09 12:00:00'
);

-- feature-06-analytics
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '0c96c4fa-8bfa-4233-9604-577b6acb94bb',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-06-analytics',
  'published',
  '2026-02-11 12:00:00',
  '2026-02-11 12:00:00',
  '2026-02-11 12:00:00'
);

-- feature-07-monitoring
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '25786e69-1a02-499b-9d72-9de78726a4b2',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-07-monitoring',
  'published',
  '2026-02-12 12:00:00',
  '2026-02-12 12:00:00',
  '2026-02-12 12:00:00'
);

-- article-05-kubernetes-migration
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'efd70729-5043-4e31-a94b-709820cf62c9',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-05-kubernetes-migration',
  'published',
  '2026-02-18 12:00:00',
  '2026-02-18 12:00:00',
  '2026-02-18 12:00:00'
);

-- article-06-github-actions-cicd
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'c1a8460b-f06c-4b96-a53c-a7466b3eb599',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-06-github-actions-cicd',
  'published',
  '2026-03-18 12:00:00',
  '2026-03-18 12:00:00',
  '2026-03-18 12:00:00'
);

-- article-07-monitoring-stack
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'cc7d5c69-e799-4a91-91a9-46e21b3abd92',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-07-monitoring-stack',
  'published',
  '2026-03-21 12:00:00',
  '2026-03-21 12:00:00',
  '2026-03-21 12:00:00'
);

-- article-08-analytics-service
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '8d53460b-0d72-4e98-a476-2ebd98ea3ab0',
  (SELECT user_id FROM authors WHERE email = 'szymon.borowski@gmail.com'),
  'article-08-analytics-service',
  'published',
  '2026-03-24 12:00:00',
  '2026-03-24 12:00:00',
  '2026-03-24 12:00:00'
);

-- feature-08-production-deploy
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '6ef941c8-c612-4880-8d7d-4dc2b0b7455b',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-08-production-deploy',
  'published',
  '2026-03-16 12:00:00',
  '2026-03-16 12:00:00',
  '2026-03-16 12:00:00'
);

-- feature-09-cms
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'bc36d16c-9d0d-4d7a-b656-6296a92d21ea',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-09-cms',
  'published',
  '2026-03-17 12:00:00',
  '2026-03-17 12:00:00',
  '2026-03-17 12:00:00'
);

-- feature-10-ui-improvements
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '138c69c7-f07e-41cf-8e84-8d1cec8fd4c9',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-10-ui-improvements',
  'published',
  '2026-03-19 12:00:00',
  '2026-03-19 12:00:00',
  '2026-03-19 12:00:00'
);

-- feature-11-pages-i18n
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'dd9771e8-e5fd-4a90-8f5a-d1363399a90c',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-11-pages-i18n',
  'published',
  '2026-03-20 12:00:00',
  '2026-03-20 12:00:00',
  '2026-03-20 12:00:00'
);

-- feature-12-install-sh
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '5c5b4ee2-853d-4f33-b7e3-965dfe4dc7fe',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-12-install-sh',
  'published',
  '2026-03-21 12:00:00',
  '2026-03-21 12:00:00',
  '2026-03-21 12:00:00'
);

-- feature-13-easymde-editor
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '900d32e3-dd08-4ef0-8771-8790ec5edd64',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-13-easymde-editor',
  'published',
  '2026-03-22 12:00:00',
  '2026-03-22 12:00:00',
  '2026-03-22 12:00:00'
);

-- feature-14-docker-fixes
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '1f8e84c4-9e86-466c-9c61-aac61528fc6c',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-14-docker-fixes',
  'published',
  '2026-03-22 12:00:00',
  '2026-03-22 12:00:00',
  '2026-03-22 12:00:00'
);

-- feature-15-i18n-translations
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'e0334fa9-1613-489c-8b01-8f668d7c784f',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-15-i18n-translations',
  'published',
  '2026-03-23 12:00:00',
  '2026-03-23 12:00:00',
  '2026-03-23 12:00:00'
);

-- feature-16-post-reading
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'd2c3a584-d1b9-4c55-89c2-835965b63c43',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-16-post-reading',
  'published',
  '2026-03-24 12:00:00',
  '2026-03-24 12:00:00',
  '2026-03-24 12:00:00'
);

-- feature-17-author-dark-mode
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '54197ab0-cdb8-4b04-893a-96e68a80bdea',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-17-author-dark-mode',
  'published',
  '2026-03-24 12:00:00',
  '2026-03-24 12:00:00',
  '2026-03-24 12:00:00'
);

-- feature-18-category-widget
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '8f66e26e-124c-4e54-806c-62bbb5f8d0f8',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-18-category-widget',
  'published',
  '2026-03-25 12:00:00',
  '2026-03-25 12:00:00',
  '2026-03-25 12:00:00'
);

-- feature-19-comments-likes
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '26c34b7c-7faf-4bd0-a771-3f519b511f1a',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-19-comments-likes',
  'published',
  '2026-03-30 12:00:00',
  '2026-03-30 12:00:00',
  '2026-03-30 12:00:00'
);

-- feature-20-production-monitoring
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '21384193-b823-4429-a616-b0579f2bee26',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-20-production-monitoring',
  'published',
  '2026-04-01 12:00:00',
  '2026-04-01 12:00:00',
  '2026-04-01 12:00:00'
);

-- feature-21-media-lightbox
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '8d6ed59c-9077-463a-9a0f-54df884828c3',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-21-media-lightbox',
  'published',
  '2026-04-05 12:00:00',
  '2026-04-05 12:00:00',
  '2026-04-05 12:00:00'
);

-- feature-22-seo-i18n
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '57cbe9e4-e2c8-41b4-9aa6-cb3121c14000',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-22-seo-i18n',
  'published',
  '2026-04-06 12:00:00',
  '2026-04-06 12:00:00',
  '2026-04-06 12:00:00'
);

-- feature-23-contact-form
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '4b13c09e-6ee6-4ff4-b3c8-0ac28ae0c847',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-23-contact-form',
  'published',
  '2026-04-07 12:00:00',
  '2026-04-07 12:00:00',
  '2026-04-07 12:00:00'
);

-- feature-24-light-theme
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  '3b614b5f-a250-43af-a389-e739ccbfc7e4',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-24-light-theme',
  'published',
  '2026-04-08 12:00:00',
  '2026-04-08 12:00:00',
  '2026-04-08 12:00:00'
);

-- feature-25-aina-agent
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'a0f9501e-ed7f-4a7c-858f-746973cf2a45',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-25-aina-agent',
  'published',
  '2026-04-10 12:00:00',
  '2026-04-10 12:00:00',
  '2026-04-10 12:00:00'
);

-- feature-26-pao
INSERT INTO posts (uuid, author_id, slug, status, published_at, created_at, updated_at) VALUES (
  'f4eac2d6-d532-4f54-8e70-23b7e4ae208f',
  (SELECT user_id FROM authors WHERE email = 'aina@borowski.services'),
  'feature-26-pao',
  'published',
  '2026-04-11 12:00:00',
  '2026-04-11 12:00:00',
  '2026-04-11 12:00:00'
);

-- ------------------------------------------------------------
-- Post translations (title, excerpt, content per locale)
-- ------------------------------------------------------------
-- intro-01-why-this-blog [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Dlaczego stworzyłem ten blog?', 'Przez ostatnie dziesięć lat pisałem PHP w świecie Magento. Magento 1.x, wersje od 1.6 do 1.9, potem półtora roku z Magento 2. Dobrze orientuję się w jego architekturze event-observer, systemie layoutów XML i tworzeniu customowych modułów. Wiem, gdzie szuk',
         'Przez ostatnie dziesięć lat pisałem PHP w świecie Magento. Magento 1.x, wersje od 1.6 do 1.9, potem półtora roku z Magento 2. Dobrze orientuję się w jego architekturze event-observer, systemie layoutów XML i tworzeniu customowych modułów. Wiem, gdzie szukać, gdy coś się psuje.

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

Zapraszam do lektury.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'intro-01-why-this-blog';

-- intro-01-why-this-blog [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Why I built this blog', 'For the past ten years I have been writing PHP inside the Magento world. Magento 1.x — versions 1.6 through 1.9 — then about a year and a half with Magento 2. I have a solid understanding of its event-observer architecture, the XML layout system, and cust',
         'For the past ten years I have been writing PHP inside the Magento world. Magento 1.x — versions 1.6 through 1.9 — then about a year and a half with Magento 2. I have a solid understanding of its event-observer architecture, the XML layout system, and custom module development. I know where to look when something breaks.

There is just one problem: Magento is a very specific ecosystem. When a job interview reaches the "show me your code" moment, what I can show is code deeply entangled with the framework, living inside a project that needs a full e-commerce infrastructure to make any sense at all. It is hard to evaluate from the outside, and even harder to demonstrate that my skills go beyond knowing one particular framework well.

I decided to change that.

## What I wanted to learn

The list was long. Modern Laravel — I had worked with older versions before, but the ecosystem has evolved significantly. Microservices — I understood the concept of splitting a system into small, independent services, but I had never actually built something like that from scratch. RabbitMQ — message queues, asynchronous events, consumers. Kubernetes — a completely new topic for me, starting from absolute zero. All things I had heard about at conferences and in podcasts but never touched in my day-to-day work.

I could have built a simple to-do app. I could have made a minimal CRUD project just to "go through the material." I decided differently: I wanted to build something real. Something that runs in production, that has genuine problems to solve, that I can show with pride.

## Why a blog?

A blog is a format I understand well — it reads like a real product, it is obvious what works and what does not. At the same time it is technically complex enough to be interesting: it needs authentication, content management, comments, analytics, an admin panel. It is a natural fit for every technology I wanted to learn.

Instead of a monolithic Laravel application, I built a system of six microservices. Frontend handles the user interface and OAuth2. A dedicated SSO service acts as the authorization server. Blog API manages posts, categories, tags, and comments. Users handles user management and permissions. Analytics tracks page views through a RabbitMQ queue. Admin is my own control panel, built on FilamentPHP.

Each service is a separate Laravel application running in its own Docker container. Traefik ties everything together as the reverse proxy, and Kubernetes is the orchestration platform.

## A dual purpose

This blog serves two goals that reinforce each other. First, it is a learning platform — every technical decision, every problem to solve, every integration is something new I am figuring out. Second, it is a portfolio — you can read here about what I am building, how I am building it, and why I am making the choices I make.

I am not writing to look clever. I am writing to have a record of what I went through — the successes, the mistakes, and everything in between.

Welcome.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'intro-01-why-this-blog';

-- intro-02-architecture [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Architektura systemu — przegląd serwisów', 'Zanim zacznę opisywać poszczególne funkcjonalności, chcę dać pełny obraz systemu — kto z kim rozmawia, jak przepływają dane i dlaczego poszczególne serwisy są tam, gdzie są. Ten post to mapa, do której można wracać czytając kolejne wpisy.',
         'Zanim zacznę opisywać poszczególne funkcjonalności, chcę dać pełny obraz systemu — kto z kim rozmawia, jak przepływają dane i dlaczego poszczególne serwisy są tam, gdzie są. Ten post to mapa, do której można wracać czytając kolejne wpisy.

## Diagram

![Diagram architektury systemu](/architecture.svg)

Cały ruch zewnętrzny trafia do Traefika. On decyduje, do którego serwisu przekierować żądanie na podstawie hosta lub ścieżki URL. Serwisy nie widzą bezpośrednio internetu — rozmawiają ze sobą przez wewnętrzną sieć Dockera lub Kubernetes.

## Serwisy

**Frontend** to główna aplikacja webowa. Tutaj trafia użytkownik wchodzący na borowski.services. Frontend renderuje blog, obsługuje panel użytkownika, realizuje przepływ OAuth2 (logowanie przez SSO) i przechowuje sesje w Redis. Nie ma własnej bazy danych dla treści — wszystko pobiera z API innych serwisów.

**SSO** to serwer autoryzacji OAuth2, zbudowany na Laravel Passport. Obsługuje logowanie, rejestrację, wydawanie tokenów i ich odświeżanie. Kiedy użytkownik klika "zaloguj się" na Frontendzie, ląduje tutaj. Po uwierzytelnieniu wraca do Frontendu z kodem autoryzacyjnym, który jest wymieniany na token dostępu.

**Admin** to panel administracyjny oparty na FilamentPHP. Służy mi do zarządzania treścią bloga: pisania postów, zarządzania kategoriami, tagami i komentarzami. Admin jest odizolowany od reszty świata — dostęp tylko dla mnie.

**Users** zarządza kontami użytkowników, rolami i uprawnieniami (RBAC). To centralne źródło prawdy o tym, kto może co robić w systemie. Udostępnia wewnętrzne API dla innych serwisów i publikuje zdarzenia do RabbitMQ, gdy stan użytkownika się zmienia.

**Blog** to API bloga. Odpowiada za posty, kategorie z hierarchią, tagi i komentarze z moderacją. Komunikuje się z Users przez RabbitMQ, żeby synchronizować dane o autorach. Udostępnia JSON API konsumowane przez Frontend.

**Analytics** to mikroserwis oparty wyłącznie na konsumentach RabbitMQ. Nie ma własnego API dostępnego z zewnątrz — tylko nasłuchuje na zdarzenia (np. wyświetlenie posta) i zapisuje statystyki do swojej bazy danych. Taka architektura sprawia, że śledzenie wyświetleń jest asynchroniczne i nie spowalnia głównych serwisów.

**Infra** to nie jeden serwis, ale zestaw narzędzi: Traefik jako reverse proxy, RabbitMQ jako broker wiadomości, Prometheus + Loki + Grafana jako stos monitorowania.

## Komunikacja między serwisami

Używam trzech wzorców komunikacji. HTTP REST to standard dla żądań zewnętrznych — przeglądarka wywołuje Frontend, który wywołuje Blog API. Wewnętrzne API z kluczem API to mechanizm dla komunikacji serwis-do-serwisu, gdzie nie chcę wystawiać endpointów publicznie (np. SSO pytające Users o dane użytkownika). RabbitMQ obsługuje zdarzenia asynchroniczne — gdy Users zmieni status konta, publikuje zdarzenie, a Blog i Analytics konsumują je niezależnie.

## Dlaczego microservices?

Szczera odpowiedź: głównie po to, żeby się nauczyć. Taki system dla jednej osoby spokojnie mieściłby się w monolicie. Ale cel tego projektu to zdobycie praktycznego doświadczenia z technologiami, które są standardem w większych organizacjach. Separacja serwisów wymusiła na mnie myślenie o granicach odpowiedzialności, kontraktach między serwisami i tym, co się dzieje, gdy jeden serwis jest chwilowo niedostępny.

To nauka przez budowanie.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'intro-02-architecture';

-- intro-02-architecture [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'System architecture — a service overview', 'Before I start describing individual features, I want to give a complete picture of the system — who talks to whom, how data flows, and why each service sits where it does. Think of this post as a map to come back to while reading the rest of the series.',
         'Before I start describing individual features, I want to give a complete picture of the system — who talks to whom, how data flows, and why each service sits where it does. Think of this post as a map to come back to while reading the rest of the series.

## Diagram

![System architecture diagram](/architecture.svg)

All external traffic enters through Traefik. It decides which service to route each request to, based on the hostname or URL path. The services themselves do not face the internet directly — they communicate with each other over Docker\'s internal network or Kubernetes cluster networking.

## Services

**Frontend** is the main web application. This is where a visitor arriving at borowski.services lands. Frontend renders the blog, handles the user panel, drives the OAuth2 flow (login via SSO), and stores sessions in Redis. It has no content database of its own — everything it displays comes from other services\' APIs.

**SSO** is the OAuth2 authorization server, built on Laravel Passport. It handles login, registration, token issuance, and token refresh. When a user clicks "log in" on the Frontend, they are redirected here. After authentication they return to the Frontend with an authorization code, which is exchanged for an access token.

**Admin** is the administration panel built on FilamentPHP. I use it to manage blog content: writing posts, organizing categories, tags, and moderating comments. Admin is isolated from the public — access is for me only.

**Users** manages user accounts, roles, and permissions (RBAC). It is the single source of truth about who can do what in the system. It exposes an internal API for other services and publishes events to RabbitMQ whenever a user\'s state changes.

**Blog** is the blog API. It handles posts, hierarchical categories, tags, and comments with moderation. It synchronizes author data with Users via RabbitMQ and exposes a JSON API consumed by Frontend.

**Analytics** is a microservice built entirely around RabbitMQ consumers. It has no externally accessible API — it only listens for events (such as a post being viewed) and writes statistics to its own database. This architecture keeps view tracking asynchronous so it never slows down the main services.

**Infra** is not a single service but a collection of tools: Traefik as the reverse proxy, RabbitMQ as the message broker, and Prometheus + Loki + Grafana as the observability stack.

## How services communicate

I use three communication patterns. HTTP REST is the standard for external requests — the browser calls Frontend, which calls Blog API. Internal API with an API key is the mechanism for service-to-service calls where I do not want to expose endpoints publicly (for example, SSO querying Users for account data). RabbitMQ handles asynchronous events — when Users changes an account\'s status it publishes an event, and Blog and Analytics consume it independently.

## Why microservices?

The honest answer: mainly to learn. A system like this for a single person would fit comfortably inside a monolith. But the goal of this project is to gain hands-on experience with technologies that are standard in larger organizations. Splitting into services forced me to think about boundaries of responsibility, contracts between services, and what happens when one service is temporarily unavailable.

Learning by building.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'intro-02-architecture';

-- intro-03-how-to-run [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Jak uruchomić projekt lokalnie', 'Ten post to praktyczny przewodnik — jak sklonować repozytorium, skonfigurować środowisko i uruchomić cały system na swoim komputerze. Jednym skryptem.',
         'Ten post to praktyczny przewodnik — jak sklonować repozytorium, skonfigurować środowisko i uruchomić cały system na swoim komputerze. Jednym skryptem.

## Wymagania

Zanim zaczniesz, upewnij się że masz zainstalowane:

- **git**
- **Docker Engine 24+** z Docker Compose v2
- **[mkcert](https://github.com/FiloSottile/mkcert)** — do generowania lokalnych certyfikatów TLS

Na Ubuntu/Debian mkcert zainstalujesz przez:

```bash
sudo apt install mkcert
```

Na macOS:

```bash
brew install mkcert
```

## Klonowanie i instalacja

```bash
git clone https://github.com/szymonborowski/portfolio.git
cd portfolio
./install.sh
```

Skrypt `install.sh` wykonuje automatycznie kilka kroków:

1. Klonuje repozytoria wszystkich mikroserwisów do podkatalogów
2. Tworzy pliki `.env` na podstawie `.env.example` dla każdego serwisu
3. Generuje losowe hasła, klucze API i sekrety OAuth2
4. Generuje certyfikaty TLS przez `mkcert` dla wszystkich lokalnych domen
5. Dodaje domeny do `/etc/hosts`
6. Tworzy wymagane sieci Docker

> Skrypt poprosi o hasło `sudo` — jest potrzebne wyłącznie do modyfikacji `/etc/hosts`.

## Uruchomienie

Po zakończeniu instalacji:

```bash
./dev.sh up -d --build
```

`dev.sh` to pomocniczy skrypt opakowujący `docker compose`. Możesz też uruchomić tylko wybrane serwisy:

```bash
./dev.sh up -d --build -- blog admin
```

Lub sprawdzić logi konkretnego serwisu:

```bash
./dev.sh logs -f -- frontend
```

## Dostępne adresy

Po uruchomieniu system jest dostępny pod następującymi adresami (domyślna domena to `microservices.local`):

| Serwis | Adres |
|--------|-------|
| Frontend | `https://frontend.microservices.local` |
| SSO | `https://sso.microservices.local` |
| Admin | `https://admin.microservices.local` |
| Blog API | `https://blog.microservices.local` |
| Traefik Dashboard | `https://traefik.microservices.local` |
| RabbitMQ | `https://rabbitmq.microservices.local` |
| Grafana | `https://grafana.microservices.local` |
| Prometheus | `https://prometheus.microservices.local` |

## Własna domena lokalna

Jeśli `microservices.local` koliduje z czymś w Twoim środowisku, możesz użyć innej domeny:

```bash
./install.sh --domain myapp.local
```

## Czysty reset

Jeśli chcesz zacząć od zera:

```bash
./install.sh --purge
```

To zatrzyma wszystkie serwisy i usunie sklonowane repozytoria. Potem możesz ponownie uruchomić `./install.sh`.

---

Jeśli coś nie zadziała — chętnie pomogę. Kod jest publiczny, więc możesz też zajrzeć bezpośrednio do repozytoriów poszczególnych serwisów.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'intro-03-how-to-run';

-- intro-03-how-to-run [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'How to run the project locally', 'This post is a practical guide — how to clone the repository, configure the environment, and run the entire system on your machine. With a single script.',
         'This post is a practical guide — how to clone the repository, configure the environment, and run the entire system on your machine. With a single script.

## Requirements

Before you start, make sure you have the following installed:

- **git**
- **Docker Engine 24+** with Docker Compose v2
- **[mkcert](https://github.com/FiloSottile/mkcert)** — for generating local TLS certificates

On Ubuntu/Debian:

```bash
sudo apt install mkcert
```

On macOS:

```bash
brew install mkcert
```

## Cloning and setup

```bash
git clone https://github.com/szymonborowski/portfolio.git
cd portfolio
./install.sh
```

The `install.sh` script automatically handles several steps:

1. Clones all microservice repositories into subdirectories
2. Creates `.env` files from `.env.example` for each service
3. Generates random passwords, API keys, and OAuth2 secrets
4. Generates TLS certificates via `mkcert` for all local domains
5. Adds domains to `/etc/hosts`
6. Creates the required Docker networks

> The script will ask for your `sudo` password — it is only needed to modify `/etc/hosts`.

## Starting the services

Once installation is complete:

```bash
./dev.sh up -d --build
```

`dev.sh` is a helper script wrapping `docker compose`. You can also start only selected services:

```bash
./dev.sh up -d --build -- blog admin
```

Or follow the logs of a specific service:

```bash
./dev.sh logs -f -- frontend
```

## Available addresses

After startup, the system is available at the following addresses (default domain is `microservices.local`):

| Service | Address |
|---------|---------|
| Frontend | `https://frontend.microservices.local` |
| SSO | `https://sso.microservices.local` |
| Admin | `https://admin.microservices.local` |
| Blog API | `https://blog.microservices.local` |
| Traefik Dashboard | `https://traefik.microservices.local` |
| RabbitMQ | `https://rabbitmq.microservices.local` |
| Grafana | `https://grafana.microservices.local` |
| Prometheus | `https://prometheus.microservices.local` |

## Custom local domain

If `microservices.local` conflicts with something in your environment, you can use a different domain:

```bash
./install.sh --domain myapp.local
```

## Clean reset

If you want to start from scratch:

```bash
./install.sh --purge
```

This stops all services and removes the cloned repositories. You can then run `./install.sh` again.

---

If something does not work — feel free to reach out. The code is public, so you can also browse the individual service repositories directly.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'intro-03-how-to-run';

-- article-01-why-microservices [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Dlaczego mikroserwisy do bloga? Analiza decyzji architektonicznej', 'Skąd w ogóle ten pomysł?',
         '## Skąd w ogóle ten pomysł?

Kiedy zaczynałem budować portfolio, stałem przed klasycznym wyborem: monorepo z Laravelem, które działa od pierwszego dnia, albo coś bardziej ambitnego. Wybrałem to drugie — i mam co do tego mieszane uczucia, ale w pozytywnym sensie.

Celem nie była "najlepsza architektura do bloga". Celem było **stworzenie platformy, która będzie służyła jako żywe demo moich umiejętności**. Blog jest tylko pretekstem.

## Co wchodzi w skład systemu?

System składa się z 6 serwisów:

- **Frontend** — Laravel + Blade, serwuje strony użytkownikom
- **Blog** — Laravel API, zarządza postami, komentarzami, kategoriami, tagami
- **Users** — Laravel API, zarządza użytkownikami, RBAC
- **SSO** — serwer OAuth2 oparty na Laravel Passport
- **Admin** — panel administracyjny oparty na FilamentPHP
- **Analytics** — zbiera wyświetlenia postów i agreguje statystyki

Każdy serwis ma własną bazę danych MySQL, własny kontener, własne testy.

## Komunikacja między serwisami

Serwisy komunikują się na dwa sposoby:

### HTTP (synchroniczne)
Frontend wywołuje Blog API i Users API bezpośrednio przez wewnętrzną sieć Dockera. Używam `X-Internal-Api-Key` jako prostego mechanizmu autoryzacji między serwisami.

### RabbitMQ (asynchroniczne)
Kiedy użytkownik wyświetla post, Frontend publikuje event `post.viewed` do RabbitMQ. Analytics consumer odbiera go i zapisuje do bazy. Kiedy użytkownik zmienia dane w Users, event `user.updated` trafia do Blog, który aktualizuje swoją lokalną kopię autora.

```
Frontend ──HTTP──▶ Blog API
Frontend ──HTTP──▶ Users API
Frontend ──RabbitMQ──▶ Analytics
Users ──RabbitMQ──▶ Blog (synchronizacja autorów)
```

## Czy to był dobry pomysł?

**Zalety:**
- Każdy serwis można deployować niezależnie
- Naturalna izolacja odpowiedzialności
- Świetny materiał do nauki Kubernetes, ArgoCD, CI/CD
- Demo, które można pokazać na rozmowie kwalifikacyjnej

**Wady:**
- Dużo boilerplate na start (6 razy to samo scaffolding)
- Debugowanie przez sieć jest trudniejsze niż w monolicie
- Overhead infrastrukturalny (RabbitMQ, Traefik, osobne bazy)

Gdybym budował "prawdziwy" produkt od zera, pewnie wybrałbym monolit. Ale to nie jest "prawdziwy" produkt — to platforma do nauki i demo. I jako takie, spełnia swoje zadanie znakomicie.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-01-why-microservices';

-- article-01-why-microservices [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Why microservices for a blog? Analyzing an architectural decision', 'Where did the idea come from?',
         '## Where did the idea come from?

When I started building my portfolio, I faced a classic choice: a Laravel monorepo that works from day one, or something more ambitious. I chose the latter — and I have mixed feelings about it, but in a positive sense.

The goal was not "the best architecture for a blog." The goal was **to create a platform that serves as a living demo of my skills**. The blog is just a pretext.

## What does the system consist of?

The system is made up of 6 services:

- **Frontend** — Laravel + Blade, serves pages to users
- **Blog** — Laravel API, manages posts, comments, categories, tags
- **Users** — Laravel API, manages users, RBAC
- **SSO** — OAuth2 server based on Laravel Passport
- **Admin** — admin panel based on FilamentPHP
- **Analytics** — collects post views and aggregates statistics

Each service has its own MySQL database, its own container, its own tests.

## Communication between services

Services communicate in two ways:

### HTTP (synchronous)
Frontend calls the Blog API and Users API directly over Docker\'s internal network. I use `X-Internal-Api-Key` as a simple authorization mechanism between services.

### RabbitMQ (asynchronous)
When a user views a post, Frontend publishes a `post.viewed` event to RabbitMQ. The Analytics consumer picks it up and writes it to the database. When a user updates their data in Users, a `user.updated` event is sent to Blog, which updates its local copy of the author.

```
Frontend ──HTTP──▶ Blog API
Frontend ──HTTP──▶ Users API
Frontend ──RabbitMQ──▶ Analytics
Users ──RabbitMQ──▶ Blog (author synchronization)
```

## Was it a good idea?

**Pros:**
- Each service can be deployed independently
- Natural separation of responsibilities
- Great material for learning Kubernetes, ArgoCD, CI/CD
- A demo you can show at a job interview

**Cons:**
- A lot of boilerplate upfront (the same scaffolding 6 times over)
- Debugging over the network is harder than in a monolith
- Infrastructure overhead (RabbitMQ, Traefik, separate databases)

If I were building a "real" product from scratch, I would probably choose a monolith. But this is not a "real" product — it is a platform for learning and demonstration. And as such, it does its job remarkably well.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-01-why-microservices';

-- feature-01-blog-api [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Blog API — posty, kategorie, tagi, komentarze', 'Czas na pierwsze prawdziwe API. Blog Service dostał pełny zestaw endpointów — od postów przez kategorie i tagi po komentarze z moderacją. Całość chroniona przez własnego guarda JWT.',
         'Czas na pierwsze prawdziwe API. Blog Service dostał pełny zestaw endpointów — od postów przez kategorie i tagi po komentarze z moderacją. Całość chroniona przez własnego guarda JWT.

**Serwis: Blog**

## Autoryzacja JWT

Zamiast sesji — stateless JWT. Napisałem własnego guarda, który odczytuje token z nagłówka `Authorization: Bearer`, weryfikuje podpis i wstrzykuje użytkownika do kontekstu żądania. Serwis Blog nie ma własnych kont użytkowników — token pochodzi z SSO.

Trasy publiczne są dostępne bez tokenu, mutacje wymagają uwierzytelnienia:

```php
// routes/api.php
Route::get(\'/posts\', [PostController::class, \'index\']);
Route::get(\'/posts/{id}\', [PostController::class, \'show\']);
Route::middleware(\'auth:jwt\')->group(function () {
    Route::post(\'/posts\', [PostController::class, \'store\']);
    Route::put(\'/posts/{id}\', [PostController::class, \'update\']);
    Route::delete(\'/posts/{id}\', [PostController::class, \'destroy\']);
});
```

## Posty z paginacją i filtrowaniem

Endpoint `GET /posts` obsługuje paginację i filtrowanie po slugu. Dzięki filtrowi po slugu Frontend może pobrać pojedynczy post bez znajomości jego ID — wystarczy przyjazny URL.

```
GET /posts?slug=moj-post-o-laravelu
GET /posts?page=2&per_page=10
```

Odpowiedź zawsze zwraca metadane paginacji: `current_page`, `last_page`, `total`. Frontend wie, kiedy skończyły się wyniki.

## Hierarchiczne kategorie

Kategorie obsługują strukturę drzewiastą — każda kategoria może mieć rodzica. W bazie danych to kolumna `parent_id` z relacją self-referencing. API zwraca kategorie spłaszczone lub zagnieżdżone — zależy od parametru `?nested=true`.

## Tagi

CRUD tagów to proste API. Każdy post może mieć wiele tagów (relacja many-to-many). Dodałem endpoint zbiorczy do przypisywania tagów do posta w jednym żądaniu zamiast N osobnych wywołań.

## Komentarze z moderacją

Komentarze mają własny zestaw endpointów, w tym trasy moderatorskie. Moderator może zatwierdzić, odrzucić lub usunąć komentarz. Endpointy moderatorskie wymagają tokenu JWT z odpowiednią rolą — weryfikowaną przez guarda.

```
POST   /posts/{id}/comments
GET    /posts/{id}/comments
DELETE /comments/{id}           # moderator
PATCH  /comments/{id}/approve   # moderator
```

## Testy

Każdy moduł ma testy feature — posty, kategorie, tagi, komentarze. Testy pokrywają ścieżki sukcesu i błędów: brakujące pola, nieautoryzowany dostęp, nieistniejące zasoby. Uruchamiam je w izolowanej bazie SQLite, żeby nie dotykać dev MySQL.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-01-blog-api';

-- feature-01-blog-api [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Blog API — posts, categories, tags, comments', 'Time for the first real API. Blog Service got a full set of endpoints — from posts through categories and tags to comments with moderation. Everything protected by a custom JWT guard.',
         'Time for the first real API. Blog Service got a full set of endpoints — from posts through categories and tags to comments with moderation. Everything protected by a custom JWT guard.

**Service: Blog**

## JWT Authorization

No sessions — stateless JWT. I wrote a custom guard that reads the token from the `Authorization: Bearer` header, verifies the signature, and injects the user into the request context. Blog Service has no user accounts of its own — the token comes from SSO.

Public routes are accessible without a token, mutations require authentication:

```php
// routes/api.php
Route::get(\'/posts\', [PostController::class, \'index\']);
Route::get(\'/posts/{id}\', [PostController::class, \'show\']);
Route::middleware(\'auth:jwt\')->group(function () {
    Route::post(\'/posts\', [PostController::class, \'store\']);
    Route::put(\'/posts/{id}\', [PostController::class, \'update\']);
    Route::delete(\'/posts/{id}\', [PostController::class, \'destroy\']);
});
```

## Posts with pagination and filtering

The `GET /posts` endpoint supports pagination and slug-based filtering. Thanks to slug filtering, Frontend can fetch a single post without knowing its ID — a friendly URL is enough.

```
GET /posts?slug=my-post-about-laravel
GET /posts?page=2&per_page=10
```

The response always returns pagination metadata: `current_page`, `last_page`, `total`. Frontend knows when the results run out.

## Hierarchical categories

Categories support a tree structure — each category can have a parent. In the database it\'s a `parent_id` column with a self-referencing relation. The API returns categories flat or nested — depending on the `?nested=true` parameter.

## Tags

Tag CRUD is a simple API. Each post can have many tags (many-to-many relation). I added a bulk endpoint for assigning tags to a post in a single request instead of N separate calls.

## Comments with moderation

Comments have their own set of endpoints, including moderator routes. A moderator can approve, reject, or delete a comment. Moderator endpoints require a JWT token with the appropriate role — verified by the guard.

```
POST   /posts/{id}/comments
GET    /posts/{id}/comments
DELETE /comments/{id}           # moderator
PATCH  /comments/{id}/approve   # moderator
```

## Tests

Each module has feature tests — posts, categories, tags, comments. Tests cover success and error paths: missing fields, unauthorized access, non-existent resources. I run them against an isolated SQLite database to avoid touching dev MySQL.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-01-blog-api';

-- feature-02-oauth2-sso [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Serwer autoryzacji OAuth2 z Laravel Passport', 'SSO dostał swój rdzeń — serwer OAuth2 oparty na Laravel Passport. Od tej chwili każdy serwis w systemie autoryzuje się przez jeden centralny punkt. Koniec z rozproszonymi tabelami `users` i osobnymi mechanizmami logowania.',
         'SSO dostał swój rdzeń — serwer OAuth2 oparty na **Laravel Passport**. Od tej chwili każdy serwis w systemie autoryzuje się przez jeden centralny punkt. Koniec z rozproszonymi tabelami `users` i osobnymi mechanizmami logowania.

**Serwis: SSO**

## Dlaczego Passport, nie Sanctum

Sanctum świetnie nadaje się do prostych SPA z sesją cookie. Potrzebowałem jednak pełnego serwera OAuth2 — z authorization code flow, tokenami odświeżającymi i możliwością wystawiania tokenów dla zewnętrznych klientów. Passport implementuje RFC 6749 out of the box.

## Authorization Code Flow z PKCE

PKCE (Proof Key for Code Exchange) eliminuje ryzyko przechwycenia kodu autoryzacji. Frontend generuje `code_verifier` i `code_challenge` przed przekierowaniem do SSO. SSO weryfikuje parę przy wymianie kodu na token.

> PKCE jest obowiązkowy dla publicznych klientów (SPA, mobile) — bez niego authorization code flow jest podatny na atak CSRF.

Flow wygląda następująco:
1. Frontend generuje `code_verifier` i `code_challenge` (SHA-256)
2. Przekierowanie do `/oauth/authorize?code_challenge=...&code_challenge_method=S256`
3. Po zalogowaniu SSO zwraca `code` do callbacku
4. Frontend wymienia `code` + `code_verifier` na access token

## Endpoint `/api/user`

Po uzyskaniu tokenu Frontend pobiera dane zalogowanego użytkownika:

```
GET /api/user
Authorization: Bearer <access_token>
```

Odpowiedź zawiera ID, email, imię i nazwisko oraz role. To jedyny endpoint aplikacyjny w SSO — reszta to endpointy Passport.

## Seedery klientów OAuth2

Przy inicjalizacji środowiska seeder tworzy klientów OAuth2 dla Frontendu i Admina. Każdy klient ma skonfigurowany redirect URI i odpowiednie uprawnienia.

```php
// Przykład konfiguracji klienta OAuth2
Passport::client()->create([
    \'name\'                   => \'Frontend\',
    \'redirect\'               => env(\'FRONTEND_URL\') . \'/auth/callback\',
    \'personal_access_client\' => false,
    \'password_client\'        => false,
    \'revoked\'                => false,
]);
```

Seeder można uruchomić wielokrotnie — sprawdza istnienie klienta po nazwie przed utworzeniem. Wartości `client_id` i `client_secret` trafiają do zmiennych środowiskowych pozostałych serwisów.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-02-oauth2-sso';

-- feature-02-oauth2-sso [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'OAuth2 Authorization Server with Laravel Passport', 'SSO got its core — an OAuth2 server built on Laravel Passport. From now on, every service in the system authenticates through a single central point. No more scattered `users` tables and separate login mechanisms.',
         'SSO got its core — an OAuth2 server built on **Laravel Passport**. From now on, every service in the system authenticates through a single central point. No more scattered `users` tables and separate login mechanisms.

**Service: SSO**

## Why Passport, not Sanctum

Sanctum works great for simple SPAs with cookie sessions. But I needed a full OAuth2 server — with authorization code flow, refresh tokens, and the ability to issue tokens for external clients. Passport implements RFC 6749 out of the box.

## Authorization Code Flow with PKCE

PKCE (Proof Key for Code Exchange) eliminates the risk of authorization code interception. Frontend generates `code_verifier` and `code_challenge` before redirecting to SSO. SSO verifies the pair when exchanging the code for a token.

> PKCE is mandatory for public clients (SPA, mobile) — without it, authorization code flow is vulnerable to CSRF attacks.

The flow looks like this:
1. Frontend generates `code_verifier` and `code_challenge` (SHA-256)
2. Redirect to `/oauth/authorize?code_challenge=...&code_challenge_method=S256`
3. After login, SSO returns a `code` to the callback
4. Frontend exchanges `code` + `code_verifier` for an access token

## The `/api/user` endpoint

After obtaining the token, Frontend fetches the logged-in user\'s data:

```
GET /api/user
Authorization: Bearer <access_token>
```

The response contains ID, email, full name, and roles. This is the only application endpoint in SSO — the rest are Passport endpoints.

## OAuth2 client seeders

When the environment is initialized, a seeder creates OAuth2 clients for Frontend and Admin. Each client has a configured redirect URI and appropriate permissions.

```php
// OAuth2 client configuration example
Passport::client()->create([
    \'name\'                   => \'Frontend\',
    \'redirect\'               => env(\'FRONTEND_URL\') . \'/auth/callback\',
    \'personal_access_client\' => false,
    \'password_client\'        => false,
    \'revoked\'                => false,
]);
```

The seeder can be run multiple times — it checks for the client by name before creating. The `client_id` and `client_secret` values go into environment variables of other services.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-02-oauth2-sso';

-- feature-03-rabbitmq-users [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'RabbitMQ i wewnętrzne API serwisów', 'Serwisy zaczęły ze sobą rozmawiać. Nie przez wspólną bazę danych — przez kolejkę komunikatów i dedykowane wewnętrzne API. To krok, który oddziela synchroniczne wywołania od asynchronicznych zdarzeń.',
         'Serwisy zaczęły ze sobą rozmawiać. Nie przez wspólną bazę danych — przez kolejkę komunikatów i dedykowane wewnętrzne API. To krok, który oddziela synchroniczne wywołania od asynchronicznych zdarzeń.

**Serwisy: Users, Blog**

## Wewnętrzne API Users dla SSO

SSO musi pobierać dane użytkownika przy każdym żądaniu do `/api/user`. Zamiast wspólnej bazy danych — **Users** udostępnia wewnętrzne API chronione kluczem API. Tylko SSO zna ten klucz. Komunikacja odbywa się wewnątrz sieci Dockera, port nie jest eksponowany na zewnątrz.

```
GET /internal/users/{id}
X-Api-Key: <service-key>
```

Odpowiedź zawiera pełny profil użytkownika z rolami. SSO dokłada te dane do odpowiedzi `/api/user`.

## Zdarzenia RabbitMQ z Users

Kiedy stan użytkownika się zmienia — rejestracja, aktualizacja profilu, zmiana roli — **Users** publikuje zdarzenie do RabbitMQ. Inne serwisy subskrybują i reagują asynchronicznie.

```php
// Publikowanie zdarzenia
$this->rabbitMQ->publish(\'user.updated\', [
    \'id\'    => $user->id,
    \'email\' => $user->email,
    \'name\'  => $user->name,
]);
```

Zdarzenia używają routingu opartego na topic exchange. Klucz `user.updated` trafia do wszystkich kolejek, które subskrybują `user.*`.

## Consumer w Blog Service

**Blog** nasłuchuje na zdarzenia `user.*` i synchronizuje dane autorów lokalnie. Dzięki temu Blog nie odpytuje Users przy każdym żądaniu — ma własną tabelę `authors` zaktualizowaną przez consumera.

Jeśli użytkownik zmieni imię w Users, consumer w Blog zaktualizuje rekord autora automatycznie. Zero zapytań cross-serwisowych w ścieżce żądania.

## OAuth2 flow w Frontend

Frontend dostał pełny przepływ OAuth2 — od przycisku "Zaloguj się" do przechowywania tokenu w sesji. Kroki:

1. Generowanie `code_verifier` i `code_challenge`
2. Przekierowanie do SSO `/oauth/authorize`
3. Odbiór kodu w `/auth/callback`
4. Wymiana kodu na token przez SSO
5. Zapis access tokenu i refresh tokenu w sesji Redis

> Refresh token jest przechowywany tylko po stronie serwera w Redis — nigdy nie trafia do przeglądarki. Access token ma krótki TTL, refresh token jest długożyciowy.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-03-rabbitmq-users';

-- feature-03-rabbitmq-users [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'RabbitMQ and internal service APIs', 'Services started talking to each other. Not through a shared database — through a message queue and dedicated internal APIs. This is the step that separates synchronous calls from asynchronous events.',
         'Services started talking to each other. Not through a shared database — through a message queue and dedicated internal APIs. This is the step that separates synchronous calls from asynchronous events.

**Services: Users, Blog**

## Internal Users API for SSO

SSO needs to fetch user data on every request to `/api/user`. Instead of a shared database — **Users** exposes an internal API protected by an API key. Only SSO knows this key. Communication happens inside the Docker network; the port is not exposed externally.

```
GET /internal/users/{id}
X-Api-Key: <service-key>
```

The response contains the full user profile with roles. SSO appends this data to the `/api/user` response.

## RabbitMQ events from Users

When a user\'s state changes — registration, profile update, role change — **Users** publishes an event to RabbitMQ. Other services subscribe and react asynchronously.

```php
// Publishing an event
$this->rabbitMQ->publish(\'user.updated\', [
    \'id\'    => $user->id,
    \'email\' => $user->email,
    \'name\'  => $user->name,
]);
```

Events use topic exchange-based routing. The key `user.updated` reaches all queues that subscribe to `user.*`.

## Consumer in Blog Service

**Blog** listens for `user.*` events and synchronizes author data locally. This way Blog doesn\'t query Users on every request — it has its own `authors` table updated by the consumer.

If a user changes their name in Users, the consumer in Blog updates the author record automatically. Zero cross-service queries in the request path.

## OAuth2 flow in Frontend

Frontend got the full OAuth2 flow — from the "Log in" button to storing the token in the session. Steps:

1. Generate `code_verifier` and `code_challenge`
2. Redirect to SSO `/oauth/authorize`
3. Receive code at `/auth/callback`
4. Exchange code for token via SSO
5. Save access token and refresh token to Redis session

> The refresh token is stored server-side only in Redis — it never reaches the browser. The access token has a short TTL, the refresh token is long-lived.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-03-rabbitmq-users';

-- article-02-traefik-reverse-proxy [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Traefik v3 jako reverse proxy — routing, TLS i dashboard w praktyce', 'Czym jest Traefik?',
         '## Czym jest Traefik?

Traefik to nowoczesny reverse proxy i load balancer, który odróżnia się od Nginx tym, że **konfiguruje się dynamicznie**. Zamiast ręcznie pisać bloki `server {}`, Traefik czyta labele z kontenerów Dockera i sam buduje routing.

## Podstawowa konfiguracja

W `docker-compose.prod.yml` Traefik uruchamiam jako pierwszy serwis:

```yaml
traefik:
  image: traefik:v3.6
  command:
    - "--entrypoints.web.address=:80"
    - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
    - "--entrypoints.websecure.address=:443"
    - "--entrypoints.websecure.http.tls=true"
    - "--providers.docker=true"
    - "--providers.docker.exposedbydefault=false"
    - "--providers.file.filename=/etc/traefik/dynamic/traefik_dynamic.yml"
```

Kluczowe decyzje:
- `exposedbydefault=false` — serwis musi explicite dodać label `traefik.enable=true`, żeby być wystawiony
- Redirect z HTTP na HTTPS jest globalny, jeden wpis, działa dla wszystkich serwisów

## Routing przez labele

Każdy serwis, który chcę wystawić publicznie, dostaje etykiety:

```yaml
frontend:
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.frontend.rule=Host(`portfolio.example.com`)"
    - "traefik.http.routers.frontend.entrypoints=websecure"
    - "traefik.http.routers.frontend.tls=true"
    - "traefik.http.services.frontend.loadbalancer.server.port=80"
```

Serwisy wewnętrzne (Blog API, Users API) są w osobnej sieci i nie mają tych labeli — dostępne tylko z sieci `microservices`.

## TLS z własnymi certyfikatami

W projekcie używam własnych certyfikatów (dev) lub Let\'s Encrypt (produkcja). Konfiguracja TLS jest w pliku dynamicznym:

```yaml
# infra/dynamic/traefik_dynamic.yml
tls:
  certificates:
    - certFile: /certs/cert.pem
      keyFile: /certs/key.pem
  stores:
    default:
      defaultCertificate:
        certFile: /certs/cert.pem
        keyFile: /certs/key.pem
```

## Dashboard

Dashboard Traefika jest bardzo przydatny do debugowania — pokazuje aktywne routery, serwisy i middleware. Zabezpieczam go osobną domeną z Basic Auth przez middleware:

```yaml
- "traefik.http.routers.dashboard.rule=Host(`traefik.example.com`)"
- "traefik.http.routers.dashboard.middlewares=auth@file"
```

## Co mi się podoba w Traefikie?

Największy plus to **zero restartów przy zmianie konfiguracji**. Dodam nowy kontener z odpowiednimi labelami, Traefik wykryje go w ciągu sekund i zacznie routować ruch. W Nginx musiałbym edytować plik konfiguracyjny i przeładować serwis.

Minusem jest krzywa uczenia się — składnia labeli jest specyficzna i łatwo o literówkę, która cicho nic nie robi.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-02-traefik-reverse-proxy';

-- article-02-traefik-reverse-proxy [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Traefik v3 as a reverse proxy — routing, TLS and dashboard in practice', 'What is Traefik?',
         '## What is Traefik?

Traefik is a modern reverse proxy and load balancer that differs from Nginx in that it **configures itself dynamically**. Instead of manually writing `server {}` blocks, Traefik reads labels from Docker containers and builds the routing on its own.

## Basic configuration

In `docker-compose.prod.yml` I start Traefik as the first service:

```yaml
traefik:
  image: traefik:v3.6
  command:
    - "--entrypoints.web.address=:80"
    - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
    - "--entrypoints.websecure.address=:443"
    - "--entrypoints.websecure.http.tls=true"
    - "--providers.docker=true"
    - "--providers.docker.exposedbydefault=false"
    - "--providers.file.filename=/etc/traefik/dynamic/traefik_dynamic.yml"
```

Key decisions:
- `exposedbydefault=false` — a service must explicitly add the label `traefik.enable=true` to be exposed
- The HTTP-to-HTTPS redirect is global — a single entry that works for all services

## Routing via labels

Every service I want to expose publicly gets labels:

```yaml
frontend:
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.frontend.rule=Host(`portfolio.example.com`)"
    - "traefik.http.routers.frontend.entrypoints=websecure"
    - "traefik.http.routers.frontend.tls=true"
    - "traefik.http.services.frontend.loadbalancer.server.port=80"
```

Internal services (Blog API, Users API) are on a separate network and do not have these labels — they are only accessible from the `microservices` network.

## TLS with custom certificates

In the project I use custom certificates (dev) or Let\'s Encrypt (production). The TLS configuration lives in a dynamic file:

```yaml
# infra/dynamic/traefik_dynamic.yml
tls:
  certificates:
    - certFile: /certs/cert.pem
      keyFile: /certs/key.pem
  stores:
    default:
      defaultCertificate:
        certFile: /certs/cert.pem
        keyFile: /certs/key.pem
```

## Dashboard

The Traefik dashboard is very useful for debugging — it shows active routers, services, and middleware. I secure it with a separate domain using Basic Auth via middleware:

```yaml
- "traefik.http.routers.dashboard.rule=Host(`traefik.example.com`)"
- "traefik.http.routers.dashboard.middlewares=auth@file"
```

## What I like about Traefik

The biggest plus is **zero restarts when the configuration changes**. I add a new container with the appropriate labels, Traefik detects it within seconds, and starts routing traffic. With Nginx I would have to edit a configuration file and reload the service.

The downside is the learning curve — the label syntax is specific and it is easy to make a typo that silently does nothing.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-02-traefik-reverse-proxy';

-- feature-04-admin-rbac [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Panel administracyjny FilamentPHP i system ról RBAC', 'System zarządzania potrzebuje panelu. Zamiast budować go od zera — FilamentPHP. Jednocześnie Users dostał pełny system ról i uprawnień, który jest punktem odniesienia dla wszystkich serwisów.',
         'System zarządzania potrzebuje panelu. Zamiast budować go od zera — **FilamentPHP**. Jednocześnie **Users** dostał pełny system ról i uprawnień, który jest punktem odniesienia dla wszystkich serwisów.

**Serwisy: Admin, Users**

## FilamentPHP jako panel admina

**FilamentPHP** to biblioteka dla Laravela, która generuje bogaty panel administracyjny z minimalną ilością kodu. Resources, tabele, formularze, filtry — wszystko deklaratywne. Wybrałem go, bo chciałem skupić się na logice biznesowej, a nie na budowaniu kolejnego CRUDa ręcznie.

Panel działa pod osobną domeną (`admin.portfolio.local` lokalnie), jako oddzielny serwis Dockera z własną bazą danych.

## Logowanie przez SSO, nie własny formularz

Admin nie ma własnego systemu logowania. Kliknięcie "Zaloguj się" przekierowuje do **SSO** — ten sam OAuth2 flow co Frontend. Po powrocie z tokenem Filament weryfikuje, czy użytkownik ma rolę `admin`, i wpuszcza do panelu.

> Dzięki temu jedno konto = dostęp do wszystkich serwisów. Zmiana hasła w jednym miejscu działa wszędzie.

Wymagało to napisania własnego providera uwierzytelniania dla Filament, który zamiast sprawdzać bazę lokalną, odpytuje SSO przez token.

## RBAC w Users Service

**Users** dostał model ról i uprawnień. Każdy użytkownik może mieć jedną lub więcej ról. Każda rola ma zestaw uprawnień. Role to np.: `admin`, `editor`, `moderator`, `user`.

Struktura w bazie danych:
- `roles` — lista ról
- `permissions` — lista uprawnień
- `role_permissions` — przypisanie uprawnień do ról
- `user_roles` — przypisanie ról do użytkowników

Token JWT emitowany przez SSO zawiera role użytkownika jako claim. Każdy serwis odczytuje role z tokenu bez odpytywania Users.

## Panel użytkownika we Frontend

Frontend dostał sidebar z menu dla zalogowanych użytkowników. Elementy menu zależą od roli — moderator widzi więcej opcji niż zwykły użytkownik. Widoki renderowane server-side na podstawie danych z sesji.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-04-admin-rbac';

-- feature-04-admin-rbac [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'FilamentPHP admin panel and RBAC role system', 'A management system needs a panel. Instead of building one from scratch — FilamentPHP. At the same time, Users got a full role and permission system that serves as the reference point for all services.',
         'A management system needs a panel. Instead of building one from scratch — **FilamentPHP**. At the same time, **Users** got a full role and permission system that serves as the reference point for all services.

**Services: Admin, Users**

## FilamentPHP as the admin panel

**FilamentPHP** is a Laravel library that generates a rich admin panel with minimal code. Resources, tables, forms, filters — all declarative. I chose it because I wanted to focus on business logic, not building yet another CRUD by hand.

The panel runs under a separate domain (`admin.portfolio.local` locally), as a separate Docker service with its own database.

## Login through SSO, not a custom form

Admin has no login system of its own. Clicking "Log in" redirects to **SSO** — the same OAuth2 flow as Frontend. After returning with a token, Filament checks whether the user has the `admin` role and lets them into the panel.

> This means one account = access to all services. Changing a password in one place works everywhere.

This required writing a custom authentication provider for Filament that, instead of checking a local database, queries SSO through the token.

## RBAC in Users Service

**Users** got a role and permission model. Each user can have one or more roles. Each role has a set of permissions. Roles include: `admin`, `editor`, `moderator`, `user`.

Database structure:
- `roles` — list of roles
- `permissions` — list of permissions
- `role_permissions` — permission-to-role assignments
- `user_roles` — role-to-user assignments

The JWT token issued by SSO contains the user\'s roles as a claim. Each service reads roles from the token without querying Users.

## User panel in Frontend

Frontend got a sidebar with a menu for logged-in users. Menu items depend on role — a moderator sees more options than a regular user. Views rendered server-side based on session data.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-04-admin-rbac';

-- article-03-oauth2-sso-passport [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'OAuth2 SSO od zera z Laravel Passport — jak to działa pod maską', 'Po co własne SSO?',
         '## Po co własne SSO?

W systemie mam kilku klientów, którzy potrzebują uwierzytelniania: Frontend, Admin. Zamiast duplikować logikę logowania w każdym serwisie, wyodrębniłem ją do osobnego mikroserwisu SSO opartego na OAuth2.

Benefity:
- Jeden punkt zarządzania sesjami i tokenami
- Zmiana hasła w jednym miejscu → wszystkie klienty dotknięte
- Możliwość dodania 2FA, social login itp. bez zmian w klientach

## Laravel Passport jako serwer OAuth2

Laravel Passport to pełna implementacja OAuth2 na bazie `league/oauth2-server`. Wspiera grant types: Authorization Code, Client Credentials, Password (deprecated), Refresh Token.

W moim projekcie używam **Authorization Code z PKCE** — najbezpieczniejszy flow dla aplikacji webowych.

## Jak wygląda flow?

```
1. Użytkownik klika "Zaloguj się" na Frontend
2. Frontend przekierowuje na SSO: /oauth/authorize?client_id=...&redirect_uri=...&code_challenge=...
3. SSO pokazuje stronę logowania
4. Użytkownik podaje dane → SSO weryfikuje przez Users API
5. SSO przekierowuje z powrotem: /oauth/callback?code=AUTH_CODE
6. Frontend wymienia AUTH_CODE na access_token + refresh_token (POST /oauth/token)
7. access_token trafia do sesji, używany do wywołań API
```

## Weryfikacja hasła przez Users API

SSO nie ma własnej bazy użytkowników — deleguje weryfikację do Users API przez internal endpoint:

```php
// SSO AuthController
$response = Http::withHeaders([
    \'X-Internal-Api-Key\' => config(\'services.users.internal_key\'),
])->post(config(\'services.users.url\') . \'/api/internal/verify-password\', [
    \'email\' => $request->email,
    \'password\' => $request->password,
]);
```

Dzięki temu Users jest jedynym serwisem, który "zna" hasła. SSO tylko pyta.

## Refresh token i wygasanie sesji

access_token wygasa po 1 godzinie. Przy każdym żądaniu do API frontend sprawdza czy token nie wygasł i w razie potrzeby odpytuje SSO o nowy token przy pomocy refresh_token.

```php
if ($this->isTokenExpired($session->get(\'expires_at\'))) {
    $newTokens = $this->refreshAccessToken($session->get(\'refresh_token\'));
    $session->put(\'access_token\', $newTokens[\'access_token\']);
}
```

## Klient Admin (FilamentPHP)

Admin panel używa tego samego SSO — zaimplementowałem osobny OAuth2 client z `redirect_uri` wskazującym na domenę admina. Filament dostaje token i robi API calls z Bearer auth.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-03-oauth2-sso-passport';

-- article-03-oauth2-sso-passport [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'OAuth2 SSO from scratch with Laravel Passport — how it works under the hood', 'Why build your own SSO?',
         '## Why build your own SSO?

My system has several clients that need authentication: Frontend, Admin. Instead of duplicating login logic in every service, I extracted it into a separate SSO microservice based on OAuth2.

Benefits:
- A single point for managing sessions and tokens
- Changing a password in one place → all clients affected
- Ability to add 2FA, social login, etc. without changes to the clients

## Laravel Passport as an OAuth2 server

Laravel Passport is a full OAuth2 implementation built on top of `league/oauth2-server`. It supports grant types: Authorization Code, Client Credentials, Password (deprecated), Refresh Token.

In my project I use **Authorization Code with PKCE** — the most secure flow for web applications.

## What does the flow look like?

```
1. User clicks "Log in" on Frontend
2. Frontend redirects to SSO: /oauth/authorize?client_id=...&redirect_uri=...&code_challenge=...
3. SSO displays the login page
4. User submits credentials → SSO verifies through Users API
5. SSO redirects back: /oauth/callback?code=AUTH_CODE
6. Frontend exchanges AUTH_CODE for access_token + refresh_token (POST /oauth/token)
7. access_token is stored in the session and used for API calls
```

## Password verification through Users API

SSO does not have its own user database — it delegates verification to the Users API via an internal endpoint:

```php
// SSO AuthController
$response = Http::withHeaders([
    \'X-Internal-Api-Key\' => config(\'services.users.internal_key\'),
])->post(config(\'services.users.url\') . \'/api/internal/verify-password\', [
    \'email\' => $request->email,
    \'password\' => $request->password,
]);
```

This way Users is the only service that "knows" the passwords. SSO just asks.

## Refresh token and session expiration

The access_token expires after 1 hour. On every request to the API the frontend checks whether the token has expired and, if needed, requests a new token from SSO using the refresh_token.

```php
if ($this->isTokenExpired($session->get(\'expires_at\'))) {
    $newTokens = $this->refreshAccessToken($session->get(\'refresh_token\'));
    $session->put(\'access_token\', $newTokens[\'access_token\']);
}
```

## Admin client (FilamentPHP)

The Admin panel uses the same SSO — I implemented a separate OAuth2 client with a `redirect_uri` pointing to the admin domain. Filament receives the token and makes API calls with Bearer auth.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-03-oauth2-sso-passport';

-- feature-05-kubernetes [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Manifesty Kubernetes i produkcyjne Dockerfile', 'Dev działa na Docker Compose — ale produkcja to Kubernetes. Napisałem manifesty K8s dla każdego serwisu i przeprojektowałem Dockerfile pod realia produkcyjne: multi-stage build, health checki, graceful shutdown.',
         'Dev działa na Docker Compose — ale produkcja to Kubernetes. Napisałem manifesty K8s dla każdego serwisu i przeprojektowałem Dockerfile pod realia produkcyjne: multi-stage build, health checki, graceful shutdown.

**Serwisy: wszystkie**

## Manifesty K8s — jeden zestaw na serwis

Każdy serwis ma własny katalog `k8s/` z kompletem plików:

- `deployment.yaml` — definicja poda, limity zasobów, zmienne środowiskowe
- `service.yaml` — ClusterIP do komunikacji wewnętrznej
- `configmap.yaml` — konfiguracja nieczuła (APP_ENV, LOG_CHANNEL)
- `secret.yaml` — szablony na hasła i klucze API
- `ingress.yaml` — routing HTTP z cert-manager

Separacja ConfigMap i Secret to nie tylko kwestia bezpieczeństwa — ułatwia rotację sekretów bez wdrażania aplikacji.

## InitContainers — migracje przed startem

Główny kontener startuje dopiero po wykonaniu migracji bazy danych. Robi to InitContainer uruchamiający `php artisan migrate --force` z tego samego obrazu co aplikacja.

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/blog:latest
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secret
```

Dzięki temu nie ma sytuacji, w której nowy pod startuje z nieaktualnym schematem bazy.

## Health checki — `/health` i `/ready`

Każdy serwis ma dwa endpointy:

- `GET /health` — liveness probe: "czy aplikacja żyje"
- `GET /ready` — readiness probe: "czy aplikacja jest gotowa na ruch"

`/ready` sprawdza połączenie z bazą danych i Redis. Dopiero gdy oba działają, K8s kieruje ruch do poda.

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 5
```

## Graceful shutdown — preStop hook w Nginx

Kubernetes wysyła `SIGTERM` do kontenera gdy go kończy. PHP-FPM potrzebuje chwili na dokończenie aktywnych żądań. Nginx dostał `preStop` hook z krótkim opóźnieniem:

```yaml
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh", "-c", "sleep 5 && nginx -s quit"]
```

Pięć sekund wystarczy, żeby K8s skończył przesyłanie nowych połączeń do poda przed jego zamknięciem.

## Hardened Dockerfile multi-stage

Obraz produkcyjny budowany jest w dwóch etapach: builder (z Composerem i zależnościami dev) i runtime (tylko artefakty produkcyjne). Finalny obraz nie zawiera Composera ani żadnych narzędzi deweloperskich.

```dockerfile
FROM php:8.3-fpm-alpine AS builder
# instalacja zależności, composer install --no-dev

FROM php:8.3-fpm-alpine AS runtime
# tylko pliki z buildera, bez narzędzi
COPY --from=builder /app /app
```

Wynikowy obraz jest mniejszy i ma mniejszą powierzchnię ataku.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-05-kubernetes';

-- feature-05-kubernetes [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Kubernetes manifests and production Dockerfiles', 'Dev runs on Docker Compose — but production is Kubernetes. I wrote K8s manifests for every service and redesigned the Dockerfiles for production realities: multi-stage build, health checks, graceful shutdown.',
         'Dev runs on Docker Compose — but production is Kubernetes. I wrote K8s manifests for every service and redesigned the Dockerfiles for production realities: multi-stage build, health checks, graceful shutdown.

**Services: all**

## K8s manifests — one set per service

Each service has its own `k8s/` directory with a complete set of files:

- `deployment.yaml` — pod definition, resource limits, environment variables
- `service.yaml` — ClusterIP for internal communication
- `configmap.yaml` — non-sensitive configuration (APP_ENV, LOG_CHANNEL)
- `secret.yaml` — templates for passwords and API keys
- `ingress.yaml` — HTTP routing with cert-manager

Separating ConfigMap and Secret is not just a security matter — it makes secret rotation easier without redeploying the application.

## InitContainers — migrations before startup

The main container only starts after database migrations have run. An InitContainer handles this by running `php artisan migrate --force` from the same image as the application.

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/blog:latest
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secret
```

This prevents a situation where a new pod starts with an outdated database schema.

## Health checks — `/health` and `/ready`

Each service has two endpoints:

- `GET /health` — liveness probe: "is the application alive"
- `GET /ready` — readiness probe: "is the application ready for traffic"

`/ready` checks the database and Redis connections. Only when both are working does K8s route traffic to the pod.

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 5
```

## Graceful shutdown — preStop hook in Nginx

Kubernetes sends `SIGTERM` to the container when terminating it. PHP-FPM needs a moment to finish active requests. Nginx got a `preStop` hook with a short delay:

```yaml
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh", "-c", "sleep 5 && nginx -s quit"]
```

Five seconds is enough for K8s to stop forwarding new connections to the pod before shutting it down.

## Hardened multi-stage Dockerfile

The production image is built in two stages: builder (with Composer and dev dependencies) and runtime (only production artifacts). The final image contains neither Composer nor any development tools.

```dockerfile
FROM php:8.3-fpm-alpine AS builder
# install dependencies, composer install --no-dev

FROM php:8.3-fpm-alpine AS runtime
# only files from builder, no tools
COPY --from=builder /app /app
```

The resulting image is smaller and has a reduced attack surface.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-05-kubernetes';

-- article-04-docker-multi-stage [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Multi-stage Docker builds — Alpine, hardening i minimalne obrazy produkcyjne', 'Problem z prostymi Dockerfile',
         '## Problem z prostymi Dockerfile

Naiwny Dockerfile dla aplikacji Laravel:

```dockerfile
FROM php:8.5-fpm
RUN apt-get install -y git zip unzip nodejs npm
COPY . /var/www
RUN composer install
RUN npm install && npm run build
```

Wynikowy obraz: ~1.2 GB. Zawiera narzędzia build-time (git, npm, composer) których produkcja nie potrzebuje.

## Multi-stage build — podział na etapy

```dockerfile
# Etap 1: build assets (Node.js)
FROM node:22-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY resources/ resources/
COPY vite.config.js ./
RUN npm run build

# Etap 2: install PHP dependencies
FROM composer:2 AS composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Etap 3: obraz produkcyjny
FROM php:8.5-fpm-alpine AS production
WORKDIR /var/www

# Kopiujemy tylko artefakty z poprzednich etapów
COPY --from=composer /app/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
COPY . .

RUN chown -R www-data:www-data /var/www
USER www-data
```

Wynikowy obraz: ~180 MB — 85% mniej.

## Hardening kontenera

Kilka zasad bezpieczeństwa, które stosuję:

**Non-root user:**
```dockerfile
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser
```

**Read-only filesystem (tam gdzie możliwe):**
```yaml
# docker-compose.prod.yml
security_opt:
  - no-new-privileges:true
read_only: true
tmpfs:
  - /tmp
  - /var/run
```

**Minimalny obraz — Alpine zamiast Debian:**
Alpine Linux ma ~5 MB w porównaniu do ~80 MB Debiana. Mniej pakietów = mniejsza powierzchnia ataku.

**STOPSIGNAL SIGQUIT dla PHP-FPM:**
```dockerfile
STOPSIGNAL SIGQUIT
```
PHP-FPM na SIGQUIT robi graceful shutdown — dokańcza aktywne requesty zanim się wyłączy. Bez tego K8s mógłby zabić kontener w trakcie obsługi requestu.

## OCI labels dla trackowalności

```dockerfile
LABEL org.opencontainers.image.version="0.0.4"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/szymonborowski/portfolio"
```

Dzięki temu patrząc na działający kontener wiem dokładnie z jakiego commitu pochodzi.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-04-docker-multi-stage';

-- article-04-docker-multi-stage [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Multi-stage Docker builds — Alpine, hardening and minimal production images', 'The problem with simple Dockerfiles',
         '## The problem with simple Dockerfiles

A naive Dockerfile for a Laravel application:

```dockerfile
FROM php:8.5-fpm
RUN apt-get install -y git zip unzip nodejs npm
COPY . /var/www
RUN composer install
RUN npm install && npm run build
```

Resulting image: ~1.2 GB. It contains build-time tools (git, npm, composer) that production does not need.

## Multi-stage build — splitting into stages

```dockerfile
# Stage 1: build assets (Node.js)
FROM node:22-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY resources/ resources/
COPY vite.config.js ./
RUN npm run build

# Stage 2: install PHP dependencies
FROM composer:2 AS composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Stage 3: production image
FROM php:8.5-fpm-alpine AS production
WORKDIR /var/www

# Copy only the artifacts from previous stages
COPY --from=composer /app/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
COPY . .

RUN chown -R www-data:www-data /var/www
USER www-data
```

Resulting image: ~180 MB — 85% smaller.

## Container hardening

A few security principles I follow:

**Non-root user:**
```dockerfile
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser
```

**Read-only filesystem (where possible):**
```yaml
# docker-compose.prod.yml
security_opt:
  - no-new-privileges:true
read_only: true
tmpfs:
  - /tmp
  - /var/run
```

**Minimal image — Alpine instead of Debian:**
Alpine Linux is ~5 MB compared to ~80 MB for Debian. Fewer packages = smaller attack surface.

**STOPSIGNAL SIGQUIT for PHP-FPM:**
```dockerfile
STOPSIGNAL SIGQUIT
```
PHP-FPM performs a graceful shutdown on SIGQUIT — it finishes active requests before shutting down. Without this, K8s could kill the container in the middle of handling a request.

## OCI labels for traceability

```dockerfile
LABEL org.opencontainers.image.version="0.0.4"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/szymonborowski/portfolio"
```

This way, when looking at a running container I know exactly which commit it came from.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-04-docker-multi-stage';

-- feature-06-analytics [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Mikroserwis analityki — śledzenie wyświetleń przez RabbitMQ', 'Nowy serwis w systemie — Analytics. Jego jedynym zadaniem jest zbieranie zdarzeń i produkowanie statystyk. Nie ma publicznego API — komunikuje się wyłącznie przez kolejkę RabbitMQ.',
         'Nowy serwis w systemie — **Analytics**. Jego jedynym zadaniem jest zbieranie zdarzeń i produkowanie statystyk. Nie ma publicznego API — komunikuje się wyłącznie przez kolejkę RabbitMQ.

**Serwisy: Analytics, Frontend**

## Architektura bez publicznego API

Większość serwisów analitycznych to REST API, do których Frontend wysyła dane POST-em. Wybrałem inne podejście: Frontend publikuje zdarzenie do RabbitMQ, Analytics go konsumuje w tle. Zyski:

- Frontend nie czeka na odpowiedź (fire-and-forget)
- Analytics może nie działać chwilowo bez straty zdarzeń — kolejka je buforuje
- Łatwe skalowanie consumera niezależnie od Frontendu

## Wysyłanie zdarzenia z Frontend

Po wyświetleniu posta Frontend publikuje zdarzenie `post.viewed`:

```php
// Frontend — wysłanie zdarzenia
$this->analyticsApi->trackView([
    \'post_id\'    => $post->id,
    \'user_id\'    => auth()->id(),
    \'ip\'         => request()->ip(),
    \'user_agent\' => request()->userAgent(),
]);
```

`analyticsApi` to wrapper nad klientem RabbitMQ. Serializuje payload i wysyła do odpowiedniej kolejki. Jeśli użytkownik nie jest zalogowany, `user_id` jest null — zdarzenie i tak trafia do systemu.

## Consumer w Analytics

**Analytics** uruchamia worker nasłuchujący na kolejce `post.viewed`. Każde zdarzenie trafia do tabeli `post_views` z timestampem, IP i user agentem.

Serwis agreguje statystyki: liczba wyświetleń per post, unikalne wyświetlenia (deduplikacja po IP + post_id w oknie czasowym), trend dzienny.

## Statystyki w panelu admina

**Admin** odpytuje Analytics przez wewnętrzne API (chronione kluczem API). Na stronie posta wyświetlana jest liczba wyświetleń, wykres trendu i podział na zalogowanych/anonimowych czytelników.

> Dane analityczne są read-only z perspektywy Admina — panel nie modyfikuje historii zdarzeń, tylko ją wyświetla.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-06-analytics';

-- feature-06-analytics [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Analytics microservice — tracking post views via RabbitMQ', 'A new service in the system — Analytics. Its only job is collecting events and producing statistics. It has no public API — it communicates exclusively through the RabbitMQ queue.',
         'A new service in the system — **Analytics**. Its only job is collecting events and producing statistics. It has no public API — it communicates exclusively through the RabbitMQ queue.

**Services: Analytics, Frontend**

## Architecture without a public API

Most analytics services are REST APIs that Frontend POSTs data to. I chose a different approach: Frontend publishes an event to RabbitMQ, Analytics consumes it in the background. Benefits:

- Frontend doesn\'t wait for a response (fire-and-forget)
- Analytics can be temporarily down without losing events — the queue buffers them
- Easy scaling of the consumer independently from Frontend

## Sending an event from Frontend

After a post is displayed, Frontend publishes a `post.viewed` event:

```php
// Frontend — sending the event
$this->analyticsApi->trackView([
    \'post_id\'    => $post->id,
    \'user_id\'    => auth()->id(),
    \'ip\'         => request()->ip(),
    \'user_agent\' => request()->userAgent(),
]);
```

`analyticsApi` is a wrapper around the RabbitMQ client. It serializes the payload and sends it to the appropriate queue. If the user is not logged in, `user_id` is null — the event still reaches the system.

## Consumer in Analytics

**Analytics** runs a worker listening on the `post.viewed` queue. Each event goes into the `post_views` table with a timestamp, IP, and user agent.

The service aggregates statistics: view count per post, unique views (deduplicated by IP + post_id within a time window), daily trend.

## Statistics in the admin panel

**Admin** queries Analytics through an internal API (protected by an API key). The post page shows view count, a trend chart, and a breakdown of logged-in vs anonymous readers.

> Analytics data is read-only from Admin\'s perspective — the panel does not modify event history, it only displays it.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-06-analytics';

-- feature-07-monitoring [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Stos monitorowania — Prometheus, Loki, Grafana', 'System działa — ale co się w nim dzieje? Czas na obserwability. Postawiłem klasyczny stos: Prometheus do metryk, Loki do logów, Grafana jako dashboard. Wszystko w ramach infrastruktury Docker Compose.',
         'System działa — ale co się w nim dzieje? Czas na obserwability. Postawiłem klasyczny stos: **Prometheus** do metryk, **Loki** do logów, **Grafana** jako dashboard. Wszystko w ramach infrastruktury Docker Compose.

**Serwis: Infra**

## Prometheus — metryki z serwisów

Każdy serwis Laravel eksponuje endpoint `/metrics` przez bibliotekę `spatie/prometheus`. Prometheus scrapuje je co 15 sekund. Zbierane metryki to: liczba requestów HTTP, czas odpowiedzi, użycie pamięci PHP, stan kolejek RabbitMQ.

Konfiguracja scrapowania w `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: \'blog\'
    static_configs:
      - targets: [\'blog:80\']
    metrics_path: \'/metrics\'
    scrape_interval: 15s
```

## Loki — agregacja logów

**Loki** to system agregacji logów kompatybilny z Grafaną. Nie indeksuje treści logów (jak Elasticsearch) — indeksuje tylko etykiety. To sprawia, że jest znacznie lżejszy przy zachowaniu szybkiego przeszukiwania.

Każdy kontener Docker wysyła logi do Loki przez **Promtail**. Promtail czyta logi z Docker socket i przesyła je z metadanymi kontenera (nazwa, ID, środowisko).

## Promtail — zbieranie logów z kontenerów

Promtail działa jako agent na hoście i nasłuchuje na log driver Dockera. Konfiguracja autodiscovery — automatycznie wykrywa nowe kontenery i zaczyna zbierać ich logi bez ręcznej konfiguracji.

Każdy log dostaje etykiety: `container_name`, `compose_service`, `compose_project`. W Grafanie można filtrować logi po serwisie: `{compose_service="blog"}`.

## Grafana — wszystko w jednym miejscu

```yaml
# docker-compose fragment
grafana:
  image: grafana/grafana:latest
  volumes:
    - grafana_data:/var/lib/grafana
  environment:
    - GF_AUTH_ANONYMOUS_ENABLED=true
```

Grafana jest skonfigurowana z dwoma data sources: Prometheus (metryki) i Loki (logi). Dashboardy są zapisane jako JSON i wersjonowane w repo — `grafana/dashboards/`.

Przygotowałem dashboardy dla:
- Przegląd systemu (CPU, pamięć, requesty per serwis)
- Logi w czasie rzeczywistym z możliwością przeszukiwania
- Stan kolejek RabbitMQ

> `GF_AUTH_ANONYMOUS_ENABLED=true` działa lokalnie i na dev. Na produkcji ten parametr jest wyłączony — dostęp przez OAuth2 SSO.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-07-monitoring';

-- feature-07-monitoring [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Monitoring stack — Prometheus, Loki, Grafana', 'The system is running — but what\'s happening inside it? Time for observability. I set up the classic stack: Prometheus for metrics, Loki for logs, Grafana as the dashboard. All within the Docker Compose infrastructure.',
         'The system is running — but what\'s happening inside it? Time for observability. I set up the classic stack: **Prometheus** for metrics, **Loki** for logs, **Grafana** as the dashboard. All within the Docker Compose infrastructure.

**Service: Infra**

## Prometheus — metrics from services

Each Laravel service exposes a `/metrics` endpoint via the `spatie/prometheus` library. Prometheus scrapes them every 15 seconds. Collected metrics include: HTTP request count, response time, PHP memory usage, RabbitMQ queue state.

Scrape configuration in `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: \'blog\'
    static_configs:
      - targets: [\'blog:80\']
    metrics_path: \'/metrics\'
    scrape_interval: 15s
```

## Loki — log aggregation

**Loki** is a log aggregation system compatible with Grafana. It does not index log content (like Elasticsearch) — it only indexes labels. This makes it much lighter while still providing fast searching.

Each Docker container sends logs to Loki via **Promtail**. Promtail reads logs from the Docker socket and forwards them with container metadata (name, ID, environment).

## Promtail — collecting logs from containers

Promtail runs as an agent on the host and listens on the Docker log driver. Autodiscovery configuration — it automatically detects new containers and starts collecting their logs without manual configuration.

Each log gets labels: `container_name`, `compose_service`, `compose_project`. In Grafana you can filter logs by service: `{compose_service="blog"}`.

## Grafana — everything in one place

```yaml
# docker-compose fragment
grafana:
  image: grafana/grafana:latest
  volumes:
    - grafana_data:/var/lib/grafana
  environment:
    - GF_AUTH_ANONYMOUS_ENABLED=true
```

Grafana is configured with two data sources: Prometheus (metrics) and Loki (logs). Dashboards are saved as JSON and versioned in the repo under `grafana/dashboards/`.

I prepared dashboards for:
- System overview (CPU, memory, requests per service)
- Real-time logs with search capability
- RabbitMQ queue state

> `GF_AUTH_ANONYMOUS_ENABLED=true` works locally and on dev. In production this parameter is disabled — access is through OAuth2 SSO.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-07-monitoring';

-- article-05-kubernetes-migration [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Kubernetes od Docker Compose — moja migracja krok po kroku', 'Punkt startowy — Docker Compose',
         '## Punkt startowy — Docker Compose

Docker Compose działał świetnie w developmencie. Jeden plik, `docker compose up` i wszystko chodzi. Ale Compose nie daje:
- automatycznego restartu po awarii noda
- rolling updates bez downtime
- horizontal scaling
- deklaratywnego zarządzania konfiguracją

Kubernetes rozwiązuje wszystkie te problemy.

## Mapowanie pojęć

| Docker Compose | Kubernetes |
|----------------|------------|
| `service`      | `Deployment` + `Service` |
| `volumes`      | `PersistentVolumeClaim` |
| `environment`  | `ConfigMap` + `Secret` |
| `networks`     | `NetworkPolicy` |
| `depends_on`   | `initContainer` |
| `healthcheck`  | `livenessProbe` + `readinessProbe` |

## Deployment manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    spec:
      containers:
        - name: frontend
          image: ghcr.io/szymonborowski/portfolio-frontend:v0.0.4
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: frontend-config
            - secretRef:
                name: frontend-secrets
          livenessProbe:
            httpGet:
              path: /health
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 5
```

## InitContainers — migracje bazy

Największy problem: jak upewnić się, że migracje DB wykonają się przed startem aplikacji? W Compose używałem `depends_on` z `condition: service_healthy`. W K8s używam initContainer:

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/portfolio-blog:v0.0.4
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secrets
```

initContainer musi zakończyć się sukcesem zanim główny kontener wystartuje.

## StatefulSets dla baz danych

MySQL i Redis działają jako StatefulSet, nie Deployment — bo potrzebują stabilnej tożsamości sieciowej i trwałego storage:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: blog-db
spec:
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
```

## Co poszło nie tak

Największa pułapka: **obrazy ARM vs AMD64**. Budowałem obrazy na MacBooku (ARM) bez `--platform linux/amd64`. Na klastrze (AMD64) kontenery crashowały z błędem "exec format error". Rozwiązanie: multi-arch build z `docker buildx`:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/... --push .
```', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-05-kubernetes-migration';

-- article-05-kubernetes-migration [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'From Docker Compose to Kubernetes — my step-by-step migration', 'Starting point — Docker Compose',
         '## Starting point — Docker Compose

Docker Compose worked great in development. One file, `docker compose up` and everything runs. But Compose doesn\'t provide:
- automatic restart after a node failure
- rolling updates without downtime
- horizontal scaling
- declarative configuration management

Kubernetes solves all of these problems.

## Mapping concepts

| Docker Compose | Kubernetes |
|----------------|------------|
| `service`      | `Deployment` + `Service` |
| `volumes`      | `PersistentVolumeClaim` |
| `environment`  | `ConfigMap` + `Secret` |
| `networks`     | `NetworkPolicy` |
| `depends_on`   | `initContainer` |
| `healthcheck`  | `livenessProbe` + `readinessProbe` |

## Deployment manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    spec:
      containers:
        - name: frontend
          image: ghcr.io/szymonborowski/portfolio-frontend:v0.0.4
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: frontend-config
            - secretRef:
                name: frontend-secrets
          livenessProbe:
            httpGet:
              path: /health
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 5
```

## InitContainers — database migrations

The biggest problem: how to make sure DB migrations run before the application starts? In Compose I used `depends_on` with `condition: service_healthy`. In K8s I use an initContainer:

```yaml
initContainers:
  - name: migrate
    image: ghcr.io/szymonborowski/portfolio-blog:v0.0.4
    command: ["php", "artisan", "migrate", "--force"]
    envFrom:
      - secretRef:
          name: blog-secrets
```

The initContainer must complete successfully before the main container starts.

## StatefulSets for databases

MySQL and Redis run as a StatefulSet, not a Deployment — because they need a stable network identity and persistent storage:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: blog-db
spec:
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
```

## What went wrong

The biggest pitfall: **ARM vs AMD64 images**. I was building images on a MacBook (ARM) without `--platform linux/amd64`. On the cluster (AMD64) containers crashed with an "exec format error". The fix: multi-arch build with `docker buildx`:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/... --push .
```', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-05-kubernetes-migration';

-- article-06-github-actions-cicd [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'GitHub Actions CI/CD — testy, budowanie obrazów i push do GHCR', 'Struktura pipeline',
         '## Struktura pipeline

Pipeline podzielony jest na dwa etapy:

1. **CI** — uruchamia się na każdym PR i pushu do `master`; musi przejść żeby można było mergować
2. **CD** — uruchamia się tylko na pushu do `master`; buduje i publikuje obrazy

```yaml
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  test:
    # CI — uruchamia się zawsze
  build-and-push:
    needs: test
    if: github.ref == \'refs/heads/master\'
    # CD — tylko na master po przejściu testów
```

## CI — uruchamianie testów

Każdy serwis PHP ma własny job. Dla Blog serwisu:

```yaml
test-blog:
  runs-on: ubuntu-latest
  services:
    mysql:
      image: mysql:8
      env:
        MYSQL_DATABASE: blog_test
        MYSQL_ROOT_PASSWORD: secret
      options: --health-cmd="mysqladmin ping" --health-interval=10s

  steps:
    - uses: actions/checkout@v4
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: "8.5"
        extensions: pdo_mysql, mbstring, redis
    - name: Install dependencies
      run: composer install --no-interaction
      working-directory: blog/src
    - name: Run tests
      run: php artisan test --parallel
      working-directory: blog/src
      env:
        DB_DATABASE: blog_test
        DB_USERNAME: root
        DB_PASSWORD: secret
```

## CD — budowanie i push do GHCR

```yaml
build-and-push:
  strategy:
    matrix:
      service: [frontend, blog, users, sso, admin, analytics]

  steps:
    - name: Login to GHCR
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: ./${{ matrix.service }}
        file: ./${{ matrix.service }}/Dockerfile
        push: true
        tags: |
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:${{ github.sha }}
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:latest
        platforms: linux/amd64,linux/arm64
```

## Caching warstw Dockera

Bez cachowania każdy build ściąga `composer install` od nowa (~2 min). Z cache:

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

GitHub Actions Cache przechowuje warstwy Dockera. Przy kolejnym buildzie, jeśli `composer.lock` się nie zmienił, warstwa vendor jest wzięta z cache. Czas buildu spada z ~8 minut do ~2 minut.

## Czas wykonania pipeline

Dzięki `matrix` i parallelizacji, 6 serwisów buduje się jednocześnie. Łączny czas CI+CD: **~6 minut** od pusha do opublikowanych obrazów.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-06-github-actions-cicd';

-- article-06-github-actions-cicd [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'GitHub Actions CI/CD — tests, building images and pushing to GHCR', 'Pipeline structure',
         '## Pipeline structure

The pipeline is split into two stages:

1. **CI** — runs on every PR and push to `master`; must pass before merging is allowed
2. **CD** — runs only on push to `master`; builds and publishes images

```yaml
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  test:
    # CI — always runs
  build-and-push:
    needs: test
    if: github.ref == \'refs/heads/master\'
    # CD — only on master after tests pass
```

## CI — running tests

Each PHP service has its own job. For the Blog service:

```yaml
test-blog:
  runs-on: ubuntu-latest
  services:
    mysql:
      image: mysql:8
      env:
        MYSQL_DATABASE: blog_test
        MYSQL_ROOT_PASSWORD: secret
      options: --health-cmd="mysqladmin ping" --health-interval=10s

  steps:
    - uses: actions/checkout@v4
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: "8.5"
        extensions: pdo_mysql, mbstring, redis
    - name: Install dependencies
      run: composer install --no-interaction
      working-directory: blog/src
    - name: Run tests
      run: php artisan test --parallel
      working-directory: blog/src
      env:
        DB_DATABASE: blog_test
        DB_USERNAME: root
        DB_PASSWORD: secret
```

## CD — building and pushing to GHCR

```yaml
build-and-push:
  strategy:
    matrix:
      service: [frontend, blog, users, sso, admin, analytics]

  steps:
    - name: Login to GHCR
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: ./${{ matrix.service }}
        file: ./${{ matrix.service }}/Dockerfile
        push: true
        tags: |
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:${{ github.sha }}
          ghcr.io/${{ github.repository_owner }}/portfolio-${{ matrix.service }}:latest
        platforms: linux/amd64,linux/arm64
```

## Docker layer caching

Without caching, every build pulls `composer install` from scratch (~2 min). With cache:

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

GitHub Actions Cache stores Docker layers. On the next build, if `composer.lock` hasn\'t changed, the vendor layer is pulled from cache. Build time drops from ~8 minutes to ~2 minutes.

## Pipeline execution time

Thanks to `matrix` and parallelization, 6 services build simultaneously. Total CI+CD time: **~6 minutes** from push to published images.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-06-github-actions-cicd';

-- article-07-monitoring-stack [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Monitoring z Prometheus, Loki i Grafana — stack obserwowalności w Docker Compose', 'Trzy filary obserwowalności',
         '## Trzy filary obserwowalności

Pełna obserwowalność systemu wymaga trzech typów danych:

- **Metryki** — liczby w czasie: CPU, pamięć, liczba requestów, czas odpowiedzi (Prometheus)
- **Logi** — tekstowe rekordy zdarzeń (Loki + Promtail)
- **Traces** — śledzenie konkretnego requestu przez wiele serwisów (nie wdrożone jeszcze)

## Prometheus — zbieranie metryk

Prometheus scrape\'uje metryki z endpointów HTTP `/metrics`. Traefik i Laravel eksponują je automatycznie.

Konfiguracja scrapowania:
```yaml
# infra/prometheus/prometheus.yml
scrape_configs:
  - job_name: traefik
    static_configs:
      - targets: [\'traefik:8080\']
    metrics_path: /metrics

  - job_name: frontend
    static_configs:
      - targets: [\'frontend-nginx:9113\']
```

Dla PHP/Laravel używam `nginx-prometheus-exporter` jako sidecar, który czyta status Nginx i eksponuje metryki w formacie Prometheusa.

## Loki + Promtail — agregacja logów

Zamiast `docker logs` (które znikają po restarcie kontenera), loguję przez Promtail → Loki.

Wszystkie serwisy PHP mają ustawione `LOG_CHANNEL=stderr` — logi lecą do stdout kontenera, Promtail je zbiera:

```yaml
# infra/promtail/promtail.yml
scrape_configs:
  - job_name: containers
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: [__meta_docker_container_name]
        target_label: container
```

## Grafana — dashboardy

Stworzyłem trzy dashboardy:

**1. Infrastructure Overview**
- CPU i RAM per kontener
- Network I/O
- Liczba aktywnych kontenerów

**2. Laravel Application**
- Requesty HTTP per minutę (przez logi Nginx)
- Response time (p50, p95, p99)
- Error rate (5xx)
- Cache hit rate Redis

**3. RabbitMQ**
- Liczba wiadomości w kolejkach
- Consumer throughput
- Dead-letter queue size

## Alerty (TODO)

Grafana pozwala ustawiać alerty na podstawie zapytań PromQL. Planowane alerty:
- Error rate > 5% przez 5 minut
- Pod restart count > 3
- Queue depth > 1000 wiadomości
- Czas odpowiedzi p95 > 2 sekundy

Na razie monitoring działa "read-only" — obserwuję, nie alarmuje. To jedno z zadań do zrealizowania przed pełnym deployem produkcyjnym.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-07-monitoring-stack';

-- article-07-monitoring-stack [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Monitoring with Prometheus, Loki and Grafana — observability stack in Docker Compose', 'Three pillars of observability',
         '## Three pillars of observability

Full system observability requires three types of data:

- **Metrics** — numbers over time: CPU, memory, request count, response time (Prometheus)
- **Logs** — textual event records (Loki + Promtail)
- **Traces** — tracking a specific request across multiple services (not yet implemented)

## Prometheus — collecting metrics

Prometheus scrapes metrics from HTTP `/metrics` endpoints. Traefik and Laravel expose them automatically.

Scrape configuration:
```yaml
# infra/prometheus/prometheus.yml
scrape_configs:
  - job_name: traefik
    static_configs:
      - targets: [\'traefik:8080\']
    metrics_path: /metrics

  - job_name: frontend
    static_configs:
      - targets: [\'frontend-nginx:9113\']
```

For PHP/Laravel I use `nginx-prometheus-exporter` as a sidecar that reads Nginx status and exposes metrics in Prometheus format.

## Loki + Promtail — log aggregation

Instead of `docker logs` (which disappear after a container restart), I log through Promtail → Loki.

All PHP services have `LOG_CHANNEL=stderr` set — logs go to container stdout, and Promtail collects them:

```yaml
# infra/promtail/promtail.yml
scrape_configs:
  - job_name: containers
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: [__meta_docker_container_name]
        target_label: container
```

## Grafana — dashboards

I created three dashboards:

**1. Infrastructure Overview**
- CPU and RAM per container
- Network I/O
- Number of active containers

**2. Laravel Application**
- HTTP requests per minute (via Nginx logs)
- Response time (p50, p95, p99)
- Error rate (5xx)
- Redis cache hit rate

**3. RabbitMQ**
- Number of messages in queues
- Consumer throughput
- Dead-letter queue size

## Alerts (TODO)

Grafana allows setting up alerts based on PromQL queries. Planned alerts:
- Error rate > 5% for 5 minutes
- Pod restart count > 3
- Queue depth > 1000 messages
- p95 response time > 2 seconds

For now the monitoring works in "read-only" mode — I observe, it does not alert. This is one of the tasks to complete before a full production deployment.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-07-monitoring-stack';

-- article-08-analytics-service [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Mikroserwis Analytics — zbieranie wyświetleń przez RabbitMQ i agregacja', 'Po co osobny serwis?',
         '## Po co osobny serwis?

Statystyki wyświetleń mają inne charakterystyki niż reszta systemu:
- **Zapis jest bardzo częsty** (każde wyświetlenie posta)
- **Odczyt jest rzadki** (dashboard admina, panel autora)
- **Dane mogą być nieaktualne do kilku sekund** — to akceptowalne

To idealny kandydat na osobny serwis z innym modelem danych zoptymalizowanym pod write-heavy workload.

## Schemat bazy danych

```sql
CREATE TABLE post_views (
    id          BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_uuid   CHAR(36) NOT NULL,
    user_id     BIGINT UNSIGNED NULL,
    ip          VARCHAR(45) NULL,
    user_agent  TEXT NULL,
    referer     VARCHAR(500) NULL,
    viewed_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_post_uuid (post_uuid),
    INDEX idx_viewed_at (viewed_at)
);

CREATE TABLE post_view_aggregates (
    id          BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_uuid   CHAR(36) NOT NULL,
    date        DATE NOT NULL,
    view_count  INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY uq_post_date (post_uuid, date)
);
```

`post_views` to surowe dane. `post_view_aggregates` to zagregowane widoki per dzień — szybki odczyt bez skanowania milionów rekordów.

## Consumer — odbieranie eventów

```php
class ConsumePostViews extends Command
{
    public function handle(): void
    {
        $this->channel->basic_consume(
            queue: \'analytics.post_views\',
            callback: function (AMQPMessage $msg) {
                $data = json_decode($msg->body, true);

                // Zapis surowego eventu
                PostView::create([
                    \'post_uuid\' => $data[\'post_uuid\'],
                    \'user_id\'   => $data[\'user_id\'] ?? null,
                    \'ip\'        => $data[\'ip\'],
                    \'user_agent\' => $data[\'user_agent\'] ?? null,
                    \'referer\'   => $data[\'referer\'] ?? null,
                    \'viewed_at\' => $data[\'timestamp\'],
                ]);

                // Upsert agregatu (atomowy increment)
                DB::statement(\'
                    INSERT INTO post_view_aggregates (post_uuid, date, view_count)
                    VALUES (?, CURDATE(), 1)
                    ON DUPLICATE KEY UPDATE view_count = view_count + 1
                \', [$data[\'post_uuid\']]);

                $msg->ack();
            }
        );

        while ($this->channel->is_consuming()) {
            $this->channel->wait();
        }
    }
}
```

## API Analytics

```
GET /api/v1/posts/{uuid}/views          → łączna liczba wyświetleń
GET /api/v1/posts/{uuid}/views/daily    → wyświetlenia per dzień (ostatnie 30 dni)
GET /api/v1/posts/top?limit=10          → top posty wg wyświetleń
```

Wszystkie endpointy wymagają `X-Internal-Api-Key` — dostępne tylko dla innych serwisów.

## Integracja z frontendem

Frontend wywołuje analytics API przy wyświetlaniu dashboardu autora. Odpytuje `GET /api/v1/posts/{uuid}/views` dla każdego posta i wyświetla liczbę.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-08-analytics-service';

-- article-08-analytics-service [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'The Analytics microservice — collecting views via RabbitMQ and aggregation', 'Why a separate service?',
         '## Why a separate service?

View statistics have different characteristics than the rest of the system:
- **Writes are very frequent** (every post view)
- **Reads are rare** (admin dashboard, author panel)
- **Data can be stale by a few seconds** — that is acceptable

This makes it an ideal candidate for a separate service with a different data model optimized for a write-heavy workload.

## Database schema

```sql
CREATE TABLE post_views (
    id          BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_uuid   CHAR(36) NOT NULL,
    user_id     BIGINT UNSIGNED NULL,
    ip          VARCHAR(45) NULL,
    user_agent  TEXT NULL,
    referer     VARCHAR(500) NULL,
    viewed_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_post_uuid (post_uuid),
    INDEX idx_viewed_at (viewed_at)
);

CREATE TABLE post_view_aggregates (
    id          BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_uuid   CHAR(36) NOT NULL,
    date        DATE NOT NULL,
    view_count  INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY uq_post_date (post_uuid, date)
);
```

`post_views` holds the raw data. `post_view_aggregates` holds aggregated views per day — fast reads without scanning millions of records.

## Consumer — receiving events

```php
class ConsumePostViews extends Command
{
    public function handle(): void
    {
        $this->channel->basic_consume(
            queue: \'analytics.post_views\',
            callback: function (AMQPMessage $msg) {
                $data = json_decode($msg->body, true);

                // Store the raw event
                PostView::create([
                    \'post_uuid\' => $data[\'post_uuid\'],
                    \'user_id\'   => $data[\'user_id\'] ?? null,
                    \'ip\'        => $data[\'ip\'],
                    \'user_agent\' => $data[\'user_agent\'] ?? null,
                    \'referer\'   => $data[\'referer\'] ?? null,
                    \'viewed_at\' => $data[\'timestamp\'],
                ]);

                // Upsert the aggregate (atomic increment)
                DB::statement(\'
                    INSERT INTO post_view_aggregates (post_uuid, date, view_count)
                    VALUES (?, CURDATE(), 1)
                    ON DUPLICATE KEY UPDATE view_count = view_count + 1
                \', [$data[\'post_uuid\']]);

                $msg->ack();
            }
        );

        while ($this->channel->is_consuming()) {
            $this->channel->wait();
        }
    }
}
```

## Analytics API

```
GET /api/v1/posts/{uuid}/views          → total view count
GET /api/v1/posts/{uuid}/views/daily    → views per day (last 30 days)
GET /api/v1/posts/top?limit=10          → top posts by views
```

All endpoints require `X-Internal-Api-Key` — accessible only to other services.

## Frontend integration

The frontend calls the analytics API when displaying the author dashboard. It queries `GET /api/v1/posts/{uuid}/views` for each post and displays the count.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'article-08-analytics-service';

-- feature-08-production-deploy [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Wdrożenie na OVH Managed Kubernetes z Kustomize', 'Projekt wylądował na produkcji. Klaster OVH Managed Kubernetes, obrazy w GHCR, TLS z cert-manager i Let\'s Encrypt. Zarządzanie konfiguracją przez Kustomize — bez Helma, bez zewnętrznych zależności.',
         'Projekt wylądował na produkcji. Klaster **OVH Managed Kubernetes**, obrazy w **GHCR**, TLS z **cert-manager** i Let\'s Encrypt. Zarządzanie konfiguracją przez **Kustomize** — bez Helma, bez zewnętrznych zależności.

**Serwisy: wszystkie**

## Kustomize overlays — base / dev / prod

Każdy serwis ma strukturę:

```
k8s/
  base/          # wspólna konfiguracja
  overlays/
    dev/         # nadpisania dla dev (mniej replik, bez limitów)
    prod/        # nadpisania dla prod (limity, TLS, zewnętrzne domeny)
```

`base/` zawiera Deployment, Service i ConfigMap. Overlaye nadpisują tylko to, co się różni — liczba replik, image tag, limity CPU/RAM, adres Ingress.

```bash
# Deploy na produkcję
kubectl apply -k k8s/overlays/prod
kubectl get pods -n portfolio
```

## Obrazy Docker w GHCR

Każdy merge do `main` uruchamia GitHub Actions workflow, który buduje obraz i pushuje do **GitHub Container Registry**:

```
ghcr.io/szymonborowski/blog:latest
ghcr.io/szymonborowski/frontend:latest
ghcr.io/szymonborowski/sso:latest
```

Klaster K8s pobiera obrazy z GHCR przez imagePullSecret. Tag `latest` wskazuje zawsze na najnowszy build z głównej gałęzi.

## cert-manager i Let\'s Encrypt

TLS obsługuje **cert-manager** z Issuerem Let\'s Encrypt. Certyfikaty są automatycznie odnawiane. Ingress każdego serwisu ma adnotację:

```yaml
annotations:
  cert-manager.io/cluster-issuer: "letsencrypt-prod"
```

cert-manager sam tworzy obiekt `Certificate` i przechowuje certyfikat w Secret.

## Resource limits i log rotation

Na produkcji każdy kontener ma zdefiniowane `requests` i `limits` dla CPU i pamięci. Bez limitów jeden serwis może zagłodzić cały klaster.

W Docker Compose (dla lokalnego dev) skonfigurowałem log rotation, żeby logi nie zapełniły dysku:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

> Na K8s logi zbiera Promtail i wysyła do Loki — Docker log rotation nie jest potrzebna, ale na dev Compose jest niezbędna.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-08-production-deploy';

-- feature-08-production-deploy [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Deploying to OVH Managed Kubernetes with Kustomize', 'The project is live. OVH Managed Kubernetes cluster, images in GHCR, TLS with cert-manager and Let\'s Encrypt. Configuration management via Kustomize — no Helm, no external dependencies.',
         'The project is live. **OVH Managed Kubernetes** cluster, images in **GHCR**, TLS with **cert-manager** and Let\'s Encrypt. Configuration management via **Kustomize** — no Helm, no external dependencies.

**Services: all**

## Kustomize overlays — base / dev / prod

Each service has this structure:

```
k8s/
  base/          # shared configuration
  overlays/
    dev/         # overrides for dev (fewer replicas, no limits)
    prod/        # overrides for prod (limits, TLS, external domains)
```

`base/` contains the Deployment, Service, and ConfigMap. Overlays only override what differs — replica count, image tag, CPU/RAM limits, Ingress address.

```bash
# Deploy to production
kubectl apply -k k8s/overlays/prod
kubectl get pods -n portfolio
```

## Docker images in GHCR

Every merge to `main` triggers a GitHub Actions workflow that builds the image and pushes it to **GitHub Container Registry**:

```
ghcr.io/szymonborowski/blog:latest
ghcr.io/szymonborowski/frontend:latest
ghcr.io/szymonborowski/sso:latest
```

The K8s cluster pulls images from GHCR via an imagePullSecret. The `latest` tag always points to the newest build from the main branch.

## cert-manager and Let\'s Encrypt

TLS is handled by **cert-manager** with a Let\'s Encrypt Issuer. Certificates are automatically renewed. Each service\'s Ingress has the annotation:

```yaml
annotations:
  cert-manager.io/cluster-issuer: "letsencrypt-prod"
```

cert-manager creates the `Certificate` object itself and stores the certificate in a Secret.

## Resource limits and log rotation

In production, every container has defined `requests` and `limits` for CPU and memory. Without limits, one service can starve the entire cluster.

In Docker Compose (for local dev) I configured log rotation so logs don\'t fill the disk:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

> On K8s, logs are collected by Promtail and sent to Loki — Docker log rotation isn\'t needed, but on dev Compose it\'s essential.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-08-production-deploy';

-- feature-09-cms [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Start Here widget i zarządzanie postami w panelu', 'Blog potrzebuje redakcji — nie tylko publikowania. W tej iteracji dodałem zarządzanie postami w panelu Admin, wyróżnione posty i sekcję Start Here na stronie głównej Frontendu.',
         'Blog potrzebuje redakcji — nie tylko publikowania. W tej iteracji dodałem zarządzanie postami w panelu **Admin**, wyróżnione posty i sekcję **Start Here** na stronie głównej Frontendu.

**Serwisy: Admin, Blog, Frontend**

## Wewnętrzne API Blog dla CMS

Blog dostał nowy zestaw tras wewnętrznych dostępnych tylko dla Admina (klucz API):

```
GET  /internal/posts
POST /internal/posts
PUT  /internal/posts/{id}
GET  /internal/categories
GET  /internal/tags
```

Te trasy omijają JWT guard — nie są dla zalogowanych użytkowników, tylko dla serwisu Admin działającego jako klient.

## Tabela `featured_posts`

Nowa tabela w bazie Blog. Trzyma listę wyróżnionych postów z kolejnością wyświetlania. Relacja do `posts` przez `post_id`.

```sql
CREATE TABLE featured_posts (
    id         BIGINT PRIMARY KEY AUTO_INCREMENT,
    post_id    BIGINT NOT NULL,
    position   INT    NOT NULL DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id)
);
```

Admin może zmienić kolejność wyróżnionych postów przez drag-and-drop w Filament.

## Admin — strona Manage Posts

Nowa strona w **FilamentPHP** z listą wszystkich postów z Blog API. Kolumny: tytuł, autor, kategoria, status, data. Filtry: status, kategoria, autor. Akcje: edycja, usunięcie, zmiana statusu.

Tworzenie i edycja posta otwiera formularz z polami: tytuł, slug, treść (Markdown), kategoria, tagi, status (draft/published).

## Admin — strona Start Here

Osobna strona Filament do zarządzania listą "Start Here". Drag-and-drop do zmiany kolejności. Możliwość dodania posta z wyszukiwarki (autokompletowanie po tytule).

## Frontend — sekcja Start Here

Na stronie głównej Frontendu pojawia się sekcja z listą postów "Start Here". Frontend pobiera ją z Blog przez endpoint `/internal/featured-posts` — ta trasa jest wewnętrzna, nie wymaga JWT, ale jest dostępna tylko wewnątrz sieci Dockera/K8s.

Sekcja wyświetla karty postów: tytuł, miniatura, krótki opis, link do posta.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-09-cms';

-- feature-09-cms [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Start Here widget and post management in the admin panel', 'A blog needs editorial management — not just publishing. In this iteration I added post management in the Admin panel, featured posts, and a Start Here section on the Frontend homepage.',
         'A blog needs editorial management — not just publishing. In this iteration I added post management in the **Admin** panel, featured posts, and a **Start Here** section on the Frontend homepage.

**Services: Admin, Blog, Frontend**

## Internal Blog API for CMS

Blog got a new set of internal routes accessible only to Admin (API key):

```
GET  /internal/posts
POST /internal/posts
PUT  /internal/posts/{id}
GET  /internal/categories
GET  /internal/tags
```

These routes bypass the JWT guard — they are not for logged-in users, only for the Admin service acting as a client.

## The `featured_posts` table

A new table in the Blog database. It holds the list of featured posts with their display order. Related to `posts` via `post_id`.

```sql
CREATE TABLE featured_posts (
    id         BIGINT PRIMARY KEY AUTO_INCREMENT,
    post_id    BIGINT NOT NULL,
    position   INT    NOT NULL DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id)
);
```

Admin can reorder featured posts via drag-and-drop in Filament.

## Admin — Manage Posts page

A new page in **FilamentPHP** with a list of all posts from the Blog API. Columns: title, author, category, status, date. Filters: status, category, author. Actions: edit, delete, change status.

Creating and editing a post opens a form with fields: title, slug, content (Markdown), category, tags, status (draft/published).

## Admin — Start Here page

A separate Filament page for managing the "Start Here" list. Drag-and-drop to reorder. Ability to add a post via a search widget (autocomplete by title).

## Frontend — Start Here section

The Frontend homepage now has a "Start Here" section. Frontend fetches it from Blog through the `/internal/featured-posts` endpoint — this route is internal, requires no JWT, but is only accessible within the Docker/K8s network.

The section displays post cards: title, thumbnail, short description, link to the post.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-09-cms';

-- feature-10-ui-improvements [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Dark mode, anonimowe polubienia i nowe UI', 'Seria ulepszeń UX: ciemny motyw w SSO, polubienia postów i komentarzy bez wymogu logowania, kolorowe kategorie i odświeżone karty postów. Plus usunięcie slidera hero, który nikt nie lubił.',
         'Seria ulepszeń UX: ciemny motyw w SSO, polubienia postów i komentarzy bez wymogu logowania, kolorowe kategorie i odświeżone karty postów. Plus usunięcie slidera hero, który nikt nie lubił.

**Serwisy: Frontend, Blog, SSO, Analytics**

## Dark mode w SSO

**SSO** — mimo że to głównie serwer autoryzacji — ma swój interfejs: strona logowania, ekran zgody OAuth2. Dodałem przełącznik motywu z zapisem preferencji w cookie. System operacyjny jako domyślny motyw (`prefers-color-scheme`), ręczny przełącznik jako nadpisanie.

Implementacja przez Tailwind CSS z klasą `dark:` — minimalna zmiana w HTML, całość zarządzana przez jeden atrybut `data-theme` na `<html>`.

## Anonimowe polubienia — identyfikacja po IP

Polubienia działają bez konta. Identyfikacja przez hash IP + user agent:

```php
// Anonimowe polubienie — identyfikacja po IP
$identifier = hash(\'sha256\', $request->ip() . $request->userAgent());
Like::firstOrCreate([
    \'post_id\'    => $postId,
    \'identifier\' => $identifier,
]);
```

Jeśli użytkownik jest zalogowany — `identifier` to jego ID użytkownika zamiast hasha. Dzięki temu zalogowany użytkownik nie może polubić posta wielokrotnie z różnych IP.

**Analytics** przechowuje polubienia z opcjonalnym przypisaniem do użytkownika. **Frontend** odpytuje Analytics o liczby polubień i wyświetla je przy każdym poście i komentarzu.

## Kolorowe kategorie

Każda kategoria ma teraz pole `color` (hex). W kartach postów i tagach kategoria wyświetlana jest jako kolorowa plakietka. Admin może ustawić kolor przy tworzeniu kategorii.

## Nowe karty postów

Redesign kart postów na stronie głównej i w listingach:
- Miniatura posta (opcjonalna, fallback na gradient z koloru kategorii)
- Liczba wyświetleń i polubień pod tytułem
- Kolorowa plakietka kategorii
- Avatar autora

## Usunięcie slidera hero

Slider na stronie głównej zniknął. Zajmował dużo miejsca, ładował się wolno i nikt w niego nie klikał. Zastąpiłem go statycznym banerem z tytułem bloga i linkiem do sekcji Start Here.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-10-ui-improvements';

-- feature-10-ui-improvements [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Dark mode, anonymous likes, and new UI', 'A series of UX improvements: dark theme in SSO, post and comment likes without requiring login, colorful categories, and refreshed post cards. Plus the removal of the hero slider that nobody liked.',
         'A series of UX improvements: dark theme in SSO, post and comment likes without requiring login, colorful categories, and refreshed post cards. Plus the removal of the hero slider that nobody liked.

**Services: Frontend, Blog, SSO, Analytics**

## Dark mode in SSO

**SSO** — even though it\'s primarily an authorization server — has its own interface: the login page and OAuth2 consent screen. I added a theme toggle that saves the preference in a cookie. The operating system provides the default theme (`prefers-color-scheme`), and the manual toggle overrides it.

Implemented via Tailwind CSS `dark:` classes — minimal HTML change, the whole thing managed by a single `data-theme` attribute on `<html>`.

## Anonymous likes — IP-based identification

Likes work without an account. Identification is done via an IP + user agent hash:

```php
// Anonymous like — IP-based identification
$identifier = hash(\'sha256\', $request->ip() . $request->userAgent());
Like::firstOrCreate([
    \'post_id\'    => $postId,
    \'identifier\' => $identifier,
]);
```

If the user is logged in — `identifier` is their user ID instead of the hash. This prevents a logged-in user from liking a post multiple times from different IPs.

**Analytics** stores likes with an optional user assignment. **Frontend** queries Analytics for like counts and displays them next to each post and comment.

## Colorful categories

Each category now has a `color` field (hex). In post cards and tags, the category is displayed as a colored badge. Admin can set the color when creating a category.

## New post cards

Redesigned post cards on the homepage and in listings:
- Post thumbnail (optional, with a fallback gradient using the category color)
- View and like counts below the title
- Colored category badge
- Author avatar

## Removing the hero slider

The homepage slider is gone. It took up a lot of space, loaded slowly, and nobody clicked it. I replaced it with a static banner showing the blog title and a link to the Start Here section.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-10-ui-improvements';

-- feature-11-pages-i18n [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Przełącznik języka, nowe strony i newsletter', 'Duża iteracja przekrojowa — obsługa dwóch języków (PL/EN) w całym systemie, nowe strony statyczne we Frontendzie, newsletter i tile z commitami GitHub na stronie głównej.',
         'Duża iteracja przekrojowa — obsługa dwóch języków (PL/EN) w całym systemie, nowe strony statyczne we Frontendzie, newsletter i tile z commitami GitHub na stronie głównej.

**Serwisy: Frontend, Blog, Admin**

## Przełącznik języka PL/EN

Dodałem routing do zmiany locale z zapisem w sesji:

```php
// Przełącznik języka
Route::get(\'/locale/{locale}\', function (string $locale) {
    abort_if(! in_array($locale, [\'pl\', \'en\']), 404);
    session([\'locale\' => $locale]);
    return redirect()->back();
});
```

Middleware `SetLocale` odczytuje wartość z sesji przy każdym żądaniu i ustawia `App::setLocale()`. Wszystkie stringi w widokach przechodzą przez `__()` lub `@lang()`. Tłumaczenia w `lang/pl/` i `lang/en/`.

## Nowe strony we Frontend

### O mnie

Strona z opisem autora, linkami do CV (PL/EN jako osobne pliki PDF) i linkami do GitHub, LinkedIn. Treść tłumaczona — każda wersja językowa ma osobny plik tłumaczeń.

### Kontakt

Formularz kontaktowy z walidacją po stronie serwera. Wiadomości wysyłane przez SMTP OVH. Honeypot przeciw spamowi.

### Współpraca

Strona opisująca możliwości współpracy: freelance, konsultacje, code review. Prosta strona statyczna z tłumaczeniami.

## Tile z commitami GitHub

Na stronie głównej pojawił się widget z ostatnimi commitami do repo projektu. Frontend odpytuje GitHub API, cacheuje odpowiedź przez 10 minut w Redis i wyświetla listę ostatnich 5 commitów z linkami.

## Blog: pole `locale` i `version`

Posty w Blog dostały dwa nowe pola:
- `locale` — język posta (`pl` lub `en`)
- `version` — wersja posta powiązana z tym samym tematem w drugim języku

Pozwala to na linkowanie między wersjami językowymi tego samego posta: "Czytaj po angielsku / Read in Polish".

## Blog: subskrybent newslettera

Nowy model `Subscriber` w Blog z polami: `email`, `locale`, `confirmed_at`. Endpoint `POST /newsletter/subscribe` z weryfikacją emaila przez link potwierdzający (SMTP OVH).

## Admin: filtry językowe w Manage Posts

Strona Manage Posts w Filament dostała:
- Filtr po `locale` — pokaż tylko polskie / tylko angielskie posty
- Selektor `version` — przypisanie wersji językowej do posta
- Kolumna `locale` w tabeli listingu', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-11-pages-i18n';

-- feature-11-pages-i18n [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Language switcher, new pages, and newsletter', 'A large cross-cutting iteration — two-language support (PL/EN) across the entire system, new static pages in Frontend, a newsletter, and a GitHub commits tile on the homepage.',
         'A large cross-cutting iteration — two-language support (PL/EN) across the entire system, new static pages in Frontend, a newsletter, and a GitHub commits tile on the homepage.

**Services: Frontend, Blog, Admin**

## PL/EN language switcher

I added locale-switching routing with session storage:

```php
// Language switcher
Route::get(\'/locale/{locale}\', function (string $locale) {
    abort_if(! in_array($locale, [\'pl\', \'en\']), 404);
    session([\'locale\' => $locale]);
    return redirect()->back();
});
```

The `SetLocale` middleware reads the session value on every request and calls `App::setLocale()`. All strings in views go through `__()` or `@lang()`. Translations live in `lang/pl/` and `lang/en/`.

## New Frontend pages

### About me

A page with the author\'s description, links to CV (PL/EN as separate PDF files), and links to GitHub and LinkedIn. Content is translated — each language version has its own translation file.

### Contact

A contact form with server-side validation. Messages sent via OVH SMTP. Honeypot for spam protection.

### Collaboration

A page describing collaboration opportunities: freelance, consulting, code review. A simple static page with translations.

## GitHub commits tile

The homepage now has a widget showing recent commits to the project repository. Frontend queries the GitHub API, caches the response for 10 minutes in Redis, and displays a list of the last 5 commits with links.

## Blog: `locale` and `version` fields

Posts in Blog got two new fields:
- `locale` — post language (`pl` or `en`)
- `version` — post version linked to the same topic in the other language

This enables linking between language versions of the same post: "Read in Polish / Czytaj po polsku".

## Blog: newsletter subscriber

A new `Subscriber` model in Blog with fields: `email`, `locale`, `confirmed_at`. A `POST /newsletter/subscribe` endpoint with email verification via a confirmation link (OVH SMTP).

## Admin: language filters in Manage Posts

The Manage Posts page in Filament got:
- A `locale` filter — show only Polish / only English posts
- A `version` selector — assign a language version to a post
- A `locale` column in the listing table', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-11-pages-i18n';

-- feature-12-install-sh [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Automatyzacja środowiska — install.sh', 'Siedem repozytoriów, kilkanaście plików .env, certyfikaty TLS, wpisy w /etc/hosts, sieci Dockera, klucze Passport -- ustawienie tego wszystkiego ręcznie to dobra godzina klikania i kopiowania. Napisałem skrypt, który robi to w jednym poleceniu.',
         'Siedem repozytoriów, kilkanaście plików .env, certyfikaty TLS, wpisy w /etc/hosts, sieci Dockera, klucze Passport -- ustawienie tego wszystkiego ręcznie to dobra godzina klikania i kopiowania. Napisałem skrypt, który robi to w jednym poleceniu.

## Problem

Projekt składa się z siedmiu mikroserwisów: infra, frontend, sso, admin, users, blog, analytics. Każdy ma swój `docker-compose.yml`, swój `.env` na poziomie Compose i osobny `src/.env` dla Laravela. Domena pojawia się w kilkudziesięciu miejscach. Sekrety (klucze API, hasła baz, klucze Passport OAuth2) muszą być spójne między serwisami. Do tego certyfikaty TLS dla kilkunastu subdomen i wpisy DNS w `/etc/hosts`.

Robiłem to ręcznie przez kilka tygodni. Za każdym razem, kiedy chciałem postawić środowisko od zera, traciłem czas na te same kroki. Czas to zautomatyzować.

## Jak działa install.sh

Skrypt wykonuje wszystko sekwencyjnie w jednym przebiegu:

```bash
./install.sh
# lub z parametrami:
./install.sh --domain myapp.local --repo-base git@github.com:myuser
```

Główna pętla klonuje repozytoria na podstawie tablicy serwisów:

```bash
SERVICES=(
  "infra:infrastructure_service"
  "frontend:frontend_service"
  "sso:sso_service"
  "admin:admin_service"
  "users:users_service"
  "blog:blog_service"
  "analytics:analytics_service"
)

for entry in "${SERVICES[@]}"; do
  dir="${entry%%:*}"
  repo="${entry##*:}"
  git clone "${REPO_BASE}/${repo}.git" "$dir"
done
```

Po sklonowaniu skrypt kopiuje `.env.example` do `.env` dla każdego serwisu, podmienia domenę przez `sed`, ustawia UID/GID hosta i konfiguruje połączenia do baz danych w Laravelowych `src/.env`.

## Generowanie sekretów

Sekrety generowane są przez `openssl rand` i wstrzykiwane do plików .env za pomocą funkcji `env_set_once`, która nadpisuje wartość tylko wtedy, gdy jest pusta. Dzięki temu ponowne uruchomienie skryptu nie nadpisze istniejących kluczy:

```bash
env_set_once() {
  local f="$1" k="$2" v="$3"
  [ -f "$f" ] || return 0
  local current
  current=$(grep "^${k}=" "$f" | cut -d= -f2) || true
  [ -n "$current" ] && return 0
  sed -i "s|^${k}=.*|${k}=${v}|" "$f"
}
```

Skrypt generuje i dystrybuuje: hasło RabbitMQ, hasła MySQL, klucz klienta SSO OAuth2, wewnętrzne klucze API do Users i Analytics, oraz `APP_KEY` dla każdego serwisu Laravel.

## Certyfikaty TLS

`mkcert` generuje certyfikaty dla domeny bazowej i wszystkich subdomen (frontend, sso, admin, traefik, rabbitmq, grafana...). Certyfikaty lądują w `infra/certs/`, a certyfikaty Vite są kopiowane do `frontend/src/certs/`. Traefik korzysta z nich w konfiguracji dynamicznej generowanej przez `envsubst`.

## Purge i ponowna instalacja

Flaga `--purge` zatrzymuje wszystkie serwisy, usuwa sklonowane katalogi i wolumeny baz danych. Po purge można uruchomić `./install.sh` od nowa -- czyste środowisko w kilka minut.

## Podsumowanie

Jeden skrypt zastępuje kilkadziesiąt ręcznych kroków. Nowy członek zespołu może postawić całe środowisko jednym poleceniem, bez czytania dokumentacji konfiguracyjnej. Skrypt jest idempotentny -- pomija kroki, które już zostały wykonane, i nie nadpisuje istniejących plików.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-12-install-sh';

-- feature-12-install-sh [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Dev environment automation — install.sh', 'Setting up seven microservices by hand -- cloning repos, copying .env files, generating TLS certs, updating /etc/hosts, creating Docker networks, generating secrets -- takes about an hour and is painfully error-prone. I wrote a single shell script that do',
         'Setting up seven microservices by hand -- cloning repos, copying .env files, generating TLS certs, updating /etc/hosts, creating Docker networks, generating secrets -- takes about an hour and is painfully error-prone. I wrote a single shell script that does the whole thing.

## The setup problem

The portfolio project runs seven services: infra (Traefik, RabbitMQ, monitoring), frontend, sso, admin, users, blog, and analytics. Each has its own `docker-compose.yml`, a Compose-level `.env`, and a Laravel-level `src/.env`. The domain name appears in dozens of places. Shared secrets (RabbitMQ password, DB credentials, OAuth2 client secret, internal API keys, Passport keypair) must be consistent across services. On top of that, you need TLS certificates for over a dozen subdomains and matching entries in `/etc/hosts`.

I had been doing this manually for weeks. Every clean setup meant repeating the same tedious steps. Time to automate.

## What install.sh does

The script runs everything sequentially in a single pass. It accepts flags for customization:

```bash
./install.sh
./install.sh --domain myapp.local --repo-base git@github.com:otheruser
./install.sh --purge   # tear down everything for a clean reinstall
```

First, it clones all seven repositories based on a services array:

```bash
SERVICES=(
  "infra:infrastructure_service"
  "frontend:frontend_service"
  "sso:sso_service"
  "admin:admin_service"
  "users:users_service"
  "blog:blog_service"
  "analytics:analytics_service"
)

for entry in "${SERVICES[@]}"; do
  dir="${entry%%:*}"
  repo="${entry##*:}"
  git clone "${REPO_BASE}/${repo}.git" "$dir"
done
```

After cloning, it copies `.env.example` to `.env` for every service, substitutes the domain via `sed`, sets the host UID/GID, and wires up database connections in the Laravel `src/.env` files.

## Secret generation

Secrets are generated with `openssl rand` and injected into .env files using `env_set_once` -- a helper that only writes a value when the current one is empty. This makes the script safe to re-run without overwriting existing credentials:

```bash
env_set_once() {
  local f="$1" k="$2" v="$3"
  [ -f "$f" ] || return 0
  local current
  current=$(grep "^${k}=" "$f" | cut -d= -f2) || true
  [ -n "$current" ] && return 0
  sed -i "s|^${k}=.*|${k}=${v}|" "$f"
}
```

The script generates and distributes: a shared RabbitMQ password, MySQL passwords, an SSO OAuth2 client secret, internal API keys for Users and Analytics, and a unique `APP_KEY` for each Laravel service. After migrations, it also generates Passport OAuth2 keypairs inside the SSO container and writes them to both `sso/src/.env` and `users/src/.env`.

## TLS certificates

`mkcert` generates trusted certificates for the base domain and all subdomains (frontend, sso, admin, traefik, rabbitmq, grafana, prometheus, and more). Certs land in `infra/certs/`. The Vite dev server certs are copied separately to `frontend/src/certs/` so hot reload works over HTTPS. Traefik picks up the certs via a dynamic config file generated by `envsubst` from a template.

## Idempotent by design

Every step checks whether it has already been completed. Existing repos are skipped, existing .env files are not overwritten, existing certs are left in place, and `env_set_once` preserves previously generated secrets. Running `./install.sh` twice produces the same result as running it once.

The `--purge` flag provides the inverse: it stops all services, removes cloned directories, and deletes database volumes -- giving you a clean slate for a fresh install.

## Result

One command, a few minutes of waiting, and the full local environment is up: seven services behind Traefik with valid TLS, all secrets wired, databases migrated, Passport keys generated. No manual steps, no documentation to follow.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-12-install-sh';

-- feature-13-easymde-editor [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Edytor Markdown i kolorowanie składni', 'Pisanie postów w czystym textarea to nic przyjemnego -- brak podglądu, brak formatowania, zero podpowiedzi. Dodałem EasyMDE jako edytor Markdown zarówno we Frontendzie, jak i w panelu Admin, a wyrenderowane posty dostały kolorowanie składni dzięki highlig',
         'Pisanie postów w czystym textarea to nic przyjemnego -- brak podglądu, brak formatowania, zero podpowiedzi. Dodałem EasyMDE jako edytor Markdown zarówno we Frontendzie, jak i w panelu Admin, a wyrenderowane posty dostały kolorowanie składni dzięki highlight.js.

**Serwisy: Frontend, Admin, Blog**

## EasyMDE we Frontend

Frontend ma formularz tworzenia i edycji postów dostępny dla zalogowanych autorów. Pole `content` było dotychczas zwykłym `<textarea>`. Zamieniłem je na instancję EasyMDE z paskiem narzędzi, podglądem na żywo i obsługą skrótów klawiszowych:

```js
import EasyMDE from \'easymde\';

const editor = new EasyMDE({
    element: document.getElementById(\'content\'),
    spellChecker: false,
    autosave: {
        enabled: true,
        uniqueId: \'post-content\',
        delay: 5000,
    },
    toolbar: [
        \'bold\', \'italic\', \'heading\', \'|\',
        \'code\', \'quote\', \'unordered-list\', \'ordered-list\', \'|\',
        \'link\', \'image\', \'|\',
        \'preview\', \'side-by-side\', \'fullscreen\',
    ],
});
```

Autosave zapisuje szkic w `localStorage` co 5 sekund -- zabezpieczenie przed przypadkowym zamknięciem karty. Spellchecker wyłączony, bo posty zawierają dużo kodu i nazw technicznych.

## EasyMDE w panelu Admin (Filament)

W Filament domyślne pole Markdown to prosty edytor bez podglądu. Podmieniłem je na EasyMDE za pomocą niestandardowego komponentu Blade, który Filament ładuje jako Alpine.js widget:

```php
Textarea::make(\'content\')
    ->label(\'Content (Markdown)\')
    ->required()
    ->columnSpanFull()
    ->view(\'filament.forms.components.easymde-editor\'),
```

Komponent Blade inicjalizuje EasyMDE na elemencie textarea i synchronizuje wartość z modelem Filament przez Alpine `$wire`. Dzięki temu edytor działa identycznie jak natywne pole Filament -- walidacja, zapis i podgląd formularza bez niespodzianek.

## Kolorowanie składni -- highlight.js

Posty są przechowywane jako surowy Markdown. Frontend renderuje je do HTML po stronie serwera. Bloki kodu (```` ``` ````) trafiają do przeglądarki jako `<pre><code>`, ale bez kolorowania wyglądają płasko. Dodałem highlight.js z automatyczną detekcją języka:

```js
import hljs from \'highlight.js\';
import \'highlight.js/styles/github-dark.css\';

document.querySelectorAll(\'pre code\').forEach((block) => {
    hljs.highlightElement(block);
});
```

Wybrałem motyw **github-dark** -- pasuje do ciemnego trybu frontendu i dobrze wygląda przy jasnym tle po przełączeniu.

## Refaktor CategoryColor

Przy okazji uprościłem helper `CategoryColor`. Wcześniej mapował nazwy kategorii na klasy Tailwind przez rozbudowany switch. Teraz przyjmuje nazwę koloru bezpośrednio z pola `color` kategorii i zwraca odpowiednie klasy. Paleta rozrosła się o kilkanaście nowych kolorów Tailwind -- violet, fuchsia, rose, cyan, lime i inne.

## Podsumowanie

Edytor Markdown z podglądem na żywo to spory skok w komforcie pisania. Kolorowanie składni w opublikowanych postach sprawia, że fragmenty kodu są czytelne od razu, bez wklejania screenshotów. Obie zmiany dotknęły Frontendu i Admina, ale logika po stronie Blog API nie wymagała zmian -- Markdown jest przechowywany w tej samej kolumnie co wcześniej.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-13-easymde-editor';

-- feature-13-easymde-editor [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Markdown editor and syntax highlighting', 'Writing blog posts in a plain textarea is not a great experience -- no preview, no toolbar, no formatting hints. I replaced the raw textarea with EasyMDE in both the Frontend and Admin panel, and added highlight.js so that published code blocks get proper',
         'Writing blog posts in a plain textarea is not a great experience -- no preview, no toolbar, no formatting hints. I replaced the raw textarea with EasyMDE in both the Frontend and Admin panel, and added highlight.js so that published code blocks get proper syntax coloring.

**Services: Frontend, Admin, Blog**

## EasyMDE in the Frontend

The Frontend has a post creation and editing form available to logged-in authors. The `content` field was a bare `<textarea>`. I swapped it for an EasyMDE instance with a formatting toolbar, live side-by-side preview, and keyboard shortcuts:

```js
import EasyMDE from \'easymde\';

const editor = new EasyMDE({
    element: document.getElementById(\'content\'),
    spellChecker: false,
    autosave: {
        enabled: true,
        uniqueId: \'post-content\',
        delay: 5000,
    },
    toolbar: [
        \'bold\', \'italic\', \'heading\', \'|\',
        \'code\', \'quote\', \'unordered-list\', \'ordered-list\', \'|\',
        \'link\', \'image\', \'|\',
        \'preview\', \'side-by-side\', \'fullscreen\',
    ],
});
```

The autosave option writes a draft to `localStorage` every 5 seconds -- a safety net against accidental tab closures. Spellchecker is off because posts are full of code identifiers and technical terms that trigger false positives.

## EasyMDE in the Admin panel (Filament)

Filament ships with a basic Markdown field, but it lacks a live preview and a proper toolbar. I replaced it with a custom Blade component that initializes EasyMDE on the underlying textarea and wires the value back to Filament through Alpine.js:

```php
Textarea::make(\'content\')
    ->label(\'Content (Markdown)\')
    ->required()
    ->columnSpanFull()
    ->view(\'filament.forms.components.easymde-editor\'),
```

The Blade view boots EasyMDE on mount and syncs every keystroke with the Livewire model via `$wire`. This keeps Filament\'s validation, dirty-state tracking, and save flow intact -- the editor behaves exactly like a native Filament field.

## Syntax highlighting with highlight.js

Posts are stored as raw Markdown in the Blog database. The Frontend renders them to HTML server-side. Fenced code blocks end up as `<pre><code>` tags, but without highlighting they look flat and hard to scan. I added highlight.js with automatic language detection:

```js
import hljs from \'highlight.js\';
import \'highlight.js/styles/github-dark.css\';

document.querySelectorAll(\'pre code\').forEach((block) => {
    hljs.highlightElement(block);
});
```

I picked the **github-dark** theme because it pairs well with the Frontend\'s dark mode and still looks clean when the user switches to a light theme.

## CategoryColor refactor

While working on the Frontend I simplified the `CategoryColor` helper. Previously it used a verbose switch statement to map category names to Tailwind classes. Now it accepts the color name directly from the category\'s `color` field and returns the matching utility classes. The palette grew with new Tailwind colors -- violet, fuchsia, rose, cyan, lime, and several more.

## Wrap-up

A proper Markdown editor with live preview makes writing posts noticeably more comfortable. Syntax highlighting on published posts means code snippets are readable at a glance instead of being monochrome walls of text. Both changes touched Frontend and Admin, but the Blog API itself needed no modifications -- Markdown is stored in the same column as before, rendering is purely a presentation concern.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-13-easymde-editor';

-- feature-14-docker-fixes [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Stabilizacja Docker — vendor, MySQL 8.0 i unifikacja .env', 'Po kilku tygodniach rozwijania mikroserwisów trafiłem na serię problemów, które powtarzały się przy każdym `docker compose up` -- znikający vendor/, niekompatybilny MySQL i rozjeżdżające się dane logowania do baz. Jeden dzień na naprawienie tego we wszyst',
         'Po kilku tygodniach rozwijania mikroserwisów trafiłem na serię problemów, które powtarzały się przy każdym `docker compose up` -- znikający vendor/, niekompatybilny MySQL i rozjeżdżające się dane logowania do baz. Jeden dzień na naprawienie tego we wszystkich sześciu serwisach.

## vendor/ znika po starcie kontenera

Problem był podstępny. W `docker-compose.yml` montuję cały katalog `src/` jako bind mount, żeby mieć hot-reload przy developmencie. Dockerfile uruchamia `composer install` przy budowaniu obrazu, więc vendor/ jest w kontenerze. Ale po starcie bind mount nadpisuje cały `src/` treścią z hosta -- a na hoście `vendor/` jest pusty albo nie istnieje. Efekt: kontener startuje, Laravel nie widzi żadnej paczki, aplikacja pada.

Rozwiązanie to **named volume** zamontowany na ścieżce vendor/ wewnątrz kontenera. Named volume ma wyższy priorytet niż bind mount i zachowuje zawartość z obrazu:

```yaml
services:
  app:
    volumes:
      - ./src:/var/www/html
      - vendor_data:/var/www/html/vendor

volumes:
  vendor_data:
```

Docker przy pierwszym starcie kopiuje zawartość vendor/ z obrazu do named volume. Kolejne starty używają tego samego wolumenu. Bind mount na `src/` dalej działa normalnie, ale vendor/ jest chroniony. Po `composer require` w kontenerze zmiany zostają w wolumenie -- nie znikają po restarcie.

## MySQL 8.4 łamie połączenia

Drugi problem objawiał się błędem `Access denied` mimo poprawnych danych logowania. Przyczyna: w `docker-compose.yml` miałem `mysql:8`, co po aktualizacji obrazu ściągnęło MySQL 8.4. Wersja 8.4 zmieniła domyślny plugin autoryzacji z `mysql_native_password` na `caching_sha2_password`. Laravel z domyślnym driverem PDO nie obsługuje tego pluginu bez dodatkowej konfiguracji.

Najprostsze rozwiązanie -- **przypięcie obrazu do mysql:8.0**:

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USERNAME}
      MYSQL_PASSWORD: ${DB_PASSWORD}
```

MySQL 8.0 używa `mysql_native_password` domyślnie. Kiedy będziemy gotowi na migrację do nowszej wersji, zrobimy to świadomie z odpowiednią konfiguracją pluginu.

## Unifikacja danych logowania do baz

Każdy serwis miał inne nazwy użytkowników i haseł do bazy -- coś wymyślonego na szybko przy tworzeniu każdego `.env`. Przy sześciu serwisach to sześć różnych nazw użytkowników, sześć haseł i zero możliwości debugowania, które hasło pasuje do którego serwisu.

Ujednoliciłem schemat: **nazwa użytkownika = nazwa serwisu**, wspólne hasło developerskie. Przykład dla serwisu blog:

```env
DB_DATABASE=blog
DB_USERNAME=blog
DB_PASSWORD=secret_dev
```

To samo dla sso, admin, users, analytics, frontend. Każdy serwis ma własną bazę i własnego użytkownika, ale wzorzec jest identyczny. Debugowanie staje się trywialne.

## bootstrap/cache w .gitignore

Ostatnia zmiana -- wykluczenie `bootstrap/cache/` z repozytorium. Pliki w tym katalogu są generowane przez Laravela (cache konfiguracji, routing, serwisy). Commity z tymi plikami powodowały konflikty przy merge\'ach i niepotrzebny szum w diffach. Teraz `.gitignore` zawiera `bootstrap/cache/*` i każde środowisko generuje swój cache lokalnie.

## Podsumowanie

Cztery zmiany zastosowane do wszystkich sześciu serwisów: named volume na vendor/, MySQL przypięty do 8.0, ujednolicone dane logowania i wyczyszczony .gitignore. Środowisko developerskie startuje teraz bez niespodzianek.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-14-docker-fixes';

-- feature-14-docker-fixes [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Docker stabilization — vendor volumes, MySQL 8.0, and env unification', 'After weeks of building out the microservices, I hit a cluster of Docker issues that kept biting me on every fresh `docker compose up` -- disappearing vendor directories, MySQL authentication failures, and a mess of inconsistent database credentials. I sp',
         'After weeks of building out the microservices, I hit a cluster of Docker issues that kept biting me on every fresh `docker compose up` -- disappearing vendor directories, MySQL authentication failures, and a mess of inconsistent database credentials. I spent a day fixing all of them across all six Laravel services.

## The vanishing vendor/ directory

This one was subtle. Each service\'s `docker-compose.yml` bind-mounts the `src/` directory for hot-reload during development. The Dockerfile runs `composer install` at build time, so vendor/ exists inside the image. But when the container starts, the bind mount overlays the entire `src/` with the host\'s version -- and on the host, `vendor/` is either empty or missing entirely. Result: Laravel boots, finds zero packages, and crashes immediately.

The fix is a **named volume** mounted at the vendor/ path inside the container. Named volumes take priority over bind mounts and preserve the contents from the image:

```yaml
services:
  app:
    volumes:
      - ./src:/var/www/html
      - vendor_data:/var/www/html/vendor

volumes:
  vendor_data:
```

On first start, Docker copies the vendor/ contents from the image into the named volume. Subsequent starts reuse the same volume. The bind mount on `src/` still works for live editing, but vendor/ is protected. When you run `composer require` inside the container, the changes persist in the volume across restarts.

## MySQL 8.4 breaks authentication

The second issue showed up as `Access denied` errors despite correct credentials. The root cause: `docker-compose.yml` specified `mysql:8`, which -- after a recent image pull -- resolved to MySQL 8.4. Version 8.4 changed the default authentication plugin from `mysql_native_password` to `caching_sha2_password`. Laravel\'s default PDO driver does not handle this plugin without extra configuration.

The straightforward fix -- **pin the image to mysql:8.0**:

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USERNAME}
      MYSQL_PASSWORD: ${DB_PASSWORD}
```

MySQL 8.0 defaults to `mysql_native_password`. When we are ready to migrate to a newer version, we will do it intentionally with proper plugin configuration rather than having it break silently on a pull.

## Unified database credentials

Every service had its own ad-hoc database username and password -- whatever I came up with when first creating each `.env`. Six services meant six different usernames, six passwords, and no easy way to tell which credentials belonged where when debugging connection issues.

I standardized on a simple pattern: **username equals service name**, shared dev password. For example, the blog service:

```env
DB_DATABASE=blog
DB_USERNAME=blog
DB_PASSWORD=secret_dev
```

Same pattern for sso, admin, users, analytics, and frontend. Each service still gets its own database and its own user, but the naming is predictable. Debugging becomes trivial -- if the blog service cannot connect, you know the credentials are `blog` / `secret_dev` without checking any file.

## bootstrap/cache in .gitignore

One last cleanup -- excluding `bootstrap/cache/` from version control. Laravel generates files in this directory (config cache, route cache, service manifest). Having them committed caused merge conflicts on almost every branch and added noise to diffs. Now `.gitignore` includes `bootstrap/cache/*` and each environment generates its own cache locally.

## Summary

Four changes rolled out to all six services: named volume for vendor/, MySQL pinned to 8.0, unified credentials, and a cleaned-up .gitignore. The dev environment now starts reliably without surprises.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-14-docker-fixes';

-- feature-15-i18n-translations [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Refaktor i18n — tabela post_translations', 'Dotychczas każda wersja językowa posta to był osobny wiersz w tabeli `posts`. Działało, ale generowało dużo problemów -- duplikacja metadanych, nadmuchane liczniki kategorii, oddzielne URL-e per język. Przebudowałem to od podstaw: jeden post, wiele tłumac',
         'Dotychczas każda wersja językowa posta to był osobny wiersz w tabeli `posts`. Działało, ale generowało dużo problemów -- duplikacja metadanych, nadmuchane liczniki kategorii, oddzielne URL-e per język. Przebudowałem to od podstaw: jeden post, wiele tłumaczeń.

## Problem

W starym schemacie post polski i angielski to dwa niezależne rekordy. Slug zawierał sufiks języka: `intro-01-why-this-blog-pl`, `intro-01-why-this-blog-en`. Każdy miał swoje `author_id`, `status`, `published_at`, kategorie i tagi. Zmiana statusu posta wymagała aktualizacji każdej wersji językowej osobno.

FeaturedPosts potrzebował oddzielnych wpisów per język. `CategoryController` liczył posty per locale przez `where(\'locale\', ...)`, co oznaczało że kategoria z dwoma postami (PL + EN) pokazywała licznik 4 zamiast 2. Wszystko było powiązane z tym, że **locale było właściwością posta, a nie tłumaczenia**.

## Nowy schemat

Rozdzieliłem dane na dwie tabele. `posts` przechowuje metadane niezależne od języka, a `post_translations` -- treść per locale:

```sql
CREATE TABLE posts (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    slug VARCHAR(255) UNIQUE NOT NULL,
    author_id BIGINT UNSIGNED NOT NULL,
    status VARCHAR(20) DEFAULT \'draft\',
    published_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

CREATE TABLE post_translations (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_id BIGINT UNSIGNED NOT NULL,
    locale VARCHAR(5) NOT NULL,
    title VARCHAR(255) NOT NULL,
    excerpt TEXT NULL,
    content LONGTEXT NOT NULL,
    version INT UNSIGNED DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    UNIQUE (post_id, locale),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);
```

Slug jest teraz czysty: `intro-01-why-this-blog` -- bez sufiksu języka. Ten sam URL pokazuje treść w języku wybranym przez użytkownika.

## Migracja

Dane w bazie nie były krytyczne (seed generuje je od nowa), więc zamiast pisać skomplikowaną migrację ALTER + INSERT INTO ... SELECT, użyłem podejścia DROP + CREATE. Prosta, czysta migracja bez ryzyka błędu w transformacji danych.

## Zmiany w API

`PostResource` spłaszcza tłumaczenie do odpowiedzi API -- klient dostaje `title`, `excerpt`, `content` na najwyższym poziomie, jakby nic się nie zmieniło:

```php
class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $locale = app()->getLocale();
        $translation = $this->translations->firstWhere(\'locale\', $locale);

        return [
            \'id\'           => $this->id,
            \'slug\'         => $this->slug,
            \'title\'        => $translation?->title,
            \'excerpt\'      => $translation?->excerpt,
            \'content\'      => $translation?->content,
            \'status\'       => $this->status,
            \'published_at\' => $this->published_at,
            \'author\'       => new AuthorResource($this->author),
            \'categories\'   => CategoryResource::collection($this->categories),
            \'tags\'         => TagResource::collection($this->tags),
        ];
    }
}
```

`FeaturedPostController` filtrował posty po `post.locale`. Teraz filtruje po istnieniu tłumaczenia: `whereHas(\'translations\', fn ($q) => $q->where(\'locale\', $locale))`. `CategoryController` miał ten sam problem z `withCount` -- zmiana z `where(\'locale\')` na `whereHas(\'translations\')` naprawiła liczniki.

## Frontend

`BlogApiService` przekazuje locale z sesji w nagłówku zapytania. Użytkownik zmienia język przełącznikiem -- ten sam URL `/blog/intro-01-why-this-blog` pokazuje treść po polsku lub angielsku bez przekierowania. Nie trzeba było zmieniać routingu ani linków w nawigacji.

## Seed

Skrypt `generate_seed.py` został przebudowany. Wcześniej każdy plik markdown to osobny post. Teraz pliki są grupowane po nazwie katalogu -- `intro-01-why-this-blog/pl.md` i `intro-01-why-this-blog/en.md` tworzą jeden post z dwoma tłumaczeniami. Slug pochodzi z nazwy katalogu.

## Rezultat

Jeden post = jeden rekord, niezależnie od liczby języków. Liczniki kategorii są poprawne. FeaturedPosts działa bez duplikacji. URL-e są czyste i niezależne od locale. API jest wstecznie kompatybilne -- frontend nie wymagał zmian w strukturze odpowiedzi. Architektura jest gotowa na dodanie kolejnych języków bez zmian w schemacie.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-15-i18n-translations';

-- feature-15-i18n-translations [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'i18n refactor — the post_translations table', 'Up until now, every locale of a blog post was a separate row in the `posts` table. It worked, but it created a cascade of problems -- duplicated metadata, inflated category counts, locale baked into the URL. I tore it out and rebuilt it properly: one post',
         'Up until now, every locale of a blog post was a separate row in the `posts` table. It worked, but it created a cascade of problems -- duplicated metadata, inflated category counts, locale baked into the URL. I tore it out and rebuilt it properly: one post, many translations.

## Problem

In the old schema, the Polish and English versions of a post were two independent records. The slug carried a language suffix: `intro-01-why-this-blog-pl`, `intro-01-why-this-blog-en`. Each had its own `author_id`, `status`, `published_at`, categories, and tags. Publishing a post meant updating every locale separately.

FeaturedPosts needed a separate entry per language. `CategoryController` counted posts per locale with `where(\'locale\', ...)`, so a category with two posts (PL + EN) showed a count of 4 instead of 2. The root cause was simple: **locale was a property of the post, not of the translation**.

## New schema

I split the data into two tables. `posts` holds locale-agnostic metadata, and `post_translations` holds per-locale content:

```sql
CREATE TABLE posts (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    slug VARCHAR(255) UNIQUE NOT NULL,
    author_id BIGINT UNSIGNED NOT NULL,
    status VARCHAR(20) DEFAULT \'draft\',
    published_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

CREATE TABLE post_translations (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    post_id BIGINT UNSIGNED NOT NULL,
    locale VARCHAR(5) NOT NULL,
    title VARCHAR(255) NOT NULL,
    excerpt TEXT NULL,
    content LONGTEXT NOT NULL,
    version INT UNSIGNED DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    UNIQUE (post_id, locale),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);
```

The slug is now clean: `intro-01-why-this-blog` -- no language suffix. The same URL serves content in whatever language the user has selected.

## Migration

The existing data was not critical -- the seed script regenerates everything from markdown files. Instead of writing a complicated ALTER + INSERT INTO ... SELECT migration to reshape the data, I went with DROP + CREATE. Clean slate, no risk of a botched transformation.

## API changes

`PostResource` flattens the matching translation into the top-level response, so the API contract stays backward-compatible:

```php
class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $locale = app()->getLocale();
        $translation = $this->translations->firstWhere(\'locale\', $locale);

        return [
            \'id\'           => $this->id,
            \'slug\'         => $this->slug,
            \'title\'        => $translation?->title,
            \'excerpt\'      => $translation?->excerpt,
            \'content\'      => $translation?->content,
            \'status\'       => $this->status,
            \'published_at\' => $this->published_at,
            \'author\'       => new AuthorResource($this->author),
            \'categories\'   => CategoryResource::collection($this->categories),
            \'tags\'         => TagResource::collection($this->tags),
        ];
    }
}
```

`FeaturedPostController` used to filter by `post.locale`. Now it filters by translation existence: `whereHas(\'translations\', fn ($q) => $q->where(\'locale\', $locale))`. `CategoryController` had the same inflated-count bug with `withCount` -- switching from `where(\'locale\')` to `whereHas(\'translations\')` fixed it.

## Frontend

`BlogApiService` passes the locale from the session header. The user flips the language switcher, and the same URL `/blog/intro-01-why-this-blog` renders Polish or English content without a redirect. No routing changes, no link rewiring.

## Seed

The `generate_seed.py` script got a rewrite. Previously, each markdown file produced a separate post. Now it groups files by directory name -- `intro-01-why-this-blog/pl.md` and `intro-01-why-this-blog/en.md` become one post with two translations. The slug comes from the directory name.

## Result

One post = one record, regardless of how many languages exist. Category counts are correct. FeaturedPosts works without duplication. URLs are clean and locale-independent. The API is backward-compatible -- the frontend did not need any changes to its response handling. And the schema is ready for adding more languages without structural changes.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-15-i18n-translations';

-- feature-16-post-reading [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Typografia, sidebar i hero — czytelność przede wszystkim', 'Posty na blogu wyglądały płasko. Nagłówki nie różniły się rozmiarem od zwykłego tekstu, bloki kodu nie miały żadnego formatowania, a listy zlewały się z akapitami. Dodałem plugin typografii, wyciągnąłem sidebar do współdzielonych komponentów i wymieniłem ',
         'Posty na blogu wyglądały płasko. Nagłówki nie różniły się rozmiarem od zwykłego tekstu, bloki kodu nie miały żadnego formatowania, a listy zlewały się z akapitami. Dodałem plugin typografii, wyciągnąłem sidebar do współdzielonych komponentów i wymieniłem tło hero na gradient.

## Problem z renderowaniem treści

Treść postów jest pisana w Markdownie i konwertowana przez `Str::markdown()`. Wynik to czysty HTML — nagłówki `<h2>`, akapity `<p>`, bloki `<pre><code>`. Tailwind CSS domyślnie resetuje style wszystkich elementów, więc `<h2>` wygląda identycznie jak `<p>`. Żaden margines, żaden rozmiar czcionki.

## @tailwindcss/typography

Plugin `@tailwindcss/typography` dodaje klasę `prose`, która przywraca czytelne style dla treści generowanej z Markdowna:

```css
@import \'tailwindcss\';
@plugin \'@tailwindcss/typography\';
```

W widoku posta wystarczyło owinąć treść:

```blade
<div class="prose prose-gray dark:prose-invert max-w-none">
    {!! \\Illuminate\\Support\\Str::markdown($post[\'content\'] ?? \'\') !!}
</div>
```

`prose-gray` ustawia neutralną paletę kolorów. `dark:prose-invert` odwraca kolory w trybie ciemnym. `max-w-none` wyłącza domyślne ograniczenie szerokości — layout kontroluje kolumna nadrzędna.

Efekt natychmiastowy: nagłówki mają hierarchię rozmiarów, akapity mają odstępy, bloki kodu dostały tło i zaokrąglenia, cytaty mają lewą krawędź, listy mają wcięcia i markery.

## Współdzielony sidebar

Sidebar z ostatnimi postami i kategoriami powtarzał się w trzech widokach: strona posta, strona kategorii, strona tagu. Kod był zduplikowany — te same pętle, te same style, ten sam `@forelse`. Zmiany wymagały edycji trzech plików.

Wyciągnąłem go do dwóch komponentów Blade:

```blade
<x-recent-posts-sidebar :recentPosts="$recentPosts" />
<x-category-grid :categories="$categories" />
```

Komponent `recent-posts-sidebar` renderuje listę ostatnich postów z kolorowymi literami kategorii. `category-grid` wyświetla siatkę kategorii z licznikami postów. Oba przyjmują dane przez props — widok nie musi wiedzieć skąd pochodzą.

Trzy widoki skurczyły się o ~60 linii każdy. Zmiana wyglądu sidebara wymaga teraz edycji jednego pliku.

## Gradient hero

Sekcja hero na stronie głównej miała statyczne ciemne tło. Wymieniłem je na gradient:

```blade
<section class="relative overflow-hidden bg-gradient-to-b from-slate-900 to-slate-950">
```

W tle wyświetla się obraz — osobny dla trybu jasnego i ciemnego — z niską przezroczystością (`opacity-25`). Gradient slate daje głębię bez odwracania uwagi od tekstu. Na wierzchu leży subtelna siatka (`opacity-[0.03]`) dodająca teksturę.

## Rezultat

Blog jest czytelny. Treść Markdowna ma poprawną typografię bez ręcznego stylowania każdego elementu. Sidebar jest współdzielony i spójny na wszystkich stronach z listami postów. Hero wygląda nowocześnie w obu trybach kolorystycznych.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-16-post-reading';

-- feature-16-post-reading [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Typography, sidebar & hero — readability first', 'Blog posts looked flat. Headings were the same size as body text, code blocks had no formatting, and lists blended into paragraphs. I added a typography plugin, extracted the sidebar into shared components, and replaced the hero background with a gradient',
         'Blog posts looked flat. Headings were the same size as body text, code blocks had no formatting, and lists blended into paragraphs. I added a typography plugin, extracted the sidebar into shared components, and replaced the hero background with a gradient.

## The content rendering problem

Post content is written in Markdown and converted via `Str::markdown()`. The output is plain HTML — `<h2>` headings, `<p>` paragraphs, `<pre><code>` blocks. Tailwind CSS resets all element styles by default, so an `<h2>` looks identical to a `<p>`. No margin, no font size difference.

## @tailwindcss/typography

The `@tailwindcss/typography` plugin adds a `prose` class that restores readable styles for Markdown-generated content:

```css
@import \'tailwindcss\';
@plugin \'@tailwindcss/typography\';
```

In the post view, I just wrapped the content:

```blade
<div class="prose prose-gray dark:prose-invert max-w-none">
    {!! \\Illuminate\\Support\\Str::markdown($post[\'content\'] ?? \'\') !!}
</div>
```

`prose-gray` sets a neutral color palette. `dark:prose-invert` flips colors in dark mode. `max-w-none` disables the default max-width — the parent column handles the layout.

The effect was immediate: headings have a size hierarchy, paragraphs have spacing, code blocks got backgrounds and rounded corners, blockquotes have a left border, lists have indentation and markers.

## Shared sidebar

The sidebar with recent posts and categories was duplicated across three views: post page, category page, and tag page. Same loops, same styles, same `@forelse`. Any change required editing three files.

I extracted it into two Blade components:

```blade
<x-recent-posts-sidebar :recentPosts="$recentPosts" />
<x-category-grid :categories="$categories" />
```

The `recent-posts-sidebar` component renders a list of recent posts with colored category initials. `category-grid` displays a grid of categories with post counts. Both accept data via props — the view does not need to know where the data comes from.

Each of the three views shrunk by ~60 lines. Changing the sidebar appearance now means editing one file.

## Hero gradient

The homepage hero section had a static dark background. I replaced it with a gradient:

```blade
<section class="relative overflow-hidden bg-gradient-to-b from-slate-900 to-slate-950">
```

A background image sits behind the content — separate for light and dark modes — at low opacity (`opacity-25`). The slate gradient adds depth without competing with the text. A subtle grid overlay (`opacity-[0.03]`) adds texture.

## Result

The blog is readable. Markdown content has proper typography without manually styling each element. The sidebar is shared and consistent across all post listing pages. The hero looks modern in both color modes.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-16-post-reading';

-- feature-17-author-dark-mode [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Autor na postach i ciemny motyw domyślnie', 'Posty nie pokazywały kto je napisał. API zwracało `author_id`, ale bez rozwinięcia relacji — frontend nie miał danych autora. Przy okazji zmieniłem domyślny motyw na ciemny dla nowych odwiedzających.',
         'Posty nie pokazywały kto je napisał. API zwracało `author_id`, ale bez rozwinięcia relacji — frontend nie miał danych autora. Przy okazji zmieniłem domyślny motyw na ciemny dla nowych odwiedzających.

## Autor w API

Blog API miał relację `author` na modelu `Post`, ale kontroler nie ładował jej eager loadingiem. Odpowiedź zawierała `author_id` jako liczbę — bezużyteczne dla frontendu.

Dodałem `->with(\'author\')` do zapytań w `PostController`:

```php
$posts = Post::with([\'categories\', \'tags\', \'translations\', \'author\'])
    ->where(\'status\', \'published\')
    ->latest(\'published_at\')
    ->paginate($perPage);
```

`PostResource` już miał wpis `\'author\' => new AuthorResource($this->author)`, ale zwracał `null` bo relacja nie była załadowana. Po dodaniu eager loadingu autor pojawił się w odpowiedzi z `name` i `id`.

## Autor na froncie

Na stronie posta autor wyświetla się między kategoriami a datą:

```blade
<div class="flex items-center text-sm text-gray-500 dark:text-gray-400 mb-4">
    @if($post[\'author\'][\'name\'] ?? null)
        <span>{{ $post[\'author\'][\'name\'] }}</span>
        <span class="mx-2">&middot;</span>
    @endif
    <time datetime="{{ $post[\'published_at\'] }}">
        {{ \\Carbon\\Carbon::parse($post[\'published_at\'])->format(\'d F Y\') }}
    </time>
</div>
```

Na karcie posta w listingach — imię autora pojawia się w stopce obok daty. Warunek `@if` zabezpiecza przed brakiem autora — starsze posty seedowane mogą nie mieć przypisanego autora.

## Autor w panelu admina

W Filament dodałem kolumnę autora do tabeli postów. Admin widzi kto napisał dany post bez wchodzenia w szczegóły. Kolumna pobiera dane z relacji `author.name` przez Blog API.

## Ciemny motyw domyślnie

Nowi odwiedzający widzieli jasny motyw — biały ekran, czarny tekst. Zmiana na ciemny wymagała kliknięcia przełącznika. Dla bloga technicznego, gdzie większość czytelników to programiści, ciemny motyw jest bardziej naturalnym wyborem.

Logika w layoucie sprawdza `localStorage` przed pierwszym renderem:

```javascript
(function(){
    var t = localStorage.getItem(\'theme\');
    if (t === \'light\' ? false : (t === \'auto\'
        ? window.matchMedia(\'(prefers-color-scheme: dark)\').matches
        : true)) {
        document.documentElement.classList.add(\'dark\');
    }
})();
```

Trzy ścieżki:
- `theme === \'light\'` → jasny motyw
- `theme === \'auto\'` → zgodnie z preferencjami systemowymi
- brak wartości (nowy użytkownik) → **ciemny motyw**

Skrypt wykonuje się w `<head>` przed renderowaniem — eliminuje efekt „białego flashu" przy ładowaniu strony.

## Rezultat

Posty pokazują autora. Admin widzi autorów w tabeli. Nowi odwiedzający widzą ciemny motyw bez konieczności zmiany ustawień. Przełącznik nadal działa — wybór zapisuje się w `localStorage` i jest respektowany przy kolejnych wizytach.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-17-author-dark-mode';

-- feature-17-author-dark-mode [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Author info on posts and dark mode by default', 'Posts did not show who wrote them. The API returned `author_id` as a number, but the author relation was never eager-loaded — the frontend had no author data. While I was at it, I switched the default theme to dark mode for new visitors.',
         'Posts did not show who wrote them. The API returned `author_id` as a number, but the author relation was never eager-loaded — the frontend had no author data. While I was at it, I switched the default theme to dark mode for new visitors.

## Author in the API

The Blog API had an `author` relation on the `Post` model, but the controller never loaded it. The response included `author_id` as an integer — useless for the frontend.

I added `->with(\'author\')` to the queries in `PostController`:

```php
$posts = Post::with([\'categories\', \'tags\', \'translations\', \'author\'])
    ->where(\'status\', \'published\')
    ->latest(\'published_at\')
    ->paginate($perPage);
```

`PostResource` already had `\'author\' => new AuthorResource($this->author)`, but it returned `null` because the relation was not loaded. Adding eager loading made the author appear in the response with `name` and `id`.

## Author on the frontend

On the post page, the author displays between the categories and the date:

```blade
<div class="flex items-center text-sm text-gray-500 dark:text-gray-400 mb-4">
    @if($post[\'author\'][\'name\'] ?? null)
        <span>{{ $post[\'author\'][\'name\'] }}</span>
        <span class="mx-2">&middot;</span>
    @endif
    <time datetime="{{ $post[\'published_at\'] }}">
        {{ \\Carbon\\Carbon::parse($post[\'published_at\'])->format(\'d F Y\') }}
    </time>
</div>
```

On post cards in listings, the author name appears in the footer next to the date. The `@if` guard handles posts without an author — older seeded posts may not have one assigned.

## Author in the admin panel

In Filament, I added an author column to the posts table. Admins can see who wrote a given post without drilling into the detail view. The column fetches data from the `author.name` relation via the Blog API.

## Dark mode by default

New visitors saw the light theme — white background, dark text. Switching to dark mode required clicking the toggle. For a tech blog where most readers are developers, dark mode is the more natural default.

The layout script checks `localStorage` before the first paint:

```javascript
(function(){
    var t = localStorage.getItem(\'theme\');
    if (t === \'light\' ? false : (t === \'auto\'
        ? window.matchMedia(\'(prefers-color-scheme: dark)\').matches
        : true)) {
        document.documentElement.classList.add(\'dark\');
    }
})();
```

Three paths:
- `theme === \'light\'` → light mode
- `theme === \'auto\'` → follows system preferences
- no stored value (new visitor) → **dark mode**

The script runs in `<head>` before rendering — it eliminates the white flash on page load.

## Result

Posts show their author. Admins see authors in the table. New visitors get dark mode without touching any settings. The toggle still works — the choice is saved in `localStorage` and respected on subsequent visits.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-17-author-dark-mode';

-- feature-18-category-widget [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Redesign kafelka kategorii — Alpine.js i gradient fadeout', 'Kafelek kategorii na stronie głównej zajmował za dużo miejsca. Przy 22 kategoriach siatka rozciągała się poza widoczny obszar i dominowała nad resztą treści. Przeprojektowałem go: mniejsze elementy, ograniczona wysokość z gradientem fadeout i przycisk roz',
         'Kafelek kategorii na stronie głównej zajmował za dużo miejsca. Przy 22 kategoriach siatka rozciągała się poza widoczny obszar i dominowała nad resztą treści. Przeprojektowałem go: mniejsze elementy, ograniczona wysokość z gradientem fadeout i przycisk rozwijania przez Alpine.js.

## Mniejsze kafelki

Wcześniej każda kategoria to był duży blok z pełną nazwą, licznikiem postów i marginesami. Zmniejszyłem je do kompaktowych elementów w siatce 2-kolumnowej:

```blade
<a href="{{ route(\'category.show\', $category[\'slug\']) }}"
   class="flex items-center justify-between px-3 py-2.5 rounded-lg {{ $colorClasses }} transition-all hover:opacity-80 hover:scale-[1.02]">
    <span class="text-sm font-medium truncate">{{ $category[\'name\'] }}</span>
    <span class="text-xs opacity-70 ml-1 shrink-0">{{ $category[\'posts_count\'] ?? 0 }}</span>
</a>
```

Każdy kafelek ma kolor kategorii jako tło, nazwę po lewej i licznik postów po prawej. `truncate` ucina długie nazwy. `hover:scale-[1.02]` daje subtelny efekt powiększenia przy najechaniu.

## Ograniczona wysokość z gradient fadeout

Siatka ma domyślnie `max-h-[11rem]` — mieści około 4 wierszy (8 kategorii). Reszta jest ukryta. Na dolnej krawędzi leży gradient przechodzący z przezroczystego do koloru tła:

```blade
<div x-show="!expanded"
     class="absolute bottom-0 left-0 right-0 h-12 bg-gradient-to-t from-white dark:from-gray-800 to-transparent pointer-events-none">
</div>
```

`from-white dark:from-gray-800` dopasowuje kolor gradientu do tła karty w obu trybach. `pointer-events-none` sprawia, że gradient nie blokuje kliknięć na kategorie pod spodem.

## Alpine.js — rozwiń / zwiń

Stan rozwinięcia kontroluje Alpine.js:

```blade
<div x-data="{ expanded: false }">
    <div class="grid grid-cols-2 gap-2 overflow-hidden transition-[max-height] duration-300 ease-in-out"
         :class="expanded ? \'max-h-[80rem]\' : \'max-h-[11rem]\'">
        {{-- kategorie --}}
    </div>

    <button @click="expanded = !expanded"
            class="mt-4 inline-flex items-center text-sm font-medium text-sky-700 dark:text-sky-400">
        <span x-text="expanded ? \'{{ __(\'general.less\') }}\' : \'{{ __(\'general.more\') }}\'"></span>
        <svg class="ml-1 w-4 h-4 transition-transform duration-300"
             :class="expanded ? \'rotate-90\' : \'\'" ...>
        </svg>
    </button>
</div>
```

Kliknięcie przycisku przełącza `expanded` między `true` i `false`. `transition-[max-height]` animuje zmianę wysokości. Gradient znika gdy kafelek jest rozwinięty (`x-show="!expanded"`). Tekst przycisku zmienia się między „Więcej" a „Mniej". Strzałka obraca się o 90° przy rozwinięciu.

## Fix: brakująca kategoria "Start Here"

Przy okazji naprawiłem problem z brakującą kategorią. API domyślnie zwracało 15 kategorii na stronę. Przy 22 kategoriach posortowanych alfabetycznie, "Start Here" była na pozycji 19 — poza pierwszą stroną.

```php
\'per_page\' => 100,
```

Jeden parametr w `BlogApiService::getCategories()` naprawił problem. Przy 22 kategoriach paginacja nie jest potrzebna.

## Rezultat

Kafelek kategorii jest kompaktowy i wyrównany z innymi widgetami na stronie głównej. Domyślnie pokazuje 8 kategorii z gradientowym fadeoutem. Przycisk „Więcej" rozwija pełną listę z płynną animacją. Wszystkie 22 kategorie — w tym „Start Here" — są teraz dostępne.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-18-category-widget';

-- feature-18-category-widget [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Category widget redesign — Alpine.js and gradient fadeout', 'The category widget on the homepage took up too much space. With 22 categories, the grid stretched beyond the visible area and dominated the rest of the content. I redesigned it: smaller elements, constrained height with a gradient fadeout, and an expand/',
         'The category widget on the homepage took up too much space. With 22 categories, the grid stretched beyond the visible area and dominated the rest of the content. I redesigned it: smaller elements, constrained height with a gradient fadeout, and an expand/collapse button powered by Alpine.js.

## Smaller tiles

Previously, each category was a large block with a full name, post count, and generous margins. I shrunk them into compact elements in a 2-column grid:

```blade
<a href="{{ route(\'category.show\', $category[\'slug\']) }}"
   class="flex items-center justify-between px-3 py-2.5 rounded-lg {{ $colorClasses }} transition-all hover:opacity-80 hover:scale-[1.02]">
    <span class="text-sm font-medium truncate">{{ $category[\'name\'] }}</span>
    <span class="text-xs opacity-70 ml-1 shrink-0">{{ $category[\'posts_count\'] ?? 0 }}</span>
</a>
```

Each tile uses the category color as its background, with the name on the left and the post count on the right. `truncate` clips long names. `hover:scale-[1.02]` gives a subtle zoom effect on hover.

## Constrained height with gradient fadeout

The grid defaults to `max-h-[11rem]` — roughly 4 rows (8 categories). The rest is hidden. A gradient overlay sits at the bottom edge, fading from transparent to the background color:

```blade
<div x-show="!expanded"
     class="absolute bottom-0 left-0 right-0 h-12 bg-gradient-to-t from-white dark:from-gray-800 to-transparent pointer-events-none">
</div>
```

`from-white dark:from-gray-800` matches the gradient to the card background in both modes. `pointer-events-none` ensures the gradient does not block clicks on categories underneath.

## Alpine.js — expand / collapse

The expanded state is controlled by Alpine.js:

```blade
<div x-data="{ expanded: false }">
    <div class="grid grid-cols-2 gap-2 overflow-hidden transition-[max-height] duration-300 ease-in-out"
         :class="expanded ? \'max-h-[80rem]\' : \'max-h-[11rem]\'">
        {{-- categories --}}
    </div>

    <button @click="expanded = !expanded"
            class="mt-4 inline-flex items-center text-sm font-medium text-sky-700 dark:text-sky-400">
        <span x-text="expanded ? \'{{ __(\'general.less\') }}\' : \'{{ __(\'general.more\') }}\'"></span>
        <svg class="ml-1 w-4 h-4 transition-transform duration-300"
             :class="expanded ? \'rotate-90\' : \'\'" ...>
        </svg>
    </button>
</div>
```

Clicking the button toggles `expanded` between `true` and `false`. `transition-[max-height]` animates the height change. The gradient disappears when the widget is expanded (`x-show="!expanded"`). The button text switches between "More" and "Less". The arrow rotates 90 degrees on expand.

## Fix: missing "Start Here" category

While working on this, I fixed a missing category bug. The API returned 15 categories per page by default. With 22 categories sorted alphabetically, "Start Here" landed at position 19 — beyond the first page.

```php
\'per_page\' => 100,
```

One parameter in `BlogApiService::getCategories()` fixed it. With 22 categories, pagination is not needed.

## Result

The category widget is compact and aligned with other widgets on the homepage. By default it shows 8 categories with a gradient fadeout. The "More" button expands the full list with a smooth animation. All 22 categories — including "Start Here" — are now accessible.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-18-category-widget';

-- feature-19-comments-likes [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Komentarze, polubienia i testy', 'Ten release zamknął kilka otwartych tematów naraz: formularz komentarzy dla zalogowanych użytkowników, wyświetlanie prawdziwej nazwy autora, naprawa polubień dla postów i komentarzy oraz pokrycie nowych funkcji testami.',
         'Ten release zamknął kilka otwartych tematów naraz: formularz komentarzy dla zalogowanych użytkowników, wyświetlanie prawdziwej nazwy autora, naprawa polubień dla postów i komentarzy oraz pokrycie nowych funkcji testami.

## Formularz komentarzy

Widok posta pokazywał listę komentarzy, ale nie dawał możliwości ich dodania z poziomu frontendu. Dodałem formularz widoczny wyłącznie dla użytkowników z rolą wyższą niż `guest`. Gościom wyświetla się zaproszenie do logowania.

```blade
@if(session(\'access_token\') && $canComment)
    <form method="POST" action="{{ route(\'post.comments.store\', $post[\'id\']) }}"
          x-data="{ chars: {{ strlen(old(\'content\', \'\')) }} }">
        @csrf
        <textarea name="content" maxlength="5000"
                  @input="chars = $el.value.length"
                  placeholder="{{ __(\'comments.content_placeholder\') }}">{{ old(\'content\') }}</textarea>

        <div :class="chars >= 5000 ? \'text-red-500\' : chars >= 4500 ? \'text-amber-500\' : \'text-gray-400\'">
            <span x-text="chars"></span> / 5000
        </div>

        <button type="submit">{{ __(\'comments.add_comment\') }}</button>
    </form>
@elseif(!session(\'access_token\'))
    {{-- zaproszenie do logowania --}}
@endif
```

Licznik znaków Alpine.js zmienia kolor na bursztynowy przy 4500 i czerwony przy 5000. Limit YouTube to 10 000 znaków — zdecydowałem się na 5000 jako rozsądny środek.

Nowy `CommentController` w serwisie `frontend` obsługuje zapis: waliduje treść, wywołuje API bloga (`POST /api/v1/comments`), a następnie natychmiast zatwierdza komentarz (`PATCH /api/v1/comments/{id}/approve`). Komentarze publikują się bez kolejki moderacji.

## Prawdziwa nazwa autora

Komentarze wyświetlały „User #1" zamiast nazwy. Przyczyna: `CommentResource` w serwisie `blog` zwracał tylko pole `author_id` — sam integer.

Serwis `blog` ma tabelę `authors` zsynchronizowaną z SSO przez RabbitMQ. Dodałem relację w modelu:

```php
public function author(): BelongsTo
{
    return $this->belongsTo(Author::class, \'author_id\', \'user_id\');
}
```

Ten sam wzorzec co `Post` — `author_id` w tabeli komentarzy odpowiada `user_id` w tabeli autorów. `CommentController` ładuje relację, `CommentResource` ekspozuje ją warunkowo:

```php
\'author\' => $this->whenLoaded(\'author\', fn() => [
    \'name\' => $this->author->name,
]),
```

Serwis `frontend` przekazuje `with=author` przy pobieraniu komentarzy do posta. Teraz widok pokazuje prawdziwe imię i nazwisko.

## Naprawa polubień

Polubienia nie działały ani dla postów, ani dla komentarzy. Diagnoza w dwóch etapach:

**Problem 1 — sesja.** Trzy miejsca w kodzie frontendu odczytywały `session(\'user_id\')`, które zawsze zwracało `null`. `OAuthController` zapisuje dane użytkownika jako zagnieżdżoną tablicę: `session([\'user\' => [\'id\' => ...]])`. Prawidłowy odczyt to notacja kropkowa Laravel: `session(\'user.id\')`.

**Problem 2 — baza danych analytics.** Logi Docker ujawniły `SQLSTATE[HY000] [1045] Access denied for user \'analytics\'`. Kontener MySQL był zainicjalizowany z użytkownikiem `app`, ale plik `analytics/.env` na poziomie Docker Compose miał `DB_USERNAME=analytics`. Sekcja `environment:` w `docker-compose.yml` nadpisuje wartości z `src/.env` — zmiana pliku aplikacyjnego nie wystarczyła. Poprawka: ujednolicenie nazwy użytkownika na `app` w obu plikach env.

**Problem 3 — obsługa błędów.** Przed naprawą, gdy analytics był niedostępny, `toggleLike()` zwracał HTTP 200 z `{liked: false, count: 0}`. JavaScript widział `res.ok = true` i „resetował" stan przycisku. Zmieniłem `AnalyticsApiService::toggleLike()` na zwracanie `null` przy błędzie, a trasa `/likes/toggle` odpowiada teraz HTTP 503. Frontend cofa optymistyczną aktualizację zamiast błędnie zmieniać stan.

## Testy

Nowe funkcje dostały pokrycie testami:

**Serwis blog** — `CommentApiTest`:
- walidacja `max:5000` zwraca 422
- lista komentarzy zawiera `author.name` gdy rekord autora istnieje
- `author` jest `null` gdy brak rekordu w tabeli `authors`
- widok pojedynczego komentarza zawiera `author.name`

Przy okazji dodałem brakującą `AuthorFactory`.

**Serwis frontend** — `BlogApiServiceTest` i nowy `CommentControllerTest`:
- niezalogowany użytkownik → przekierowanie na `/oauth/login`
- rola `guest` → HTTP 403
- za krótka / za długa treść → błąd walidacji
- sukces → przekierowanie z flashem `comment_success`
- błąd API bloga → przekierowanie z komunikatem błędu
- `createComment` i `approveComment` w `BlogApiService` — sukces i niepowodzenie

## Skrypt dev.sh — podpolecenie `test`

Dodałem subkomendę `test` do `dev.sh`:

```bash
./dev.sh test                              # wszystkie serwisy
./dev.sh test -- blog frontend             # wybrane serwisy
./dev.sh test -- blog -- --filter Foo      # filtr artisan
```

Skrypt uruchamia `php artisan test` wewnątrz kontenera każdego serwisu, zbiera wyniki i na końcu zwraca exit code 1 z listą serwisów, które nie przeszły.

## Wersje

- `blog` → `v0.5.0` (nowy minor: relacja autora, nowe dane w API)
- `frontend` → `v1.15.0` (nowy minor: formularz komentarzy, naprawa polubień)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-19-comments-likes';

-- feature-19-comments-likes [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Comments, likes and tests', 'This release closed several open threads at once: a comment form for authenticated users, real author names in comments, a fix for broken likes on both posts and comments, and test coverage for all of the above.',
         'This release closed several open threads at once: a comment form for authenticated users, real author names in comments, a fix for broken likes on both posts and comments, and test coverage for all of the above.

## Comment form

The post view showed a list of comments but offered no way to add one from the frontend. I added a form visible only to users with a role above `guest`. Guests see a login prompt instead.

```blade
@if(session(\'access_token\') && $canComment)
    <form method="POST" action="{{ route(\'post.comments.store\', $post[\'id\']) }}"
          x-data="{ chars: {{ strlen(old(\'content\', \'\')) }} }">
        @csrf
        <textarea name="content" maxlength="5000"
                  @input="chars = $el.value.length"
                  placeholder="{{ __(\'comments.content_placeholder\') }}">{{ old(\'content\') }}</textarea>

        <div :class="chars >= 5000 ? \'text-red-500\' : chars >= 4500 ? \'text-amber-500\' : \'text-gray-400\'">
            <span x-text="chars"></span> / 5000
        </div>

        <button type="submit">{{ __(\'comments.add_comment\') }}</button>
    </form>
@elseif(!session(\'access_token\'))
    {{-- login prompt --}}
@endif
```

The Alpine.js character counter turns amber at 4 500 and red at 5 000. YouTube\'s limit is 10 000 — I settled on 5 000 as a reasonable middle ground.

A new `CommentController` in the `frontend` service handles submission: it validates the content, calls the blog API (`POST /api/v1/comments`), then immediately approves the comment (`PATCH /api/v1/comments/{id}/approve`). Comments go live without a moderation queue.

## Real author names

Comments displayed "User #1" instead of a name. The cause: `CommentResource` in the `blog` service only returned the `author_id` integer field.

The `blog` service has an `authors` table kept in sync with SSO via RabbitMQ. I added the relation to the model:

```php
public function author(): BelongsTo
{
    return $this->belongsTo(Author::class, \'author_id\', \'user_id\');
}
```

Same pattern as `Post` — `author_id` in the comments table maps to `user_id` in the authors table. `CommentController` eager-loads the relation and `CommentResource` exposes it conditionally:

```php
\'author\' => $this->whenLoaded(\'author\', fn() => [
    \'name\' => $this->author->name,
]),
```

The `frontend` service passes `with=author` when fetching a post\'s comments. The view now shows a real name.

## Fixing likes

Likes were broken for both posts and comments. The diagnosis came in two stages:

**Problem 1 — session.** Three places in the frontend read `session(\'user_id\')`, which always returns `null`. `OAuthController` stores user data as a nested array: `session([\'user\' => [\'id\' => ...]])`. The correct read uses Laravel\'s dot-notation: `session(\'user.id\')`.

**Problem 2 — analytics database.** Docker logs revealed `SQLSTATE[HY000] [1045] Access denied for user \'analytics\'`. The MySQL volume was initialised with user `app`, but the `analytics/.env` at the Docker Compose level had `DB_USERNAME=analytics`. The `environment:` section in `docker-compose.yml` overrides values from `src/.env` — fixing only the application env file was not enough. The fix was unifying the username to `app` in both env files.

**Problem 3 — error handling.** Before the fix, when analytics was unavailable `toggleLike()` returned HTTP 200 with `{liked: false, count: 0}`. JavaScript saw `res.ok = true` and "reset" the button state. I changed `AnalyticsApiService::toggleLike()` to return `null` on failure, and the `/likes/toggle` route now responds with HTTP 503. The frontend rolls back the optimistic update instead of incorrectly flipping the button.

## Tests

New features got test coverage:

**blog service** — `CommentApiTest`:
- `max:5000` validation returns 422
- comment list includes `author.name` when an author record exists
- `author` is `null` when no record exists in the `authors` table
- single comment view includes `author.name`

I also added the missing `AuthorFactory`.

**frontend service** — `BlogApiServiceTest` and a new `CommentControllerTest`:
- unauthenticated user → redirect to `/oauth/login`
- `guest` role → HTTP 403
- content too short / too long → validation error
- success → redirect with `comment_success` flash
- blog API failure → redirect with error message
- `createComment` and `approveComment` in `BlogApiService` — success and failure cases

## dev.sh — test subcommand

I added a `test` subcommand to `dev.sh`:

```bash
./dev.sh test                              # all services
./dev.sh test -- blog frontend             # selected services
./dev.sh test -- blog -- --filter Foo      # artisan filter
```

The script runs `php artisan test` inside each service\'s container, collects results and exits with code 1 along with a list of failing services.

## Versions

- `blog` → `v0.5.0` (new minor: author relation, new data in API)
- `frontend` → `v1.15.0` (new minor: comment form, likes fix)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-19-comments-likes';

-- feature-20-production-monitoring [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Monitoring produkcyjny na Kubernetes', 'Stos monitoringu, który do tej pory działał lokalnie na Docker Compose, wylądował na produkcyjnym klastrze Kubernetes (OVH Managed Kubernetes). Prometheus, Grafana, Loki i Promtail — ten sam zestaw, ale zainstalowany przez Helm i dostępny z zewnątrz pod w',
         'Stos monitoringu, który do tej pory działał lokalnie na Docker Compose, wylądował na produkcyjnym klastrze Kubernetes (OVH Managed Kubernetes). Prometheus, Grafana, Loki i Promtail — ten sam zestaw, ale zainstalowany przez Helm i dostępny z zewnątrz pod własnymi subdomenami.

## Instalacja przez Helm

Lokalnie stos startował przez `docker-compose.yml` z ręczną konfiguracją. Na Kubernetes użyłem dwóch chartów Helm:

```bash
helm install kube-prometheus prometheus-community/kube-prometheus-stack \\
  -n monitoring --create-namespace \\
  -f k8s/helm-values/kube-prometheus-stack-values.yaml

helm install loki grafana/loki-stack \\
  -n monitoring \\
  -f k8s/helm-values/loki-stack-values.yaml
```

`kube-prometheus-stack` instaluje Prometheus, Grafanę, Alertmanager, node-exporter i kube-state-metrics. `loki-stack` dodaje Loki i Promtail jako DaemonSet na każdym node.

## Promtail i containerd

Pierwsza wersja konfiguracji montowała `/var/lib/docker/containers` — standardowa ścieżka dla Dockera. OVH Managed Kubernetes używa containerd, a logi trafiają do `/var/log/pods/`.

Promtail startował, ale nie znajdował żadnych plików logów. Fix wymagał trzech zmian:

```yaml
# loki-stack-values.yaml
promtail:
  extraVolumes:
    - name: pods
      hostPath:
        path: /var/log/pods
  extraVolumeMounts:
    - name: pods
      mountPath: /var/log/pods
      readOnly: true
  config:
    snippets:
      scrapeConfigs: |
        - job_name: kubernetes-pods
          kubernetes_sd_configs:
            - role: pod
          pipeline_stages:
            - cri: {}
          relabel_configs:
            - source_labels:
                - __meta_kubernetes_pod_uid
                - __meta_kubernetes_pod_container_name
              separator: /
              replacement: /var/log/pods/*$1/$2/*.log
              target_label: __path__
```

Kluczowe elementy: `pipeline_stages: - cri: {}` parsuje format logów containerd (nie Docker JSON), a relabel z `__meta_kubernetes_pod_uid` buduje ścieżkę `/var/log/pods/*/uid/container/*.log`.

## Metryki nginx-ingress

Na lokalnym dev monitorowałem Traefik jako reverse proxy. Na produkcji ruch przechodzi przez nginx-ingress controller. Domyślnie nie eksponował on szczegółowych metryk HTTP.

Włączenie wymagało dwóch kroków: dodania flagi `--enable-metrics=true` i portu 10254 w deploymencie, a następnie stworzenia Service i ServiceMonitor:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: ingress-nginx
  namespace: monitoring
  labels:
    release: kube-prometheus
spec:
  namespaceSelector:
    matchNames:
      - ingress-nginx
  selector:
    matchLabels:
      app.kubernetes.io/name: ingress-nginx
  endpoints:
    - port: metrics
      interval: 15s
```

Label `release: kube-prometheus` jest wymagany — Prometheus Operator filtruje ServiceMonitory po tym labelu.

## Dostęp z zewnątrz

Oba panele dostępne są pod własnymi subdomenami z TLS (Let\'s Encrypt przez cert-manager):

- `grafana.borowski.services` — Grafana z loginem
- `prometheus.borowski.services` — Prometheus UI

Początkowo chroniłem dostęp przez IP whitelist w annotacji nginx:

```yaml
nginx.ingress.kubernetes.io/whitelist-source-range: "79.186.58.130/32"
```

Nie zadziałało. Load balancer OVH robi SNAT — nginx widział IP load balancera (`146.59.117.234`), nie prawdziwe IP klienta. Próba włączenia proxy protocol zepsuła połączenia (LB go nie wysyła). Rozwiązanie: basic auth zamiast whitelisty.

```yaml
nginx.ingress.kubernetes.io/auth-type: basic
nginx.ingress.kubernetes.io/auth-secret: monitoring-basic-auth
nginx.ingress.kubernetes.io/auth-realm: "Monitoring"
```

Secret `monitoring-basic-auth` wygenerowany przez `htpasswd`. Grafana ma dodatkowo własny login — podwójna warstwa.

## Dashboardy

Dashboardy ładowane są automatycznie przez sidecar Grafany. ConfigMap z labelem `grafana_dashboard=1` jest wykrywany i importowany bez restartu:

- **Portfolio Services Dashboard** — request rate, latency (p50/p95/p99), error rate i logi z Loki
- **Loki Logs — Portfolio** — przeglądarka logów z filtrowaniem po namespace, pod i kontenerze

Zapytania zostały przepisane z Traefika na nginx-ingress (`nginx_ingress_controller_requests` zamiast `traefik_service_requests_total`). Szczegóły konfiguracji dashboardów opisałem w osobnym artykule.

## Wersje

- `infra` → `v0.1.0` (nowy minor: monitoring produkcyjny, cert-manager, nginx configs, basic auth)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-20-production-monitoring';

-- feature-20-production-monitoring [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Production monitoring on Kubernetes', 'The monitoring stack that had been running locally on Docker Compose landed on the production Kubernetes cluster (OVH Managed Kubernetes). Prometheus, Grafana, Loki and Promtail — the same set, but installed via Helm and accessible externally under dedica',
         'The monitoring stack that had been running locally on Docker Compose landed on the production Kubernetes cluster (OVH Managed Kubernetes). Prometheus, Grafana, Loki and Promtail — the same set, but installed via Helm and accessible externally under dedicated subdomains.

## Installation via Helm

Locally the stack started through `docker-compose.yml` with manual configuration. On Kubernetes I used two Helm charts:

```bash
helm install kube-prometheus prometheus-community/kube-prometheus-stack \\
  -n monitoring --create-namespace \\
  -f k8s/helm-values/kube-prometheus-stack-values.yaml

helm install loki grafana/loki-stack \\
  -n monitoring \\
  -f k8s/helm-values/loki-stack-values.yaml
```

`kube-prometheus-stack` installs Prometheus, Grafana, Alertmanager, node-exporter and kube-state-metrics. `loki-stack` adds Loki and Promtail as a DaemonSet on every node.

## Promtail and containerd

The first configuration mounted `/var/lib/docker/containers` — the standard path for Docker. OVH Managed Kubernetes uses containerd, and logs go to `/var/log/pods/`.

Promtail started but found no log files. The fix required three changes:

```yaml
# loki-stack-values.yaml
promtail:
  extraVolumes:
    - name: pods
      hostPath:
        path: /var/log/pods
  extraVolumeMounts:
    - name: pods
      mountPath: /var/log/pods
      readOnly: true
  config:
    snippets:
      scrapeConfigs: |
        - job_name: kubernetes-pods
          kubernetes_sd_configs:
            - role: pod
          pipeline_stages:
            - cri: {}
          relabel_configs:
            - source_labels:
                - __meta_kubernetes_pod_uid
                - __meta_kubernetes_pod_container_name
              separator: /
              replacement: /var/log/pods/*$1/$2/*.log
              target_label: __path__
```

Key elements: `pipeline_stages: - cri: {}` parses the containerd log format (not Docker JSON), and the relabel using `__meta_kubernetes_pod_uid` builds the path `/var/log/pods/*/uid/container/*.log`.

## nginx-ingress metrics

On local dev I monitored Traefik as the reverse proxy. In production, traffic flows through the nginx-ingress controller. By default it did not expose detailed HTTP metrics.

Enabling them required two steps: adding the `--enable-metrics=true` flag and port 10254 to the deployment, then creating a Service and ServiceMonitor:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: ingress-nginx
  namespace: monitoring
  labels:
    release: kube-prometheus
spec:
  namespaceSelector:
    matchNames:
      - ingress-nginx
  selector:
    matchLabels:
      app.kubernetes.io/name: ingress-nginx
  endpoints:
    - port: metrics
      interval: 15s
```

The `release: kube-prometheus` label is required — Prometheus Operator filters ServiceMonitors by this label.

## External access

Both panels are available under dedicated subdomains with TLS (Let\'s Encrypt via cert-manager):

- `grafana.borowski.services` — Grafana with login
- `prometheus.borowski.services` — Prometheus UI

Initially I protected access with an IP whitelist via an nginx annotation:

```yaml
nginx.ingress.kubernetes.io/whitelist-source-range: "79.186.58.130/32"
```

It did not work. The OVH load balancer performs SNAT — nginx saw the load balancer\'s IP (`146.59.117.234`), not the real client IP. Attempting to enable proxy protocol broke connections (the LB does not send it). The solution: basic auth instead of a whitelist.

```yaml
nginx.ingress.kubernetes.io/auth-type: basic
nginx.ingress.kubernetes.io/auth-secret: monitoring-basic-auth
nginx.ingress.kubernetes.io/auth-realm: "Monitoring"
```

The `monitoring-basic-auth` secret was generated with `htpasswd`. Grafana has its own login on top — a double layer.

## Dashboards

Dashboards are loaded automatically by the Grafana sidecar. A ConfigMap with the `grafana_dashboard=1` label is detected and imported without a restart:

- **Portfolio Services Dashboard** — request rate, latency (p50/p95/p99), error rate and Loki logs
- **Loki Logs — Portfolio** — log browser with filtering by namespace, pod and container

Queries were rewritten from Traefik to nginx-ingress (`nginx_ingress_controller_requests` instead of `traefik_service_requests_total`). Dashboard configuration details are covered in a separate article.

## Versions

- `infra` → `v0.1.0` (new minor: production monitoring, cert-manager, nginx configs, basic auth)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-20-production-monitoring';

-- feature-21-media-lightbox [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Media management, lightbox i picker w edytorze', 'Trzy powiązane zmiany wokół obrazków: API do zarządzania mediami z automatycznym generowaniem wariantów, lightbox do powiększania zdjęć w postach i picker do wstawiania obrazków z poziomu edytora Markdown.',
         'Trzy powiązane zmiany wokół obrazków: API do zarządzania mediami z automatycznym generowaniem wariantów, lightbox do powiększania zdjęć w postach i picker do wstawiania obrazków z poziomu edytora Markdown.

## Media API w serwisie blog

Do tej pory obrazki w postach były linkowane ręcznie jako URL-e. Brakowało centralnego miejsca do uploadu i zarządzania plikami. Nowy moduł media w serwisie `blog` dostarcza pełne CRUD przez internal API:

- `POST /api/internal/media` — upload z automatycznym przetwarzaniem
- `GET /api/internal/media` — lista z paginacją
- `PATCH /api/internal/media/{id}` — aktualizacja alt textu
- `DELETE /api/internal/media/{id}` — usunięcie pliku i wariantów
- `GET /api/v1/media` — publiczny endpoint dla zalogowanych (do media pickera)

### Warianty obrazków

Każdy upload przechodzi przez Intervention Image v3 (driver GD). Serwis generuje do trzech wariantów w formacie WebP:

```php
private const VARIANTS = [
    \'thumbnail\' => 150,   // miniaturka do grid view
    \'medium\'    => 768,   // do treści posta
    \'large\'     => 1200,  // do lightboxa
];
```

Wariant powstaje tylko gdy oryginał jest szerszy niż docelowa szerokość — nie ma sensu skalować 100px obrazka do 768px. Konwersja do WebP z quality 80 daje ~60-70% oszczędności rozmiaru względem PNG.

```php
$variant = clone $image;
$encoded = $variant
    ->scaleDown(width: $targetWidth)
    ->toWebp(quality: 80);

Storage::disk(\'public\')->put($variantPath, (string) $encoded);
```

### CDN

Warianty serwowane są z dedykowanej subdomeny CDN. `MediaResource` buduje URL-e wariantów:

```php
\'variant_urls\' => $variants ? collect($variants)->mapWithKeys(
    fn ($path, $name) => [$name => $cdnUrl . \'/storage/\' . $path]
) : null,
```

Nginx na serwisie blog ma dodane nagłówki CORS dla `/storage/media/`, żeby frontend mógł pobierać obrazki z innej domeny.

## Image lightbox na frontendzie

Kliknięcie dowolnego obrazka w treści posta otwiera go w fullscreenowym overlay. Komponent Alpine.js nasłuchuje na custom event `open-lightbox`:

```blade
<div class="prose" @click="if ($event.target.tagName === \'IMG\')
    $dispatch(\'open-lightbox\', { src: $event.target.src, alt: $event.target.alt })">
    {!! Str::markdown($post[\'content\']) !!}
</div>
```

Lightbox zamyka się na kliknięcie tła, przycisk X lub klawisz Escape. Żadnych dodatkowych zależności — Alpine.js już jest bundlowany z Livewire.

## Media picker w edytorze

Panel użytkownika do tworzenia postów dostał przycisk „wstaw obrazek" w toolbarze. Kliknięcie otwiera modal z siatką miniaturek pobranych z API (`GET /panel/media`). Po wybraniu obrazka wstawiany jest Markdown:

```
![alt text](https://cdn.example.com/storage/media/2026/04/uuid_large.webp)
```

Picker automatycznie wybiera wariant `large` (1200px) — najlepszy kompromis między jakością a rozmiarem dla treści bloga.

## Wersje

- `blog` → `v0.7.1` (media CRUD, warianty, CDN, 46 testów)
- `admin` → `v0.5.0` (strona media management, picker w edytorze)
- `frontend` → `v1.17.0` (lightbox), `v1.18.0` (media picker w panelu)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-21-media-lightbox';

-- feature-21-media-lightbox [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Media management, lightbox and editor picker', 'Three related changes around images: a media management API with automatic variant generation, a lightbox for enlarging images in posts, and a picker for inserting images from the Markdown editor.',
         'Three related changes around images: a media management API with automatic variant generation, a lightbox for enlarging images in posts, and a picker for inserting images from the Markdown editor.

## Media API in the blog service

Until now, images in posts were linked manually as URLs. There was no central place to upload and manage files. The new media module in the `blog` service provides full CRUD through the internal API:

- `POST /api/internal/media` — upload with automatic processing
- `GET /api/internal/media` — paginated list
- `PATCH /api/internal/media/{id}` — update alt text
- `DELETE /api/internal/media/{id}` — delete file and variants
- `GET /api/v1/media` — public endpoint for authenticated users (for the media picker)

### Image variants

Every upload goes through Intervention Image v3 (GD driver). The service generates up to three WebP variants:

```php
private const VARIANTS = [
    \'thumbnail\' => 150,   // grid view thumbnail
    \'medium\'    => 768,   // post content
    \'large\'     => 1200,  // lightbox
];
```

A variant is only created when the original is wider than the target width — there is no point scaling a 100px image up to 768px. WebP conversion at quality 80 saves ~60-70% compared to PNG.

```php
$variant = clone $image;
$encoded = $variant
    ->scaleDown(width: $targetWidth)
    ->toWebp(quality: 80);

Storage::disk(\'public\')->put($variantPath, (string) $encoded);
```

### CDN

Variants are served from a dedicated CDN subdomain. `MediaResource` builds variant URLs:

```php
\'variant_urls\' => $variants ? collect($variants)->mapWithKeys(
    fn ($path, $name) => [$name => $cdnUrl . \'/storage/\' . $path]
) : null,
```

Nginx on the blog service has CORS headers added for `/storage/media/` so the frontend can fetch images from a different domain.

## Image lightbox on the frontend

Clicking any image in post content opens it in a fullscreen overlay. The Alpine.js component listens for a custom `open-lightbox` event:

```blade
<div class="prose" @click="if ($event.target.tagName === \'IMG\')
    $dispatch(\'open-lightbox\', { src: $event.target.src, alt: $event.target.alt })">
    {!! Str::markdown($post[\'content\']) !!}
</div>
```

The lightbox closes on backdrop click, X button or the Escape key. No extra dependencies — Alpine.js is already bundled with Livewire.

## Media picker in the editor

The user panel post editor got an "insert image" button in the toolbar. Clicking it opens a modal with a thumbnail grid fetched from the API (`GET /panel/media`). After selecting an image, Markdown is inserted:

```
![alt text](https://cdn.example.com/storage/media/2026/04/uuid_large.webp)
```

The picker automatically selects the `large` variant (1200px) — the best trade-off between quality and file size for blog content.

## Versions

- `blog` → `v0.7.1` (media CRUD, variants, CDN, 46 tests)
- `admin` → `v0.5.0` (media management page, editor picker)
- `frontend` → `v1.17.0` (lightbox), `v1.18.0` (media picker in panel)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-21-media-lightbox';

-- feature-22-seo-i18n [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'SEO meta tagi i tłumaczenia stron', 'Dwie niezależne zmiany poprawiające widoczność i dostępność strony: meta tagi Open Graph / Twitter Card dla podglądów linków oraz tłumaczenia kolejnych podstron.',
         'Dwie niezależne zmiany poprawiające widoczność i dostępność strony: meta tagi Open Graph / Twitter Card dla podglądów linków oraz tłumaczenia kolejnych podstron.

## Open Graph i Twitter Card

Udostępnienie linka do bloga na Slacku, Discordzie czy Facebooku dawało generyczny podgląd bez tytułu, opisu ani obrazka. Brakowało meta tagów OG i Twitter Card.

Dodałem je w głównym layoucie (`app.blade.php`) z rozsądnymi domyślnymi wartościami:

```blade
<meta property="og:type" content="@yield(\'og_type\', \'website\')">
<meta property="og:title" content="@yield(\'og_title\', \'Extended\\Mind::Thesis()\')">
<meta property="og:description" content="@yield(\'og_description\', \'Blog techniczny...\')">
<meta property="og:image" content="@yield(\'og_image\', url(\'/images/og-cover.png\'))">

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="@yield(\'og_title\', \'Extended\\Mind::Thesis()\')">
```

Widok posta nadpisuje wartości dynamicznie:

```blade
@section(\'og_type\', \'article\')
@section(\'og_title\', $post[\'title\'])
@section(\'og_description\', Str::limit(strip_tags(Str::markdown($post[\'content\'])), 160))
@section(\'og_image\', $post[\'cover_image\'])
```

Domyślny obrazek `og-cover.png` (1200x630px) wyświetla się dla stron bez dedykowanego obrazka — strona główna, about, kontakt. Posty z cover image dostają swój obrazek.

Kluczowe: `twitter:card` ustawione na `summary_large_image` daje duży podgląd obrazka na Twitterze/X. `og:locale` zmienia się dynamicznie w zależności od aktywnego języka (`pl_PL` / `en_US`).

## Tłumaczenia strony collaboration

Strona `/collaboration` miała hardkodowane polskie teksty w szablonie. Przeniosłem je do plików tłumaczeń:

- `lang/pl/collaboration.php` — 20 kluczy
- `lang/en/collaboration.php` — 20 kluczy

Obejmuje to sekcje: nagłówek, co oferuję (dev, code review, consulting), jak wygląda proces współpracy (4 kroki) i CTA.

```blade
{{-- Przed --}}
<h2>Co oferuję</h2>
<p>Tworzenie aplikacji webowych w Laravel...</p>

{{-- Po --}}
<h2>{{ __(\'collaboration.offer_heading\') }}</h2>
<p>{{ $service[\'desc\'] }}</p>
```

## Wersje

- `frontend` → `v1.19.0` (tłumaczenia collaboration), `v1.20.0` (meta tagi OG/Twitter)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-22-seo-i18n';

-- feature-22-seo-i18n [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'SEO meta tags and page translations', 'Two independent changes improving the site\'s visibility and accessibility: Open Graph / Twitter Card meta tags for link previews and translations of additional pages.',
         'Two independent changes improving the site\'s visibility and accessibility: Open Graph / Twitter Card meta tags for link previews and translations of additional pages.

## Open Graph and Twitter Card

Sharing a blog link on Slack, Discord or Facebook produced a generic preview with no title, description or image. OG and Twitter Card meta tags were missing.

I added them to the main layout (`app.blade.php`) with sensible defaults:

```blade
<meta property="og:type" content="@yield(\'og_type\', \'website\')">
<meta property="og:title" content="@yield(\'og_title\', \'Extended\\Mind::Thesis()\')">
<meta property="og:description" content="@yield(\'og_description\', \'Tech blog...\')">
<meta property="og:image" content="@yield(\'og_image\', url(\'/images/og-cover.png\'))">

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="@yield(\'og_title\', \'Extended\\Mind::Thesis()\')">
```

The post view overrides values dynamically:

```blade
@section(\'og_type\', \'article\')
@section(\'og_title\', $post[\'title\'])
@section(\'og_description\', Str::limit(strip_tags(Str::markdown($post[\'content\'])), 160))
@section(\'og_image\', $post[\'cover_image\'])
```

The default `og-cover.png` (1200x630px) is shown for pages without a dedicated image — the homepage, about, contact. Posts with a cover image get their own.

Key detail: `twitter:card` set to `summary_large_image` gives a large image preview on Twitter/X. `og:locale` changes dynamically based on the active language (`pl_PL` / `en_US`).

## Collaboration page translations

The `/collaboration` page had hardcoded Polish text in the template. I moved everything to translation files:

- `lang/pl/collaboration.php` — 20 keys
- `lang/en/collaboration.php` — 20 keys

This covers: the header, what I offer (dev, code review, consulting), the collaboration process (4 steps) and the CTA.

```blade
{{-- Before --}}
<h2>Co oferuję</h2>
<p>Tworzenie aplikacji webowych w Laravel...</p>

{{-- After --}}
<h2>{{ __(\'collaboration.offer_heading\') }}</h2>
<p>{{ $service[\'desc\'] }}</p>
```

## Versions

- `frontend` → `v1.19.0` (collaboration translations), `v1.20.0` (OG/Twitter meta tags)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-22-seo-i18n';

-- feature-23-contact-form [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Formularz kontaktowy z powiadomieniami email', 'Strona kontaktowa miała formularz, ale kliknięcie „Wyślij" nie robiło nic — brakowało backendu. Ten release dodaje pełny pipeline: walidacja, zapis do bazy, wysyłka maila i panel administracyjny do przeglądania zgłoszeń.',
         'Strona kontaktowa miała formularz, ale kliknięcie „Wyślij" nie robiło nic — brakowało backendu. Ten release dodaje pełny pipeline: walidacja, zapis do bazy, wysyłka maila i panel administracyjny do przeglądania zgłoszeń.

## Formularz i walidacja

Formularz na `/contact` wysyła dane AJAX-em (Alpine.js `fetch`). `ContactController` waliduje pola:

```php
$validator = Validator::make($request->all(), [
    \'name\'    => [\'required\', \'string\', \'max:100\'],
    \'email\'   => [\'required\', \'email\', \'max:150\'],
    \'phone\'   => [\'nullable\', \'string\', \'max:20\'],
    \'subject\' => [\'required\', \'string\', \'max:200\'],
    \'message\' => [\'required\', \'string\', \'min:10\', \'max:5000\'],
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
            \'form_type\' => $formType,
            \'url\'       => request()->url(),
            \'payload\'   => $data,
            \'sent_at\'   => null,
        ]);

        Mail::to(config(\'mail.contact_to\'))->send($mailable);

        $submission->update([\'sent_at\' => now()]);
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
- `admin` → `v0.6.0` (strona zarządzania zgłoszeniami, FrontendApiService)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-23-contact-form';

-- feature-23-contact-form [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Contact form with email notifications', 'The contact page had a form, but clicking "Send" did nothing — the backend was missing. This release adds the full pipeline: validation, database persistence, email dispatch and an admin panel for reviewing submissions.',
         'The contact page had a form, but clicking "Send" did nothing — the backend was missing. This release adds the full pipeline: validation, database persistence, email dispatch and an admin panel for reviewing submissions.

## Form and validation

The form on `/contact` sends data via AJAX (Alpine.js `fetch`). `ContactController` validates the fields:

```php
$validator = Validator::make($request->all(), [
    \'name\'    => [\'required\', \'string\', \'max:100\'],
    \'email\'   => [\'required\', \'email\', \'max:150\'],
    \'phone\'   => [\'nullable\', \'string\', \'max:20\'],
    \'subject\' => [\'required\', \'string\', \'max:200\'],
    \'message\' => [\'required\', \'string\', \'min:10\', \'max:5000\'],
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
            \'form_type\' => $formType,
            \'url\'       => request()->url(),
            \'payload\'   => $data,
            \'sent_at\'   => null,
        ]);

        Mail::to(config(\'mail.contact_to\'))->send($mailable);

        $submission->update([\'sent_at\' => now()]);
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
- `admin` → `v0.6.0` (form submissions management page, FrontendApiService)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-23-contact-form';

-- feature-24-light-theme [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Zmiękczenie jasnego motywu', 'Feedback od użytkownika: jasny motyw strony ma zbyt duży kontrast i jest niewygodny w przeglądaniu. Diagnoza potwierdziła problem — czysto biały (`#ffffff`) tekst na kartach i prawie czarny tekst (`text-gray-900`) dawały stosunek kontrastu ~19.5:1. WCAG w',
         'Feedback od użytkownika: jasny motyw strony ma zbyt duży kontrast i jest niewygodny w przeglądaniu. Diagnoza potwierdziła problem — czysto biały (`#ffffff`) tekst na kartach i prawie czarny tekst (`text-gray-900`) dawały stosunek kontrastu ~19.5:1. WCAG wymaga minimum 4.5:1. Technicznie dostępne, ale wizualnie ostre i męczące dla oczu.

## Problem

Paleta jasnego motywu opierała się na trzech wartościach:
- Tło strony: `bg-gray-50` (`#f9fafb`)
- Karty: `bg-white` (`#ffffff`)
- Tekst: `text-gray-900` (`#111827`)

Biała karta na prawie białym tle = minimalne rozróżnienie powierzchni. Czarny tekst na białym = maksymalny kontrast. Efekt: strona wyglądała klinicznie i oślepiała przy dłuższym czytaniu.

## Rozwiązanie

Zamiast CSS custom properties czy refaktoru systemu kolorów, zdecydowałem się na bezpośrednią zamianę klas Tailwind. Skala zmian jest zarządzalna (~17 plików Blade), a każda zmiana dotyczy wyłącznie light mode — klasy `dark:` pozostały nietknięte.

Tabela mapowania:

| Element | Przed | Po |
|---------|-------|------|
| Tło strony | `bg-gray-50` | `bg-gray-100` |
| Karty | `bg-white` | `bg-gray-50` |
| Header | `bg-white/80` | `bg-gray-50/80` |
| Tekst główny | `text-gray-900` | `text-gray-800` |
| Wewnętrzne bordy | `border-gray-100` | `border-gray-200` |
| Tagi | `bg-gray-100` | `bg-gray-200/60` |
| Hero tło | `#fefefe` | `#f3f4f6` |

Nowy kontrast tekstu `text-gray-800` na `bg-gray-50` = ~15:1. Wciąż WCAG AAA, ale subiektywnie łagodniejszy.

## Wyjątki

Nie wszystko przeszło z `bg-white` na `bg-gray-50`:
- **Inputy formularzy** — zostały `bg-white`, żeby tworzyły efekt „wgłębienia" na tle karty `bg-gray-50`
- **Dropdown menu** — `bg-white` dla efektu „uniesienia" (element nakładkowy)
- **Newsletter CTA** — sekcja z ciemnym gradientem, nie dotknięta zmianą

## Gradient fade w kategoriach

Komponent `category-grid` ma gradient maskujący dolną krawędź listy:

```blade
<div class="bg-gradient-to-t from-white dark:from-gray-800 to-transparent"></div>
```

Po zmianie karty na `bg-gray-50`, gradient `from-white` tworzył widoczną granicę. Zmiana na `from-gray-50` przywróciła płynne zanikanie.

## Zakres zmian

17 plików Blade: layout, hero, 5 komponentów kart, 6 widoków stron, paginacja, sidebar i like button. Żadnych zmian w CSS ani konfiguracji Tailwind — wyłącznie klasy utility w szablonach.

## Wersje

- `frontend` → `v1.21.1` (patch: korekta kontrastu jasnego motywu)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-24-light-theme';

-- feature-24-light-theme [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Softening the light theme', 'User feedback: the light theme has too much contrast and is uncomfortable to browse. The diagnosis confirmed the issue — pure white (`#ffffff`) card backgrounds and near-black text (`text-gray-900`) produced a contrast ratio of ~19.5:1. WCAG requires a mi',
         'User feedback: the light theme has too much contrast and is uncomfortable to browse. The diagnosis confirmed the issue — pure white (`#ffffff`) card backgrounds and near-black text (`text-gray-900`) produced a contrast ratio of ~19.5:1. WCAG requires a minimum of 4.5:1. Technically accessible, but visually harsh and tiring for the eyes.

## The problem

The light theme palette relied on three values:
- Page background: `bg-gray-50` (`#f9fafb`)
- Cards: `bg-white` (`#ffffff`)
- Text: `text-gray-900` (`#111827`)

White cards on a near-white background = minimal surface differentiation. Black text on white = maximum contrast. The result: a clinical look that strained the eyes during longer reading sessions.

## The fix

Instead of CSS custom properties or a color system refactor, I went with direct Tailwind class replacements. The scale is manageable (~17 Blade files), and every change targets light mode only — all `dark:` classes remain untouched.

Mapping table:

| Element | Before | After |
|---------|--------|-------|
| Page background | `bg-gray-50` | `bg-gray-100` |
| Cards | `bg-white` | `bg-gray-50` |
| Header | `bg-white/80` | `bg-gray-50/80` |
| Primary text | `text-gray-900` | `text-gray-800` |
| Inner borders | `border-gray-100` | `border-gray-200` |
| Tags | `bg-gray-100` | `bg-gray-200/60` |
| Hero background | `#fefefe` | `#f3f4f6` |

The new text contrast of `text-gray-800` on `bg-gray-50` = ~15:1. Still WCAG AAA, but subjectively much softer.

## Exceptions

Not everything moved from `bg-white` to `bg-gray-50`:
- **Form inputs** — kept `bg-white` to create an "inset" effect against the `bg-gray-50` card
- **Dropdown menus** — `bg-white` for an "elevated" feel (overlay element)
- **Newsletter CTA** — dark gradient section, untouched by this change

## Gradient fade in categories

The `category-grid` component has a gradient masking the bottom edge of the list:

```blade
<div class="bg-gradient-to-t from-white dark:from-gray-800 to-transparent"></div>
```

After changing the card to `bg-gray-50`, the `from-white` gradient created a visible boundary. Changing it to `from-gray-50` restored the smooth fade.

## Scope of changes

17 Blade files: layout, hero, 5 card components, 6 page views, pagination, sidebar and the like button. No CSS or Tailwind config changes — utility classes in templates only.

## Versions

- `frontend` → `v1.21.1` (patch: light theme contrast correction)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-24-light-theme';

-- feature-25-aina-agent [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'Aina Agent — od formularza kontaktowego do asystenta AI', 'Portfolio miało przycisk do chatu od jakiegoś czasu. Nie robił nic. Potem feature-23 dał mu backend — formularz kontaktowy. Formularz jest użyteczny, ale też nudny. Pytanie stało się: co jeśli przycisk otwierałby rozmowę zamiast formularza?',
         'Portfolio miało przycisk do chatu od jakiegoś czasu. Nie robił nic. Potem feature-23 dał mu backend — formularz kontaktowy. Formularz jest użyteczny, ale też nudny. Pytanie stało się: co jeśli przycisk otwierałby rozmowę zamiast formularza?

Ten release jest odpowiedzią: Aina Agent — asystent AI wbudowany w portfolio.

## Pomysł — i dlaczego ewoluował

Pierwotny plan był prosty: pływający przycisk → modal z formularzem → email do Szymona. Feature-23 zaimplementował dokładnie to. Działa.

Ale formularz ma stały kształt. Użytkownik, który chce wiedzieć jakiego stacku używa portfolio, albo który post blogowy omawia OAuth2, albo czy Szymon jest dostępny na zlecenia — trzy pytania trafiają do tego samego formularza, który nie odpowiada na żadne z nich.

Asystent AI może odpowiedzieć na wszystkie trzy. A jeśli użytkownik ostatecznie chce nawiązać kontakt, asystent może zebrać dla niego wiadomość i ją wysłać. Formularz staje się wyjściem z rozmowy, a nie całym interfejsem.

## Stack

Chat opiera się na czterech głównych zależnościach:

**Anthropic Claude** obsługuje język. `AnthropicClient` to cienka warstwa nad Messages API:

```php
$response = Http::withHeaders([
    \'x-api-key\'         => $this->apiKey,
    \'anthropic-version\' => \'2023-06-01\',
])->post(\'/v1/messages\', [
    \'model\'      => $this->model,
    \'max_tokens\' => $this->maxTokens,
    \'system\'     => $systemPrompt,
    \'messages\'   => $messages,
]);
```

**VoyageAI + Qdrant** napędzają retrieval-augmented generation (RAG). Gdy użytkownik pyta o treść bloga, wiadomość jest embeddowana przez `VoyageClient::embed()` i porównywana z zindeksowanymi postami w Qdrant. Pięć najbliższych fragmentów jest wstrzykiwanych do system prompta jako kontekst. Jeśli serwisy embeddingów są niedostępne, system wraca do prostej listy ostatnich postów.

**Redis** przechowuje historię rozmowy per sesja (TTL 30 minut, maksymalnie 10 par wymian). To sprawia, że chat przypomina rozmowę, a nie serię niezależnych jednorazowych zapytań.

## Detekcja intencji

Nie każda wiadomość wymaga takiego samego traktowania. `ChatService::detectIntent()` klasyfikuje każdą przychodzącą wiadomość do jednej z pięciu kategorii przed zbudowaniem system prompta:

- `blog` — pytania o posty lub pisanie
- `about` — pytania o background lub umiejętności Szymona
- `contact_initiation` — użytkownik chce się skontaktować
- `contact_flow` — już w trakcie redagowania wiadomości
- `normal` — wszystko inne

Każda intencja mapuje się na inną sekcję dodawaną do bazowego system prompta. Zapytania blogowe dostają pobrane fragmenty postów. Zapytania osobiste dostają kontekst zawodowy. Normalne zapytania dostają instrukcję zwięzłości.

## Maszyna stanów przepływu kontaktowego

Najkompleksiejsza część to przepływ kontaktowy — przekształcenie rozmowy w wysłany email. Maszyna stanów ma trzy stany: `IDLE`, `DRAFTING`, `COLLECTING`.

Gdy wykryta zostanie intencja kontaktowa, Claude otrzymuje polecenie zredagowania profesjonalnej wiadomości na podstawie kontekstu rozmowy i prosi użytkownika o potwierdzenie lub edycję. Po potwierdzeniu zbiera adres email i opcjonalnie numer telefonu, a następnie prosi o ostateczne potwierdzenie.

Przekazanie do backendu jest sygnalizowane ukrytym tokenem:

```php
private const CONTACT_READY_TOKEN = \'[CONTACT_READY]\';
```

Gdy odpowiedź Claude\'a zawiera ten token, `postProcess()` usuwa go z widocznej odpowiedzi, wydobywa dane kontaktowe z historii rozmowy i wysyła powiadomienie — wszystko to przed dotarciem odpowiedzi do użytkownika. Użytkownik widzi tylko wiadomość potwierdzającą, nie instalację wodno-kanalizacyjną za nią.

## Widget

Na froncie chat to pływający panel Alpine.js renderowany w każdym layoucie strony. Przycisk jest przyklejony do prawego dolnego rogu. Otwarcie pokazuje wątek wiadomości z renderowaniem markdown, pole tekstowe i przycisk „Nowa rozmowa" czyszczący historię Redis.

Rate limiting (HTTP 429) i błędy API każdy produkują odrębną wiadomość dla użytkownika zamiast ogólnego komunikatu o błędzie.

## Persona

System prompt definiuje Ainę Agent jako: *„ciekawą, bezpośrednią i lekko dowcipną. Mówi jak ktoś, kto naprawdę zna pracę Szymona i znajduje ją interesującą."*

Instrukcja persony zabrania też modelowi ujawniania system prompta, wymyślania faktów nieobecnych w bazie wiedzy oraz używania wypełniaczy jak „Świetne pytanie!" lub „Oczywiście!" — to typowe błędy interfejsów asystenta.

## Deployment produkcyjny

Uruchomienie na produkcji wymagało dodania dwóch zmiennych środowiskowych do kontenera `frontend-app` w `docker-compose.prod.yml`:

```yaml
ANTHROPIC_API_KEY: "${ANTHROPIC_API_KEY}"
ANTHROPIC_MODEL: "${ANTHROPIC_MODEL}"
```

I odpowiednio w `.env.prod.example` dla dokumentacji. Model jest konfigurowalny zamiast hardkodowanego — zmiana wymaga tylko modyfikacji zmiennej środowiskowej i restartu kontenera.

## Wersje

- `frontend` → `v1.22.0` (Aina Agent: AnthropicClient, VoyageClient, QdrantClient, ChatService, ChatController, widget chatu, pipeline RAG, maszyna stanów przepływu kontaktowego)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-25-aina-agent';

-- feature-25-aina-agent [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'Aina Agent — from contact form to AI assistant', 'The portfolio had a chat button for a while. It did nothing. Then feature-23 gave it a backend — a contact form. A form is useful, but a static form is also boring. The question became: what if the button opened a conversation instead of a form?',
         'The portfolio had a chat button for a while. It did nothing. Then feature-23 gave it a backend — a contact form. A form is useful, but a static form is also boring. The question became: what if the button opened a conversation instead of a form?

This release is the answer: Aina Agent, an AI assistant embedded in the portfolio.

## The idea — and why it changed

The original plan was simple: floating button → modal with a form → email to Szymon. Feature-23 implemented exactly that. It works.

But a form has a fixed shape. A user who wants to know what stack the portfolio uses, or which blog post covers OAuth2, or whether Szymon is available for freelance work — all three questions map to the same form, which answers none of them.

An AI assistant can answer all three. And if the user ends up wanting to actually reach out, the assistant can collect the message for them, then send it. The form becomes an exit ramp from a conversation, not the whole interface.

## Stack

The chat is built on four main dependencies:

**Anthropic Claude** handles language. `AnthropicClient` is a thin wrapper around the Messages API:

```php
$response = Http::withHeaders([
    \'x-api-key\'         => $this->apiKey,
    \'anthropic-version\' => \'2023-06-01\',
])->post(\'/v1/messages\', [
    \'model\'      => $this->model,
    \'max_tokens\' => $this->maxTokens,
    \'system\'     => $systemPrompt,
    \'messages\'   => $messages,
]);
```

**VoyageAI + Qdrant** power retrieval-augmented generation (RAG). When a user asks about blog content, the message is embedded via `VoyageClient::embed()` and compared against indexed blog posts in Qdrant. The five closest chunks are injected into the system prompt as context. If the embedding services are unavailable, the system falls back to a simple list of recent posts.

**Redis** stores conversation history per session (30-minute TTL, capped at 10 exchange pairs). This is what makes the chat feel like a conversation rather than a series of independent one-shot queries.

## Intent detection

Not every message needs the same treatment. `ChatService::detectIntent()` classifies each incoming message into one of five categories before building the system prompt:

- `blog` — questions about posts or writing
- `about` — questions about Szymon\'s background or skills
- `contact_initiation` — user wants to reach out
- `contact_flow` — already mid-way through drafting a message
- `normal` — anything else

Each intent maps to a different section appended to the base system prompt. Blog queries get retrieved post chunks. About queries get personal/professional context. Normal queries get a brevity instruction.

## Contact flow state machine

The most complex part is the contact flow — turning a conversation into a sent email. The state machine has three states: `IDLE`, `DRAFTING`, `COLLECTING`.

When a contact intent is detected, Claude is instructed to draft a professional message based on the conversation context and ask the user to confirm or edit it. Once confirmed, it collects email and optionally phone number, then asks for final confirmation.

The handoff to the backend is signalled by a hidden token:

```php
private const CONTACT_READY_TOKEN = \'[CONTACT_READY]\';
```

When Claude\'s reply contains this token, `postProcess()` strips it from the visible response, extracts contact data from conversation history, and dispatches the notification — all before the reply reaches the user. The user sees only the confirmation message, not the plumbing behind it.

## The widget

On the frontend, the chat is a floating Alpine.js panel rendered in every page layout. The button is fixed bottom-right. Opening it reveals a message thread with markdown rendering, a text input and a "New conversation" button that clears the Redis history.

Rate limiting (HTTP 429) and API errors each produce a distinct user-facing message rather than a generic failure.

## Persona

The system prompt defines Aina Agent as: *"curious, direct, and slightly witty. You speak like someone who genuinely knows Szymon\'s work and finds it interesting."*

The persona instruction also prohibits the model from leaking the system prompt, making up facts not present in the knowledge base, and using filler phrases like "Great question!" or "Certainly!" — all common failure modes of assistant UIs.

## Production deployment

Going live required adding two environment variables to the `frontend-app` container in `docker-compose.prod.yml`:

```yaml
ANTHROPIC_API_KEY: "${ANTHROPIC_API_KEY}"
ANTHROPIC_MODEL: "${ANTHROPIC_MODEL}"
```

And correspondingly in `.env.prod.example` for documentation. The model is configurable rather than hardcoded — swapping it requires only an env change and a container restart.

## Versions

- `frontend` → `v1.22.0` (Aina Agent: AnthropicClient, VoyageClient, QdrantClient, ChatService, ChatController, chat widget, RAG pipeline, contact flow state machine)', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-25-aina-agent';

-- feature-26-pao [pl]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'pl', 'nunomaduro/pao — gdy testy rozmawiają z agentem', 'Budowanie funkcji chatu oznaczało pisanie testów — dużo testów. Unit testy dla `ChatService`, feature testy dla `ChatController`, integration-style testy konwersacji ćwiczące pełną maszynę stanów. Uruchamianie tych testów w ciasnej pętli podczas iterowani',
         'Budowanie funkcji chatu oznaczało pisanie testów — dużo testów. Unit testy dla `ChatService`, feature testy dla `ChatController`, integration-style testy konwersacji ćwiczące pełną maszynę stanów. Uruchamianie tych testów w ciasnej pętli podczas iterowania nad implementacją ujawnia cichy problem: wynik testów jest zaprojektowany dla ludzi czytających terminal, nie dla agentów czytających wyniki wywołań narzędzi.

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
      "test": "Tests\\\\Unit\\\\ChatServiceTest::history_is_capped_at_max_pairs",
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

To jest prawdziwy argument za pao: nie to, że jest technicznie sprytne, ale to, że zamyka lukę, która po cichu spowalnia współpracę człowiek-agent w projektach PHP.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-26-pao';

-- feature-26-pao [en]
INSERT INTO post_translations (post_id, locale, title, excerpt, content, version, created_at, updated_at)
  SELECT id, 'en', 'nunomaduro/pao — when your tests talk to the agent', 'Building the chat feature meant writing tests — a lot of them. Unit tests for `ChatService`, feature tests for `ChatController`, integration-style conversation tests that exercise the full state machine. Running those tests in a tight loop while iterating',
         'Building the chat feature meant writing tests — a lot of them. Unit tests for `ChatService`, feature tests for `ChatController`, integration-style conversation tests that exercise the full state machine. Running those tests in a tight loop while iterating on the implementation surfaces a quiet problem: test output is designed for humans reading a terminal, not for agents reading tool call results.

`nunomaduro/pao` is the fix for that. And it represents something broader worth naming.

The package is authored by [Nuno Maduro](https://nunomaduro.com) — the same person behind Laravel Pint, Collision, and Pest. He introduced the concept in a talk worth watching: [Agent-Optimized PHP Tooling](https://www.youtube.com/watch?v=aOA1m9dFEww).

## What pao does

The package description is precise: *"Agent-optimized output for PHP testing tools."*

PHPUnit and Pest produce output meant to be scanned visually — coloured dots, progress bars, formatted exception traces. When an AI agent runs `php artisan test` and reads the result, it gets the same terminal dump. That is fine for simple cases. For failing tests with long stack traces, nested exceptions, or parallel test output, the signal-to-noise ratio drops.

Pao intercepts the output pipeline and reformats it into a structure that agents can parse reliably: clean JSON when running in an agentic context (detected via `shipfastlabs/agent-detector`), unmodified human-readable output when not. The switch is automatic — no flags, no configuration.

```json
{
  "status": "failed",
  "tests": 42,
  "assertions": 187,
  "failures": [
    {
      "test": "Tests\\\\Unit\\\\ChatServiceTest::history_is_capped_at_max_pairs",
      "message": "Expected 20 messages, got 22.",
      "file": "tests/Unit/ChatServiceTest.php",
      "line": 94
    }
  ]
}
```

The agent gets exactly what it needs to locate the failure and understand it. No ANSI codes, no progress bars, no decorative borders.

## How it integrates

Pao ships a Laravel `ServiceProvider` and a Pest plugin, both registered automatically via `composer.json` extras. After `composer require --dev nunomaduro/pao`, there is nothing else to configure. The test runner detects the execution context and selects the appropriate output driver.

Both `frontend` and `blog` services received the package as a dev dependency. It only affects test runs — no production impact, no runtime overhead.

## The concept of pao

"Pao" is shorthand for the broader idea: **agent-optimized tooling**.

The software industry has spent decades building tools for human developers — IDEs with syntax highlighting, terminals with colour output, dashboards with charts. All of that is correct and valuable. But when an AI agent is the primary consumer of a tool\'s output — running tests, reading logs, parsing build results — human-oriented output formats become friction.

Pao applies this thinking to test runners. The same principle applies to linters (structured JSON errors rather than coloured diffs), build tools (machine-readable summaries rather than ASCII art progress), log formatters (structured fields rather than freeform strings). The pattern is: detect the consumer, emit the appropriate format.

This matters more as AI agents become participants in development loops rather than occasional helpers. An agent that writes code, runs tests, reads the results, and iterates — without a human in the loop for each cycle — needs tooling that speaks its language.

## Why it matters for this project specifically

The chat feature was developed with Claude acting as an active collaborator — suggesting implementations, running tests to verify them, reading failures and iterating. Pao made that loop faster and more reliable. Instead of the agent parsing terminal output heuristically, it received structured failure data it could act on directly.

That is the real argument for pao: not that it is technically clever, but that it closes a gap that quietly slows down human–agent collaboration in PHP projects.', 1, NOW(), NOW()
  FROM posts WHERE slug = 'feature-26-pao';

-- ------------------------------------------------------------
-- Category → Post pivots
-- ------------------------------------------------------------
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'start-here' AND p.slug = 'intro-01-why-this-blog';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'start-here' AND p.slug = 'intro-02-architecture';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'start-here' AND p.slug = 'intro-03-how-to-run';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'architektura' AND p.slug = 'article-01-why-microservices';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-01-blog-api';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-02-oauth2-sso';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-03-rabbitmq-users';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'devops' AND p.slug = 'article-02-traefik-reverse-proxy';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-04-admin-rbac';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'backend' AND p.slug = 'article-03-oauth2-sso-passport';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-05-kubernetes';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'devops' AND p.slug = 'article-04-docker-multi-stage';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-06-analytics';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-07-monitoring';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'devops' AND p.slug = 'article-05-kubernetes-migration';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'devops' AND p.slug = 'article-06-github-actions-cicd';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'devops' AND p.slug = 'article-07-monitoring-stack';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'backend' AND p.slug = 'article-08-analytics-service';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-08-production-deploy';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-09-cms';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-10-ui-improvements';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-11-pages-i18n';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-12-install-sh';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-13-easymde-editor';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-14-docker-fixes';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-15-i18n-translations';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-16-post-reading';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-17-author-dark-mode';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-18-category-widget';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-19-comments-likes';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-20-production-monitoring';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-21-media-lightbox';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-22-seo-i18n';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-23-contact-form';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-24-light-theme';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-25-aina-agent';
INSERT INTO category_post (category_id, post_id)
  SELECT c.id, p.id FROM categories c, posts p
  WHERE c.slug = 'dev-log' AND p.slug = 'feature-26-pao';

-- ------------------------------------------------------------
-- Tag → Post pivots
-- ------------------------------------------------------------
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-01-why-this-blog' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-01-why-this-blog' AND t.slug = 'magento';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-01-why-this-blog' AND t.slug = 'intro';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-01-why-this-blog' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-01-why-this-blog' AND t.slug = 'portfolio';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-02-architecture' AND t.slug = 'architecture';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-02-architecture' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-02-architecture' AND t.slug = 'rabbitmq';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-02-architecture' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-02-architecture' AND t.slug = 'intro';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-02-architecture' AND t.slug = 'architektura';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-02-architecture' AND t.slug = 'traefik';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-03-how-to-run' AND t.slug = 'installation';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-03-how-to-run' AND t.slug = 'instalacja';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-03-how-to-run' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-03-how-to-run' AND t.slug = 'intro';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-03-how-to-run' AND t.slug = 'local-dev';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'intro-03-how-to-run' AND t.slug = 'devops';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-01-why-microservices' AND t.slug = 'architecture';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-01-why-microservices' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-01-why-microservices' AND t.slug = 'rabbitmq';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-01-why-microservices' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-01-why-microservices' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'testy';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'blog';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'jwt';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'paginacja';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'pagination';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'tests';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'api';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-01-blog-api' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-02-oauth2-sso' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-02-oauth2-sso' AND t.slug = 'authorization';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-02-oauth2-sso' AND t.slug = 'passport';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-02-oauth2-sso' AND t.slug = 'sso';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-02-oauth2-sso' AND t.slug = 'autoryzacja';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-02-oauth2-sso' AND t.slug = 'oauth2';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-02-oauth2-sso' AND t.slug = 'pkce';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'blog';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'eventy';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'events';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'rabbitmq';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'sso';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'mikroserwisy';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'api';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-03-rabbitmq-users' AND t.slug = 'users';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-02-traefik-reverse-proxy' AND t.slug = 'nginx';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-02-traefik-reverse-proxy' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-02-traefik-reverse-proxy' AND t.slug = 'reverse-proxy';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-02-traefik-reverse-proxy' AND t.slug = 'infrastructure';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-02-traefik-reverse-proxy' AND t.slug = 'tls';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-02-traefik-reverse-proxy' AND t.slug = 'traefik';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'rbac';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'role';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'sso';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'filament';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'oauth2';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'admin';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'roles';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-04-admin-rbac' AND t.slug = 'users';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-03-oauth2-sso-passport' AND t.slug = 'passport';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-03-oauth2-sso-passport' AND t.slug = 'security';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-03-oauth2-sso-passport' AND t.slug = 'sso';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-03-oauth2-sso-passport' AND t.slug = 'authentication';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-03-oauth2-sso-passport' AND t.slug = 'php';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-03-oauth2-sso-passport' AND t.slug = 'oauth2';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-03-oauth2-sso-passport' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-05-kubernetes' AND t.slug = 'k8s';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-05-kubernetes' AND t.slug = 'deployment';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-05-kubernetes' AND t.slug = 'kubernetes';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-05-kubernetes' AND t.slug = 'nginx';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-05-kubernetes' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-05-kubernetes' AND t.slug = 'health-check';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-04-docker-multi-stage' AND t.slug = 'dockerfile';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-04-docker-multi-stage' AND t.slug = 'containers';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-04-docker-multi-stage' AND t.slug = 'alpine';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-04-docker-multi-stage' AND t.slug = 'security';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-04-docker-multi-stage' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-04-docker-multi-stage' AND t.slug = 'php';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-04-docker-multi-stage' AND t.slug = 'hardening';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-06-analytics' AND t.slug = 'statistics';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-06-analytics' AND t.slug = 'eventy';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-06-analytics' AND t.slug = 'events';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-06-analytics' AND t.slug = 'rabbitmq';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-06-analytics' AND t.slug = 'statystyki';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-06-analytics' AND t.slug = 'frontend';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-06-analytics' AND t.slug = 'analytics';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-07-monitoring' AND t.slug = 'monitoring';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-07-monitoring' AND t.slug = 'infra';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-07-monitoring' AND t.slug = 'loki';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-07-monitoring' AND t.slug = 'grafana';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-07-monitoring' AND t.slug = 'promtail';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-07-monitoring' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-07-monitoring' AND t.slug = 'prometheus';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-05-kubernetes-migration' AND t.slug = 'tutorial';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-05-kubernetes-migration' AND t.slug = 'deployment';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-05-kubernetes-migration' AND t.slug = 'kubernetes';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-05-kubernetes-migration' AND t.slug = 'statefulset';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-05-kubernetes-migration' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-05-kubernetes-migration' AND t.slug = 'migration';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-06-github-actions-cicd' AND t.slug = 'github-actions';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-06-github-actions-cicd' AND t.slug = 'automation';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-06-github-actions-cicd' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-06-github-actions-cicd' AND t.slug = 'testing';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-06-github-actions-cicd' AND t.slug = 'ci-cd';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-06-github-actions-cicd' AND t.slug = 'ghcr';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-07-monitoring-stack' AND t.slug = 'monitoring';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-07-monitoring-stack' AND t.slug = 'loki';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-07-monitoring-stack' AND t.slug = 'observability';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-07-monitoring-stack' AND t.slug = 'grafana';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-07-monitoring-stack' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-07-monitoring-stack' AND t.slug = 'prometheus';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-08-analytics-service' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-08-analytics-service' AND t.slug = 'rabbitmq';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-08-analytics-service' AND t.slug = 'mysql';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-08-analytics-service' AND t.slug = 'api';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-08-analytics-service' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'article-08-analytics-service' AND t.slug = 'analytics';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'ovh';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'kubernetes';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'kustomize';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'production';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'cert-manager';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'produkcja';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-08-production-deploy' AND t.slug = 'ghcr';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-09-cms' AND t.slug = 'cms';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-09-cms' AND t.slug = 'featured-posts';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-09-cms' AND t.slug = 'blog';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-09-cms' AND t.slug = 'filament';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-09-cms' AND t.slug = 'frontend';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-09-cms' AND t.slug = 'admin';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'kategorie';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'ui';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'sso';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'likes';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'dark-mode';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'categories';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'frontend';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-10-ui-improvements' AND t.slug = 'analytics';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'pl';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'i18n';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'strony';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'kontakt';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'contact';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'blog';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'en';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'pages';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'newsletter';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-11-pages-i18n' AND t.slug = 'admin';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-12-install-sh' AND t.slug = 'automation';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-12-install-sh' AND t.slug = 'install';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-12-install-sh' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-12-install-sh' AND t.slug = 'bash';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-12-install-sh' AND t.slug = 'devops';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-12-install-sh' AND t.slug = 'mkcert';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-12-install-sh' AND t.slug = 'tls';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'highlight';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'easymde';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'markdown';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'js';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'editor';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'frontend';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-13-easymde-editor' AND t.slug = 'admin';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-14-docker-fixes' AND t.slug = 'environment';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-14-docker-fixes' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-14-docker-fixes' AND t.slug = 'mysql';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-14-docker-fixes' AND t.slug = 'configuration';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-14-docker-fixes' AND t.slug = 'docker-compose';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-14-docker-fixes' AND t.slug = 'vendor';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-14-docker-fixes' AND t.slug = 'devops';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-15-i18n-translations' AND t.slug = 'architecture';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-15-i18n-translations' AND t.slug = 'i18n';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-15-i18n-translations' AND t.slug = 'translations';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-15-i18n-translations' AND t.slug = 'database';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-15-i18n-translations' AND t.slug = 'migrations';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-15-i18n-translations' AND t.slug = 'api';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-15-i18n-translations' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-16-post-reading' AND t.slug = 'blade';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-16-post-reading' AND t.slug = 'tailwind';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-16-post-reading' AND t.slug = 'ui';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-16-post-reading' AND t.slug = 'refactoring';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-16-post-reading' AND t.slug = 'components';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-16-post-reading' AND t.slug = 'typography';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-16-post-reading' AND t.slug = 'frontend';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'blade';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'ui';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'dark-mode';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'api';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'frontend';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'author';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-17-author-dark-mode' AND t.slug = 'admin';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'ux';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'blade';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'tailwind';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'alpine';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'js';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'ui';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'categories';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-18-category-widget' AND t.slug = 'frontend';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'testy';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'komentarze';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'blade';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'polubienia';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'alpine';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'js';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'docker';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'likes';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'comments';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'tests';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'phpunit';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-19-comments-likes' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'monitoring';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'loki';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'ovh';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'kubernetes';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'grafana';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'helm';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'promtail';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'nginx-ingress';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-20-production-monitoring' AND t.slug = 'prometheus';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'cdn';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'blade';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'webp';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'alpine';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'js';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'media';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'intervention';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'image';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-21-media-lightbox' AND t.slug = 'lightbox';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'twitter';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'i18n';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'tagi';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'card';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'blade';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'seo';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'open';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'tags';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'graph';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'meta';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-22-seo-i18n' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'microservices';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'form';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'alpine';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'js';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'internal';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'email';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'mailable';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'filament';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'formularz';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'api';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-23-contact-form' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'wcag';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'ux';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'dost-pno';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'blade';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'contrast';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'tailwind';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'design';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'ui';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'css';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'kontrast';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-24-light-theme' AND t.slug = 'accessibility';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'redis';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'chat';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'rag';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'ai';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'voyage';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'claude';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'alpine';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'js';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'anthropic';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'qdrant';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-25-aina-agent' AND t.slug = 'laravel';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'pao';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'testowanie';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'ai';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'agent';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'testing';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'php';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'nunomaduro';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'developer-experience';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'phpunit';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'pest';
INSERT INTO post_tag (post_id, tag_id)
  SELECT p.id, t.id FROM posts p, tags t
  WHERE p.slug = 'feature-26-pao' AND t.slug = 'laravel';

-- ------------------------------------------------------------
-- Featured posts
-- ------------------------------------------------------------
INSERT INTO featured_posts (post_id, position, created_at, updated_at)
  SELECT id, 1, NOW(), NOW() FROM posts WHERE slug = 'intro-01-why-this-blog';
INSERT INTO featured_posts (post_id, position, created_at, updated_at)
  SELECT id, 2, NOW(), NOW() FROM posts WHERE slug = 'intro-02-architecture';

-- Done.
