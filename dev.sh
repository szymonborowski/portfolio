#!/usr/bin/env bash

set -euo pipefail

# Args before '--' go to docker compose; args after '--' select subdirectories.
# Example: ./dev.sh up -d --build -- admin blog
DC_ARGS=()
SELECTED_SERVICES=()
FOUND_SEP=false

for arg in "$@"; do
  if [[ "$arg" == "--" ]]; then
    FOUND_SEP=true
    continue
  fi
  if $FOUND_SEP; then
    SELECTED_SERVICES+=("$arg")
  else
    DC_ARGS+=("$arg")
  fi
done

if [[ ${#DC_ARGS[@]} -eq 0 ]]; then
  echo "Usage:"
  echo "  ./dev.sh DOCKER_COMPOSE_ARGS... [-- SERVICE...]"
  echo ""
  echo "Examples:"
  echo "  ./dev.sh up -d --build"
  echo "  ./dev.sh down -- admin blog"
  echo "  ./dev.sh logs -f -- blog"
  echo "  ./dev.sh ps"
  echo "  ./dev.sh restart -- infra"
  exit 1
fi

ALL_SERVICES=(
  infra
  admin
  frontend
  sso
  blog
  users
  analytics
)

if [[ ${#SELECTED_SERVICES[@]} -gt 0 ]]; then
  SERVICES=()
  for s in "${SELECTED_SERVICES[@]}"; do
    if printf '%s\n' "${ALL_SERVICES[@]}" | grep -qx "$s"; then
      SERVICES+=("$s")
    else
      echo "⚠️  Service '$s' not in list, skipping"
    fi
  done
else
  SERVICES=("${ALL_SERVICES[@]}")
fi

if [[ ${#SERVICES[@]} -eq 0 ]]; then
  echo "❌ No services to run"
  exit 1
fi

echo "🚀 docker compose ${DC_ARGS[*]}"
echo "📦 Services: ${SERVICES[*]}"
echo

for service in "${SERVICES[@]}"; do
  if [[ ! -d "$service" ]]; then
    echo "⚠️  Directory '$service' not found, skipping"
    continue
  fi

  echo "➡️  $service"
  (
    cd "$service"
    docker compose "${DC_ARGS[@]}"
  )
  echo "✅ done :: $service"
  echo
done

echo "🎉 All services completed"
