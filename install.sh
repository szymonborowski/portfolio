#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Portfolio – local development setup
# =============================================================================
# Requirements: git, docker, docker compose v2, mkcert
# Usage: ./install.sh

REPO_BASE="git@github.com:szymonborowski"

SERVICES=(
  "frontend:frontend_service"
  "sso:sso_service"
  "admin:admin_service"
  "users:users_service"
  "blog:blog_service"
  "analytics:analytics_service"
)

DOMAIN="microservices.local"

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

  if grep -q "microservices.local" /etc/hosts; then
    warn "/etc/hosts already contains microservices.local entries – skipping."
    warn "To update manually, add the following line to /etc/hosts:"
    echo "  $hosts_entry"
  else
    echo "$hosts_entry" | sudo tee -a /etc/hosts > /dev/null
    success "Added microservices.local entries to /etc/hosts."
  fi
}

# -----------------------------------------------------------------------------
create_networks() {
  info "Creating Docker networks..."
  docker network create "${NETWORK_NAME:-web}" 2>/dev/null && success "Created network: ${NETWORK_NAME:-web}" || warn "Network ${NETWORK_NAME:-web} already exists – skipping."
  docker network create microservices 2>/dev/null && success "Created network: microservices" || warn "Network microservices already exists – skipping."
}

# -----------------------------------------------------------------------------
main() {
  echo ""
  echo "  Portfolio – local dev setup"
  echo "  ================================"
  echo ""

  check_requirements
  clone_services
  setup_env_files
  generate_certs
  setup_hosts
  create_networks

  echo ""
  success "Setup complete!"
  echo ""
  echo "  Next steps:"
  echo "  1. Review and fill in secrets in each service's .env file"
  echo "  2. Run: docker compose up -d"
  echo ""
}

main "$@"
