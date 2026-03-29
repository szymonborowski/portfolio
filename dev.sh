#!/usr/bin/env bash

set -euo pipefail

ALL_SERVICES=(
  infra
  admin
  frontend
  sso
  blog
  users
  analytics
)

# Map service name → PHP-FPM container name used by docker compose exec
app_container() {
  echo "${1}-app"
}

usage() {
  echo "Usage:"
  echo "  ./dev.sh DOCKER_COMPOSE_ARGS... [-- SERVICE...]"
  echo "  ./dev.sh test [-- SERVICE...] [-- ARTISAN_ARGS...]"
  echo ""
  echo "Docker compose examples:"
  echo "  ./dev.sh up -d --build"
  echo "  ./dev.sh down -- admin blog"
  echo "  ./dev.sh logs -f -- blog"
  echo "  ./dev.sh ps"
  echo "  ./dev.sh restart -- infra"
  echo ""
  echo "Test examples:"
  echo "  ./dev.sh test"
  echo "  ./dev.sh test -- blog frontend"
  echo "  ./dev.sh test -- blog -- --filter CommentApiTest"
  exit 1
}

# ─── test subcommand ──────────────────────────────────────────────────────────
if [[ "${1:-}" == "test" ]]; then
  shift

  SELECTED_SERVICES=()
  ARTISAN_ARGS=()
  SECTION=pre   # pre → services (after 1st --) → artisan (after 2nd --)

  for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
      [[ "$SECTION" == "pre"      ]] && SECTION=services && continue
      [[ "$SECTION" == "services" ]] && SECTION=artisan  && continue
      continue
    fi
    [[ "$SECTION" == "services" ]] && SELECTED_SERVICES+=("$arg")
    [[ "$SECTION" == "artisan"  ]] && ARTISAN_ARGS+=("$arg")
  done

  TESTABLE_SERVICES=()
  for s in "${ALL_SERVICES[@]}"; do
    [[ "$s" == "infra" ]] && continue
    TESTABLE_SERVICES+=("$s")
  done

  if [[ ${#SELECTED_SERVICES[@]} -gt 0 ]]; then
    SERVICES=()
    for s in "${SELECTED_SERVICES[@]}"; do
      if printf '%s\n' "${TESTABLE_SERVICES[@]}" | grep -qx "$s"; then
        SERVICES+=("$s")
      else
        echo "⚠️  Service '$s' not in list, skipping"
      fi
    done
  else
    SERVICES=("${TESTABLE_SERVICES[@]}")
  fi

  if [[ ${#SERVICES[@]} -eq 0 ]]; then
    echo "❌ No services to test"
    exit 1
  fi

  echo "🧪 Running tests"
  echo "📦 Services: ${SERVICES[*]}"
  [[ ${#ARTISAN_ARGS[@]} -gt 0 ]] && echo "⚙️  Artisan args: ${ARTISAN_ARGS[*]}"
  echo

  FAILED=()
  for service in "${SERVICES[@]}"; do
    if [[ ! -d "$service" ]]; then
      echo "⚠️  Directory '$service' not found, skipping"
      continue
    fi

    echo "🔬 $service"
    if (cd "$service" && docker compose exec "$(app_container "$service")" php artisan test "${ARTISAN_ARGS[@]}"); then
      echo "✅ $service"
    else
      echo "❌ $service"
      FAILED+=("$service")
    fi
    echo
  done

  if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo "❌ Failed: ${FAILED[*]}"
    exit 1
  fi

  echo "🎉 All tests passed"
  exit 0
fi

# ─── docker compose passthrough ───────────────────────────────────────────────
if [[ $# -eq 0 ]]; then
  usage
fi

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
  usage
fi

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
