#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Portfolio – local development setup
# =============================================================================
# Requirements: git, docker, docker compose v2, mkcert
# Usage: ./install.sh [--domain <domain>] [--repo-base <url>] [--network <name>]
#
# Options:
#   --domain    Base domain for local TLS and /etc/hosts  (default: microservices.local)
#   --repo-base Git base URL for cloning services         (default: https://github.com/szymonborowski)
#   --network   External Docker network name              (default: web)
#   -h, --help  Show this help message and exit

DOMAIN="microservices.local"
REPO_BASE="https://github.com/szymonborowski"
NETWORK_NAME="${NETWORK_NAME:-web}"

# --- parse args ---------------------------------------------------------------
usage() {
  cat <<EOF
Portfolio – local development setup script

Bootstraps a full local dev environment: clones microservice repositories,
generates TLS certificates via mkcert, updates /etc/hosts, and creates
required Docker networks.

Usage:
  ./install.sh [OPTIONS]

Options:
  --domain <domain>     Base domain for TLS certs and /etc/hosts
                        (default: microservices.local)
  --repo-base <url>     Git base URL used for cloning services
                        (default: https://github.com/szymonborowski)
  --network <name>      External Docker network name
                        (default: web)
  --purge               Stop all services and remove cloned directories
                        (allows a clean reinstall)
  -h, --help            Show this help message and exit

Requirements:
  git, docker, docker compose v2, mkcert

Examples:
  ./install.sh
  ./install.sh --domain myapp.local
  ./install.sh --domain myapp.local --repo-base git@github.com:otheruser
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --domain)    DOMAIN="$2";       shift 2 ;;
    --repo-base) REPO_BASE="$2";    shift 2 ;;
    --network)   NETWORK_NAME="$2"; shift 2 ;;
    --https)     REPO_BASE="https://github.com/szymonborowski"; shift ;;
    --purge)     PURGE=true; shift ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

SERVICES=(
  "infra:infrastructure_service"
  "frontend:frontend_service"
  "sso:sso_service"
  "admin:admin_service"
  "users:users_service"
  "blog:blog_service"
  "analytics:analytics_service"
)

SUBDOMAINS=(
  "frontend"
  "frontend-vite"
  "sso"
  "sso-vite"
  "admin"
  "users"
  "blog"
  "analytics"
  "traefik"
  "rabbitmq"
  "grafana"
  "prometheus"
)

DOMAINS=("$DOMAIN")
for sub in "${SUBDOMAINS[@]}"; do
  DOMAINS+=("${sub}.${DOMAIN}")
done

CERTS_DIR="infra/certs"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -----------------------------------------------------------------------------
info()    { echo -e "\033[1;34m[INFO]\033[0m  $*"; }
success() { echo -e "\033[1;32m[OK]\033[0m    $*"; }
warn()    { echo -e "\033[1;33m[WARN]\033[0m  $*"; }
error()   { echo -e "\033[1;31m[ERROR]\033[0m $*"; exit 1; }

# -----------------------------------------------------------------------------
check_requirements() {
  info "Checking requirements..."
  for cmd in git docker mkcert; do
    command -v "$cmd" &>/dev/null || error "'$cmd' is required but not installed."
  done
  docker compose version &>/dev/null || error "Docker Compose v2 is required."
  success "All requirements met."
}

# -----------------------------------------------------------------------------
request_sudo() {
  info "Requesting sudo privileges (needed for /etc/hosts)..."
  if ! sudo -v; then
    error "sudo is required to update /etc/hosts."
  fi
  success "sudo OK."
}

# -----------------------------------------------------------------------------
clone_services() {
  info "Cloning microservice repositories..."
  cd "$ROOT_DIR"
  for entry in "${SERVICES[@]}"; do
    dir="${entry%%:*}"
    repo="${entry##*:}"
    if [ -d "$dir/.git" ]; then
      warn "$dir already exists – skipping clone."
    else
      git clone "${REPO_BASE}/${repo}.git" "$dir"
      success "Cloned $repo → $dir/"
    fi
  done
}

# -----------------------------------------------------------------------------
setup_env_files() {
  info "Setting up .env files..."
  cd "$ROOT_DIR"

  for entry in "${SERVICES[@]}"; do
    dir="${entry%%:*}"

    # --- Docker Compose .env ---
    if [ ! -f "$dir/.env" ]; then
      cp "$dir/.env.example" "$dir/.env"
      sed -i "s/^UID=.*/UID=$(id -u)/" "$dir/.env"
      sed -i "s/^GID=.*/GID=$(id -g)/" "$dir/.env"
      sed -i "s|\.microservices\.local|.${DOMAIN}|g" "$dir/.env"
      if [[ "$dir" == "infra" ]]; then
        sed -i "s|^DOMAIN=.*|DOMAIN=${DOMAIN}|" "$dir/.env"
        DOMAIN="$DOMAIN" envsubst < "$dir/dynamic/traefik_dynamic.yml.example" > "$dir/dynamic/traefik_dynamic.yml"
        success "Generated infra/dynamic/traefik_dynamic.yml"
      fi
      success "Created $dir/.env"
    else
      warn "$dir/.env already exists – skipping."
    fi

    # --- Laravel src/.env (Laravel reads /var/www/html/.env = $dir/src/.env) ---
    [[ "$dir" == "infra" ]] && continue
    if [ ! -f "$dir/src/.env" ]; then
      cp "$dir/src/.env.example" "$dir/src/.env"
      # Domain substitution
      sed -i "s|\.microservices\.local|.${DOMAIN}|g" "$dir/src/.env"
      sed -i "s|^APP_URL=.*|APP_URL=https://${dir}.${DOMAIN}|" "$dir/src/.env"
      # Apply DB config from docker-level .env.example
      local db_host db_database db_username
      db_host=$(grep     "^DB_HOST="     "$dir/.env.example" 2>/dev/null | cut -d= -f2) || true
      db_database=$(grep "^DB_DATABASE=" "$dir/.env.example" 2>/dev/null | cut -d= -f2) || true
      db_username=$(grep "^DB_USERNAME=" "$dir/.env.example" 2>/dev/null | cut -d= -f2) || true
      if [ -n "$db_host" ]; then
        sed -i "s|^DB_CONNECTION=.*|DB_CONNECTION=mysql|"          "$dir/src/.env"
        # Handle commented-out pattern "# DB_HOST=..."
        sed -i "s|^# DB_HOST=.*|DB_HOST=${db_host}|"               "$dir/src/.env"
        sed -i "s|^# DB_PORT=.*|DB_PORT=3306|"                     "$dir/src/.env"
        sed -i "s|^# DB_DATABASE=.*|DB_DATABASE=${db_database}|"   "$dir/src/.env"
        sed -i "s|^# DB_USERNAME=.*|DB_USERNAME=${db_username}|"   "$dir/src/.env"
        sed -i "s|^# DB_PASSWORD=.*|DB_PASSWORD=|"                 "$dir/src/.env"
        # Handle already-uncommented lines (e.g. blog)
        sed -i "s|^DB_HOST=.*|DB_HOST=${db_host}|"                 "$dir/src/.env"
        sed -i "s|^DB_DATABASE=.*|DB_DATABASE=${db_database}|"     "$dir/src/.env"
        sed -i "s|^DB_USERNAME=.*|DB_USERNAME=${db_username}|"     "$dir/src/.env"
      fi
      # VITE_DOMAIN — needed by vite.config.js to resolve cert paths
      if [[ "$dir" == "frontend" ]]; then
        if grep -q "^VITE_DOMAIN=" "$dir/src/.env"; then
          sed -i "s|^VITE_DOMAIN=.*|VITE_DOMAIN=${DOMAIN}|" "$dir/src/.env"
        else
          echo "VITE_DOMAIN=${DOMAIN}" >> "$dir/src/.env"
        fi
      fi
      success "Created $dir/src/.env"
    else
      warn "$dir/src/.env already exists – skipping."
    fi

    # --- Vite config: write dynamic domain-aware version (frontend only) ---
    if [[ "$dir" == "frontend" ]] && [ -f "$dir/src/vite.config.js" ]; then
      cat > "$dir/src/vite.config.js" << 'VITEEOF'
import { defineConfig, loadEnv } from 'vite';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';
import fs from 'fs';
import path from 'path';

export default defineConfig(({ mode }) => {
    const env     = loadEnv(mode, process.cwd(), '');
    const domain  = env.VITE_DOMAIN || 'microservices.local';
    const viteSub = `frontend-vite.${domain}`;

    const certKey  = path.resolve(__dirname, `certs/${viteSub}-key.pem`);
    const certPem  = path.resolve(__dirname, `certs/${viteSub}.pem`);
    const hasCerts = fs.existsSync(certKey) && fs.existsSync(certPem);

    return {
        plugins: [
            laravel({
                input: ['resources/css/app.css', 'resources/js/app.js'],
                refresh: true,
            }),
            tailwindcss(),
        ],
        ...(hasCerts && {
            server: {
                https: {
                    key:  fs.readFileSync(certKey),
                    cert: fs.readFileSync(certPem),
                },
                host:       viteSub,
                port:       5174,
                strictPort: true,
                allowedHosts: ['all'],
                hmr: {
                    host:     viteSub,
                    protocol: 'wss',
                    port:     5174,
                },
                watch: {
                    ignored: ['**/storage/framework/views/**'],
                },
            },
        }),
    };
});
VITEEOF
      success "Patched frontend/src/vite.config.js (dynamic domain support)"
    fi
  done
}

# -----------------------------------------------------------------------------
# inject KEY=VALUE into a file, replacing any existing value
env_set() { local f="$1" k="$2" v="$3"; [ -f "$f" ] && sed -i "s|^${k}=.*|${k}=${v}|" "$f" || true; }

# inject KEY=VALUE only when current value is empty (idempotent for secrets)
env_set_once() {
  local f="$1" k="$2" v="$3"
  [ -f "$f" ] || return 0
  local current
  current=$(grep "^${k}=" "$f" | cut -d= -f2) || true
  [ -n "$current" ] && return 0
  sed -i "s|^${k}=.*|${k}=${v}|" "$f"
}

generate_secrets() {
  info "Generating secrets..."
  cd "$ROOT_DIR"

  local rabbitmq_pass sso_secret users_key analytics_key
  rabbitmq_pass=$(openssl rand -hex 16)
  sso_secret=$(openssl rand -hex 32)
  users_key=$(openssl rand -hex 32)
  analytics_key=$(openssl rand -hex 32)

  # RabbitMQ — shared password across all services
  env_set_once infra/.env     RABBITMQ_PASS     "$rabbitmq_pass"
  env_set      infra/.env     RABBITMQ_USER     "admin"
  for svc in blog frontend users analytics; do
    env_set_once "${svc}/.env"     RABBITMQ_PASSWORD "$rabbitmq_pass"
    env_set      "${svc}/.env"     RABBITMQ_USER     "admin"
    env_set_once "${svc}/src/.env" RABBITMQ_PASSWORD "$rabbitmq_pass"
    env_set      "${svc}/src/.env" RABBITMQ_USER     "admin"
  done

  # DB password — single shared value across all MySQL services (frontend uses SQLite)
  # Use env_set_once so repeated runs don't invalidate existing MySQL volumes
  local db_pass db_root_pass
  db_pass="$(openssl rand -hex 16)"
  db_root_pass="$(openssl rand -hex 16)"
  for svc in blog sso admin users analytics; do
    [ -f "${svc}/.env" ] || continue
    env_set_once "${svc}/.env"     DB_PASSWORD      "$db_pass"
    env_set_once "${svc}/.env"     DB_ROOT_PASSWORD "$db_root_pass"
    env_set_once "${svc}/src/.env" DB_PASSWORD      "$db_pass"
  done

  # SSO client secret — same value in frontend and admin
  env_set_once frontend/.env     SSO_CLIENT_SECRET "$sso_secret"
  env_set_once admin/.env        SSO_CLIENT_SECRET "$sso_secret"
  env_set_once frontend/src/.env SSO_CLIENT_SECRET "$sso_secret"
  env_set_once admin/src/.env    SSO_CLIENT_SECRET "$sso_secret"

  # Users internal API key
  env_set_once frontend/.env     USERS_INTERNAL_API_KEY "$users_key"
  env_set_once admin/.env        USERS_SERVICE_API_KEY   "$users_key"
  env_set_once sso/.env          USERS_SERVICE_API_KEY   "$users_key"
  env_set_once frontend/src/.env USERS_INTERNAL_API_KEY "$users_key"
  env_set_once admin/src/.env    USERS_SERVICE_API_KEY   "$users_key"
  env_set_once sso/src/.env      USERS_SERVICE_API_KEY   "$users_key"

  # Analytics internal API key
  env_set_once frontend/.env      ANALYTICS_INTERNAL_API_KEY "$analytics_key"
  env_set_once admin/.env         ANALYTICS_INTERNAL_API_KEY "$analytics_key"
  env_set_once analytics/.env     INTERNAL_API_KEY            "$analytics_key"
  env_set_once frontend/src/.env  ANALYTICS_INTERNAL_API_KEY "$analytics_key"
  env_set_once admin/src/.env     ANALYTICS_INTERNAL_API_KEY "$analytics_key"
  env_set_once analytics/src/.env INTERNAL_API_KEY            "$analytics_key"

  # Laravel APP_KEY — generate for all services
  for svc in blog frontend sso admin users analytics; do
    [ -f "${svc}/src/.env" ] || continue
    env_set_once "${svc}/src/.env" APP_KEY "base64:$(openssl rand -base64 32)"
  done
  env_set_once admin/.env APP_KEY "base64:$(openssl rand -base64 32)"

  success "Secrets generated."
}

# -----------------------------------------------------------------------------
generate_certs() {
  info "Generating TLS certificates with mkcert..."
  cd "$ROOT_DIR"
  mkdir -p "$CERTS_DIR"
  sudo chown "$(id -u):$(id -g)" "$CERTS_DIR"
  mkcert -install || warn "mkcert -install failed – system CA not updated, certs will still be generated."
  cd "$CERTS_DIR"
  for domain in "${DOMAINS[@]}"; do
    if [ ! -f "${domain}.pem" ]; then
      mkcert -cert-file "${domain}.pem" -key-file "${domain}-key.pem" "$domain"
      success "Certificate created: $domain"
    else
      warn "Certificate already exists: $domain – skipping."
    fi
  done
  cd "$ROOT_DIR"
}

# -----------------------------------------------------------------------------
copy_dev_certs() {
  info "Copying dev TLS certs to Vite service directories..."
  cd "$ROOT_DIR"
  mkdir -p "frontend/src/certs"
  cp -f "infra/certs/frontend-vite.${DOMAIN}.pem"     "frontend/src/certs/"
  cp -f "infra/certs/frontend-vite.${DOMAIN}-key.pem" "frontend/src/certs/"
  success "Copied frontend-vite.${DOMAIN} certs → frontend/src/certs/"
}

# -----------------------------------------------------------------------------
setup_hosts() {
  info "Updating /etc/hosts..."
  local hosts_entry="127.0.0.1"
  for domain in "${DOMAINS[@]}"; do
    hosts_entry="$hosts_entry $domain"
  done

  if grep -q "$DOMAIN" /etc/hosts; then
    warn "/etc/hosts already contains $DOMAIN entries – skipping."
    warn "To update manually, add the following line to /etc/hosts:"
    echo "  $hosts_entry"
  else
    echo "$hosts_entry" | sudo tee -a /etc/hosts > /dev/null
    success "Added $DOMAIN entries to /etc/hosts."
  fi
}

# -----------------------------------------------------------------------------
purge() {
  request_sudo
  warn "Purging local dev environment..."
  cd "$ROOT_DIR"

  if [ -f "$ROOT_DIR/dev.sh" ]; then
    info "Stopping all services..."
    bash "$ROOT_DIR/dev.sh" down 2>/dev/null || true
  fi

  for entry in "${SERVICES[@]}"; do
    dir="${entry%%:*}"
    if [ -d "$dir" ]; then
      sudo rm -rf "$dir"
      success "Removed $dir/"
    fi
  done

  info "Removing database volumes..."
  local db_volumes
  db_volumes=$(docker volume ls --format '{{.Name}}' | grep '_db_data$' || true)
  if [ -n "$db_volumes" ]; then
    # stop any containers still using these volumes
    for vol in $db_volumes; do
      docker ps -a --filter "volume=${vol}" --format '{{.ID}}' | xargs -r docker rm -f 2>/dev/null || true
    done
    echo "$db_volumes" | xargs docker volume rm 2>/dev/null && success "Database volumes removed." || warn "Some volumes could not be removed."
  else
    warn "No database volumes found."
  fi

  success "Purge complete. Run ./install.sh to set up again."
  exit 0
}

# -----------------------------------------------------------------------------
create_networks() {
  info "Creating Docker networks..."
  docker network create --label com.docker.compose.network="$NETWORK_NAME" "$NETWORK_NAME" 2>/dev/null && success "Created network: $NETWORK_NAME" || warn "Network $NETWORK_NAME already exists – skipping."
  docker network create --label com.docker.compose.network="microservices" microservices 2>/dev/null && success "Created network: microservices" || warn "Network microservices already exists – skipping."
}

# -----------------------------------------------------------------------------
run_migrations() {
  info "Starting services..."
  bash "$ROOT_DIR/dev.sh" up -d --build

  info "Running Laravel migrations..."
  local php_services=(frontend sso users admin blog analytics)
  for svc in "${php_services[@]}"; do
    [[ ! -d "$ROOT_DIR/$svc" ]] && continue

    info "Waiting for ${svc}-app..."
    local i=0
    until docker compose -f "$ROOT_DIR/$svc/docker-compose.yml" exec -T "${svc}-app" true 2>/dev/null; do
      ((i++))
      [[ $i -ge 40 ]] && { warn "${svc}-app not ready after 2 min – skipping migrations"; continue 2; }
      sleep 3
    done
    docker compose -f "$ROOT_DIR/$svc/docker-compose.yml" exec -T "${svc}-app" \
      php artisan migrate --force \
      && success "Migrated: $svc" \
      || warn "Migration failed: $svc"

    # SSO: generate Passport OAuth2 keys and save them to src/.env
    if [[ "$svc" == "sso" ]]; then
      info "Generating Passport OAuth2 keys for SSO..."
      docker compose -f "$ROOT_DIR/sso/docker-compose.yml" exec -T sso-app \
        php artisan passport:keys --force 2>/dev/null && \
      private_key=$(docker compose -f "$ROOT_DIR/sso/docker-compose.yml" exec -T sso-app \
        cat storage/oauth-private.key | tr -d '\r') && \
      public_key=$(docker compose -f "$ROOT_DIR/sso/docker-compose.yml" exec -T sso-app \
        cat storage/oauth-public.key | tr -d '\r') && \
      python3 - <<PYEOF
import re
priv = r"""${private_key}""".strip().replace('\n', r'\n')
pub  = r"""${public_key}""".strip().replace('\n', r'\n')
priv_line = 'PASSPORT_PRIVATE_KEY="' + priv + '"'
pub_line  = 'PASSPORT_PUBLIC_KEY="'  + pub  + '"'
# Write keys to SSO and to every service that shares the same Passport keys
for env_file in ['${ROOT_DIR}/sso/src/.env', '${ROOT_DIR}/users/src/.env']:
    try:
        with open(env_file, 'r') as f:
            content = f.read()
        content = re.sub(r'^PASSPORT_PRIVATE_KEY=.*$', priv_line, content, flags=re.MULTILINE)
        content = re.sub(r'^PASSPORT_PUBLIC_KEY=.*$',  pub_line,  content, flags=re.MULTILINE)
        with open(env_file, 'w') as f:
            f.write(content)
    except FileNotFoundError:
        pass
PYEOF
      success "Passport keys saved to sso/src/.env and users/src/.env" || warn "Failed to save Passport keys"
    fi
  done
}

# -----------------------------------------------------------------------------
main() {
  echo ""
  echo "  Portfolio – local dev setup"
  echo "  ================================"
  echo ""

  ${PURGE:-false} && purge

  check_requirements
  request_sudo
  clone_services
  setup_env_files
  generate_secrets
  generate_certs
  copy_dev_certs
  setup_hosts
  create_networks
  run_migrations

  echo ""
  success "Setup complete!"
  echo ""
}

main "$@"
