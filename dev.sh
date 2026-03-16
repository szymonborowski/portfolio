#!/usr/bin/env bash

set -euo pipefail

COMMAND="${1:-}"

if [[ "$COMMAND" != "up" && "$COMMAND" != "down" ]]; then
  echo "Usage:"
  echo "  ./docker-compose.dev.sh up [-d] [services...]"
  echo "  ./docker-compose.dev.sh down [services...]"
  exit 1
fi

shift || true

DETACHED=""
if [[ "${1:-}" == "-d" ]]; then
  DETACHED="-d"
  shift
fi

# 🔥 statyczna lista (infra first)
ALL_SERVICES=(
  infra
  admin
  frontend
  sso
  blog
  users
  analitics
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

echo "🚀 docker compose $COMMAND $DETACHED"
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
    if [[ "$COMMAND" == "up" ]]; then
      docker compose up $DETACHED
    else
      docker compose down
    fi
  )
  echo "✅ done :: $service"
  echo
done

echo "🎉 All services completed"