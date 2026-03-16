#!/bin/bash
set -e

echo "=== Generating Kubernetes Secrets ==="
echo ""

cd /home/decybell/dev/portfolio

SERVICES=("admin" "blog" "frontend" "sso" "users")

# Generate shared USERS_SERVICE_API_KEY (used by admin to call users service)
USERS_API_KEY=$(openssl rand -base64 32)
echo "✓ Generated shared USERS_SERVICE_API_KEY"

for SERVICE in "${SERVICES[@]}"; do
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Processing: $SERVICE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # 1. Generate APP_KEY using Docker image
    echo "  [1/3] Generating APP_KEY..."
    APP_KEY=$(docker run --rm ghcr.io/szymonborowski/microservices-${SERVICE}:v0.0.1 php artisan key:generate --show 2>/dev/null)
    echo "    → $APP_KEY"

    # 2. Generate database password
    echo "  [2/3] Generating DB_PASSWORD..."
    DB_PASSWORD=$(openssl rand -base64 32)
    echo "    → ${DB_PASSWORD:0:20}... (truncated for display)"

    # 3. Create secret.yaml from template
    echo "  [3/3] Creating secret.yaml..."

    if [ ! -f "${SERVICE}/k8s/secret.example.yaml" ]; then
        echo "    ✗ Error: ${SERVICE}/k8s/secret.example.yaml not found!"
        continue
    fi

    # Copy template
    cp "${SERVICE}/k8s/secret.example.yaml" "${SERVICE}/k8s/secret.yaml"

    # Replace placeholders
    sed -i "s|base64:CHANGE_ME_GENERATE_WITH_PHP_ARTISAN_KEY_GENERATE|${APP_KEY}|g" "${SERVICE}/k8s/secret.yaml"
    sed -i "s|DB_PASSWORD: \"CHANGE_ME\"|DB_PASSWORD: \"${DB_PASSWORD}\"|g" "${SERVICE}/k8s/secret.yaml"

    # For admin service, add USERS_SERVICE_API_KEY
    if [ "$SERVICE" == "admin" ]; then
        sed -i "s|USERS_SERVICE_API_KEY: \"CHANGE_ME\"|USERS_SERVICE_API_KEY: \"${USERS_API_KEY}\"|g" "${SERVICE}/k8s/secret.yaml"
    fi

    # For users service, set the same API key for validation
    if [ "$SERVICE" == "users" ]; then
        # Users service needs to validate incoming requests with this key
        sed -i "s|USERS_SERVICE_API_KEY: \"CHANGE_ME\"|USERS_SERVICE_API_KEY: \"${USERS_API_KEY}\"|g" "${SERVICE}/k8s/secret.yaml" 2>/dev/null || true
    fi

    echo "    ✓ ${SERVICE}/k8s/secret.yaml created"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ All secrets generated successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "IMPORTANT:"
echo "  • secret.yaml files contain sensitive data"
echo "  • They are .gitignored and should NEVER be committed"
echo "  • Keep them safe on your local machine only"
echo ""
echo "Next step: Apply secrets to Kubernetes"
echo "  → kubectl apply -f */k8s/secret.yaml"
echo ""
