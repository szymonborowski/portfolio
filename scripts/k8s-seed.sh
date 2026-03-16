#!/usr/bin/env bash
# =============================================================================
# k8s-seed.sh — jednorazowy seed baz danych na klastrze K8s
# Uruchom raz po pierwszym deploymencie na nowym klastrze.
#
# Kolejność jest ważna:
#   1. users  — tworzy role i użytkownika admin
#   2. sso    — tworzy klientów OAuth2 (wymaga działającego SSO)
#   3. blog   — tworzy przykładowe posty (opcjonalnie, dev/demo)
# =============================================================================
set -e

NS="${NAMESPACE:-portfolio}"

run_seed_job() {
  local service="$1"
  local manifest="$2"
  echo ""
  echo "▶ Seeding ${service}..."
  kubectl apply -f "$manifest" -n "$NS"
  kubectl wait --for=condition=complete "job/${service}-seed" -n "$NS" --timeout=120s
  echo "✓ ${service} seed complete"
  kubectl delete -f "$manifest" -n "$NS" --ignore-not-found
}

run_seed_job "users" "users/k8s/seed-job.yaml"
run_seed_job "sso"   "sso/k8s/seed-job.yaml"

read -r -p "Seed blog z przykładowymi postami? (tak/NIE) " answer
if [[ "$answer" =~ ^[Tt]ak$ ]]; then
  run_seed_job "blog" "blog/k8s/seed-job.yaml"
else
  echo "Blog seed pominięty. Użyj scripts/seed-blog-posts.sql dla produkcyjnych postów."
fi

echo ""
echo "✓ Seed gotowy."
