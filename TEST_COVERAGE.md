# Raport pokrycia testami

Każdy mikroserwis ma osobne repozytorium i własną konfigurację PHPUnit. Pokrycie mierzysz w kontenerze Docker (dev Dockerfile ma PCOV i pdo_sqlite) lub lokalnie z PCOV/Xdebug i SQLite.

**Ostatnia aktualizacja:** 2026-02-08 (pomiar PCOV w Dockerze po przebudowie obrazów).

## Ostatni pomiar (PHPUnit + PCOV w Docker)

| Serwis | Klasy | Metody | Linie | Testy | Uwagi |
|--------|-------|--------|-------|--------|--------|
| **blog** | 72% (18/25) | 81% (54/67) | **80,1%** (310/387) | 98 OK | TagApiTest, CommentApiTest. ConsumeUserEvents, PostCollection – 0% |
| **users** | 64% (7/11) | 75% (27/36) | **87,8%** (195/222) | 49 OK | RoleInternalApiTest, InternalApiTest, EmailTest, UserApiRabbitMQTest |
| **sso** | 33% (3/9) | 63% (22/35) | **83,7%** (113/135) | 22 OK | LoginControllerTest, RegisterControllerTest. AuthorizationViewResponse – 0% |
| **admin** | 29% (2/7) | 45% (23/51) | **73,0%** (162/222) | 28 OK | ManageUsersPageTest, ApiUserTest, UsersApiServiceTest. ManageUsers częściowo. |
| **frontend** | 33% (4/12) | 45% (24/53) | **61,4%** (253/412) | 46 OK | + MeControllerTest (show, updateProfile, updatePassword). OAuthController 100%, MeController ~87%, EnsureAuthenticated 100%. |

Pomiar z 2026-02-08 po przebudowie obrazów Docker (PCOV włączone). W razie „No code coverage driver available” przebuduj: `docker compose build --no-cache <serwis>-app`.

### Blog – szczegóły (wybrane)

- **JwtGuard**: 100% metod i linii
- **CategoryController**: 80% metod, 97% linii
- **PostController**: 60% metod, 92% linii
- **TagController**: 100% metod i linii
- **CommentController**: 100% metod i linii
- **Category, Comment, Tag** (modele): 100%
- **ConsumeUserEvents, PostCollection**: 0%

### Users – szczegóły (wybrane)

- **UserDataChanged, InternalApiKey, UserResource, AuthServiceProvider**: 100%
- **RoleController**: 100% metod i linii
- **UserController**: 89% metod, 99% linii
- **Email** (ValueObject): 100%
- **RabbitMQService**: 33% metod, 57% linii
- **User** (model): 38% metod, 47% linii

---

## Jak uruchomić pomiar pokrycia

### W kontenerze Docker (zalecane)

Obraz dev ma PCOV i pdo_sqlite. Testy muszą używać SQLite (phpunit.xml tak ustawia), ale zmienne z `docker-compose` nadpisują DB – trzeba wymusić env przy uruchomieniu:

```bash
cd blog   # lub users, sso, admin, frontend
docker compose run --rm --no-deps \
  -e APP_ENV=testing -e DB_CONNECTION=sqlite -e DB_DATABASE=:memory: \
  blog-app ./vendor/bin/phpunit --coverage-text --coverage-filter=app
```

Raport HTML: ten sam `run`, ale z `--coverage-html build/coverage`; potem katalog `src/build/coverage/` (w kontenerze montowany z hosta).

**Jeśli pojawia się „No code coverage driver available”:** przebuduj obraz bez cache: `docker compose build --no-cache <serwis>-app`, potem ponów komendę z `--coverage-text`.

### Lokalnie (w katalogu `src`)

```bash
# Wymagane: PHP z PCOV (lub Xdebug) oraz pdo_sqlite
./vendor/bin/phpunit --coverage-text
./vendor/bin/phpunit --coverage-html build/coverage
```

W `phpunit.xml` jest już raport tekstowy i HTML do `build/coverage`. Katalog `build/` jest w `.gitignore`.

---

## Podsumowanie pokrycia (analiza ręczna)

Oszacowanie na podstawie mapowania testów do kodu aplikacji. Wartości procentowe są przybliżone.

### Users (`users/`)

| Obszar | Pliki / metody | Testy | Szac. pokrycie |
|--------|----------------|-------|-----------------|
| **UserController** | index, show, store, update, destroy, authorize, updateById, destroyById | UserApiTest, InternalApiTest | ~95% |
| **RoleController** | index, getUserRoles, assignRole, removeRole | RoleInternalApiTest | ~100% |
| **RabbitMQService** | publish, getConnection | RabbitMQServiceTest | ~95% |
| **UserDataChanged** (event) | constructor, publikacja do RabbitMQ | UserDataChangedTest, UserApiRabbitMQTest | ~95% |
| **User** (model) | roles(), hasRole, assignRole, removeRole, getHighestRole | pośrednio przez API i RoleInternalApiTest | ~40% |
| **Role** (model) | users() | pośrednio | ~20% |
| **InternalApiKey** (middleware) | handle | InternalApiTest | ~100% |
| **UserResource** | toArray | pośrednio | ~80% |
| **Email** (ValueObject) | __construct, walidacja | EmailTest | ~100% |
| **Ogólnie** | app/ | 49 testów | **~87%** (linie, pomiar PCOV) |

---

### Blog (`blog/`)

| Obszar | Pliki / metody | Testy | Szac. pokrycie |
|--------|----------------|-------|-----------------|
| **PostController** | index, store, show, update, destroy | PostApiTest | ~90% |
| **CategoryController** | index, store, show, update, destroy | CategoryApiTest | ~90% |
| **TagController** | index, store, show, update, destroy, search, paginacja | TagApiTest | ~100% |
| **CommentController** | index, store, show, update, destroy, approve, reject | CommentApiTest | ~100% |
| **JwtGuard** | user(), validate(), getTokenFromRequest | JwtGuardTest, AuthenticationTest | ~95% |
| **Post, Category, Tag, Comment** (modele) | relacje, scopes | przez API | ~70% |
| **Form Requests** (Store/Update) | rules(), authorize() | przez testy API | ~80% |
| **ConsumeUserEvents** (komenda) | handle, processMessage | — | **0%** |
| **Ogólnie** | app/ | 98 testów | **~80%** (linie, pomiar PCOV) |

---

### SSO (`sso/`)

| Obszar | Pliki / metody | Testy | Szac. pokrycie |
|--------|----------------|-------|-----------------|
| **ApiUserProvider** | retrieveById, retrieveByCredentials, validateCredentials | ApiUserProviderTest | ~95% |
| **UsersApiService** | checkCredentials, createUser, getUserById | UsersApiServiceTest | ~95% |
| **LoginController** | show, store, destroy | LoginControllerTest (show, store valid/invalid, logout) | ~90% |
| **RegisterController** | show, store | RegisterControllerTest (show, redirect_uri, store success/fail) | ~90% |
| **ApiUser** (model) | fromApiResponse, Authenticatable | pośrednio w providerze i feature | ~60% |
| **AuthorizationViewResponse** | toResponse, withParameters | — | **0%** |
| **Ogólnie** | app/ | 22 testy | **83,7%** linii (PCOV) |

---

### Frontend (`frontend/`)

| Obszar | Testy | Szac. pokrycie |
|--------|-------|-----------------|
| **OAuthController** | login, register, callback (state/error/token/user), logout | OAuthControllerTest | ~95% |
| **MeController** | show, updateProfile, updatePassword (redirect bez tokena, sukces, błędy) | MeControllerTest | ~87% |
| **UserPanelController** | profile, updateProfile, updatePassword, posts, createPost, storePost, deletePost, comments | UserPanelControllerTest (Http::fake) | ~85% |
| **EnsureAuthenticated** | redirect when no token, allow when token | EnsureAuthenticatedMiddlewareTest | 100% |
| **BlogApiService** | getRecentPosts, getCategories, getTags, getPost, getPostById, createPost, deletePost | BlogApiServiceTest | ~80% |
| **UsersApiService** | getUser, updateUser, verifyPassword, updatePassword | UsersApiServiceTest | ~90% |
| **HomeController** | index (wymaga BlogApiService) | — | **~0%** (test integracyjny z mockiem możliwy) |
| **Ogólnie** | 46 testów | **61,4%** linii (PCOV) |

---

### Admin (`admin/`)

| Obszar | Testy | Szac. pokrycie |
|--------|-------|-----------------|
| **ManageUsers** (Filament) | loadData, assignRole, removeUserRole, saveUser, deleteUser, openEditModal | ManageUsersPageTest (Livewire + Http::fake) | ~90% |
| **ApiUser** (model) | hasRole, hasAnyRole, canAccessPanel, getFilamentName, toArray | ApiUserTest | 100% |
| **UsersApiService** | getUsers, getUser, checkCredentials, getRoles, assignRole, deleteUser | UsersApiServiceTest | ~70% |
| **ApiUserProvider** | retrieveById, retrieveByCredentials, validateCredentials | ApiUserProviderTest | ~90% |
| **Health/Ready** | HealthTest, ExampleTest → /health | 100% |
| **Ogólnie** | 28 testów | **73,0%** linii (PCOV) |

---

## Rekomendacje

1. **Uruchamianie coverage**: w kontenerze Docker (dev) z PCOV – komenda z sekcji „Jak uruchomić pomiar pokrycia”. Lokalnie: `./vendor/bin/phpunit --coverage-text` w katalogu `src` danego serwisu (wymaga PCOV lub Xdebug w trybie coverage).
2. **CI (GitHub Actions)** – job z PHP, PCOV i SQLite; testy z `--coverage-clover build/coverage.xml` (lub `--coverage-text`); opcjonalnie publikacja raportu (np. Codecov).
3. **Priorytety dalszego uzupełnienia**: ConsumeUserEvents (blog), AuthorizationViewResponse (sso), HomeController z mockiem BlogApiService (frontend). RoleController, OAuth/panel (frontend), Filament ManageUsers (admin) – już pokryte testami.
4. **Konfiguracja**: W każdym serwisie w `phpunit.xml` jest sekcja `<coverage>` z raportem tekstowym i HTML (`build/coverage`). Katalog `build/` w `.gitignore`. Obrazy dev Docker mają PCOV i pdo_sqlite we wszystkich serwisach; po zmianach w Dockerfile należy przebudować obraz bez cache, aby coverage działał w kontenerze.
