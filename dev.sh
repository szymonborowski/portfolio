#!/usr/bin/env bash

set -euo pipefail

COMMAND="${1:-}"

if [[ "$COMMAND" != "up" && "$COMMAND" != "down" && "$COMMAND" != "build" ]]; then
  echo "Usage:"
  echo "  ./dev.sh up [-d] [--build] [services...]"
  echo "  ./dev.sh down [services...]"
  echo "  ./dev.sh build [services...]"
  exit 1
fi

shift || true

DETACHED=""
BUILD=""
while [[ "${1:-}" == -* ]]; do
  case "${1}" in
    -d)       DETACHED="--detach" ;;
    --build)  BUILD="--build" ;;
    *)        echo "⚠️ Unknown flag: $1" ;;
  esac
  shift
done

# 🔥 statyczna lista (infra first)
ALL_SERVICES=(
  infra
  admin
  frontend
  sso
  blog
  users
  analytics
)

SELECTED_SERVICES=("$@")

if [[ ${#SELECTED_SERVICES[@]} -gt 0 ]]; then
  SERVICES=()
  for s in "${SELECTED_SERVICES[@]}"; do
    if printf '%s\n' "${ALL_SERVICES[@]}" | grep -qx "$s"; then
      SERVICES+=("$s")
    else
      echo "⚠️ Service '$s' not in static list"
    fi
  done
else
  SERVICES=("${ALL_SERVICES[@]}")
fi

if [[ ${#SERVICES[@]} -eq 0 ]]; then
  echo "❌ No services to run"
  exit 1
fi

echo "🚀 docker compose $COMMAND $DETACHED $BUILD"
echo "📦 Services: ${SERVICES[*]}"
echo

for service in "${SERVICES[@]}"; do
  if [[ ! -d "$service" ]]; then
    echo "⚠️ Directory $service not found"
    continue
  fi

  echo "➡️  $COMMAND :: $service"
  (
    cd "$service"
    case "$COMMAND" in
      up)    docker compose up $DETACHED $BUILD ;;
      down)  docker compose down ;;
      build) docker compose build ;;
    esac
  )
  echo "✅ done :: $service"
  echo
done

echo "🎉 All services completed"