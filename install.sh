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
#   --repo-base Git base URL for cloning services         (default: git@github.com:szymonborowski)
#   --network   External Docker network name              (default: web)
#   -h, --help  Show this help message and exit

DOMAIN="microservices.local"
REPO_BASE="git@github.com:szymonborowski"
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
                        (default: git@github.com:szymonborowski)
  --network <name>      External Docker network name
                        (default: web)
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
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

SERVICES=(
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

  # infra
  if [ ! -f "infra/.env" ]; then
    cp infra/.env.example infra/.env
    success "Created infra/.env"
  else
    warn "infra/.env already exists – skipping."
  fi

  # microservices
  for entry in "${SERVICES[@]}"; do
    dir="${entry%%:*}"
    if [ ! -f "$dir/.env" ]; then
      cp "$dir/.env.example" "$dir/.env"
      # inject UID/GID for volume permissions
      sed -i "s/^UID=.*/UID=$(id -u)/" "$dir/.env"
      sed -i "s/^GID=.*/GID=$(id -g)/" "$dir/.env"
      success "Created $dir/.env"
    else
      warn "$dir/.env already exists – skipping."
    fi
  done
}

# -----------------------------------------------------------------------------
# inject KEY=VALUE into a file, replacing any existing value
env_set() { local f="$1" k="$2" v="$3"; [ -f "$f" ] && sed -i "s|^${k}=.*|${k}=${v}|" "$f"; }

generate_secrets() {
  info "Generating secrets..."
  cd "$ROOT_DIR"

  local rabbitmq_pass sso_secret users_key analytics_key
  rabbitmq_pass=$(openssl rand -hex 16)
  sso_secret=$(openssl rand -hex 32)
  users_key=$(openssl rand -hex 32)
  analytics_key=$(openssl rand -hex 32)

  # RabbitMQ — shared password across all services
  env_set infra/.env     RABBITMQ_PASS     "$rabbitmq_pass"
  env_set infra/.env     RABBITMQ_USER     "admin"
  for svc in blog frontend users analytics; do
    env_set "${svc}/.env" RABBITMQ_PASSWORD "$rabbitmq_pass"
    env_set "${svc}/.env" RABBITMQ_USER     "admin"
  done

  # DB passwords — unique per service
  for svc in blog frontend sso admin users analytics; do
    [ -f "${svc}/.env" ] || continue
    env_set "${svc}/.env" DB_PASSWORD      "$(openssl rand -hex 16)"
    env_set "${svc}/.env" DB_ROOT_PASSWORD "$(openssl rand -hex 16)"
  done

  # SSO client secret — same value in frontend and admin
  env_set frontend/.env SSO_CLIENT_SECRET "$sso_secret"
  env_set admin/.env    SSO_CLIENT_SECRET "$sso_secret"

  # Users internal API key
  env_set frontend/.env USERS_INTERNAL_API_KEY "$users_key"
  env_set admin/.env    USERS_SERVICE_API_KEY   "$users_key"

  # Analytics internal API key
  env_set frontend/.env  ANALYTICS_INTERNAL_API_KEY "$analytics_key"
  env_set admin/.env     ANALYTICS_INTERNAL_API_KEY "$analytics_key"
  env_set analytics/.env INTERNAL_API_KEY            "$analytics_key"

  # Laravel APP_KEY (admin only — others use artisan key:generate at boot)
  env_set admin/.env APP_KEY "base64:$(openssl rand -base64 32)"

  success "Secrets generated."
}

# -----------------------------------------------------------------------------
generate_certs() {
  info "Generating TLS certificates with mkcert..."
  cd "$ROOT_DIR"
  mkdir -p "$CERTS_DIR"
  mkcert -install
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
create_networks() {
  info "Creating Docker networks..."
  docker network create "$NETWORK_NAME" 2>/dev/null && success "Created network: $NETWORK_NAME" || warn "Network $NETWORK_NAME already exists – skipping."
  docker network create microservices 2>/dev/null && success "Created network: microservices" || warn "Network microservices already exists – skipping."
}

# -----------------------------------------------------------------------------
main() {
  echo ""
  echo "  Portfolio – local dev setup"
  echo "  ================================"
  echo ""

  check_requirements
  request_sudo
  clone_services
  setup_env_files
  generate_secrets
  generate_certs
  setup_hosts
  create_networks

  echo ""
  success "Setup complete!"
  echo ""
  echo "  Next steps:"
  echo "  1. Run: ./dev.sh up -d"
  echo ""
}

main "$@"
