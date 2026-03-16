#!/bin/bash

# =============================================================================
# Minikube Deployment Script
# Full local K8s environment bootstrap and service management
# Usage: ./k8s-deploy.sh [up|build|sync|all|status|urls]
#   up    - Start minikube, apply all manifests, update DNS (after reboot)
#   build - Build images and apply deployments
#   all   - Build + sync + check (full redeploy)
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SERVICES=(admin blog frontend sso users analytics)
IMAGE_REGISTRY="portfolio"  # Local minikube registry prefix
NAMESPACE="portfolio"
KUBE_HOSTS=(portfolio.kube admin.portfolio.kube sso.portfolio.kube)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

check_minikube() {
    log_info "Checking minikube status..."
    
    if ! command -v minikube &> /dev/null; then
        log_error "minikube not found in PATH"
        return 1
    fi
    
    status=$(minikube status 2>/dev/null | grep -c "Running" 2>/dev/null) || status=0
    if [ "${status:-0}" -eq 0 ]; then
        log_error "minikube is not running"
        log_info "Run: minikube start"
        return 1
    fi
    
    log_success "minikube is running"
}

start_minikube() {
    log_info "Ensuring minikube is running..."
    
    if ! command -v minikube &> /dev/null; then
        log_error "minikube not found in PATH"
        return 1
    fi
    
    status=$(minikube status 2>/dev/null | grep -c "Running" 2>/dev/null) || status=0
    if [ "${status:-0}" -gt 0 ]; then
        log_success "minikube is already running"
        return 0
    fi
    
    log_info "Starting minikube..."
    minikube start --memory=8192 --cpus=4
    log_success "minikube started"
}

update_hosts() {
    log_info "Updating /etc/hosts with minikube IP..."
    
    local minikube_ip
    minikube_ip=$(minikube ip 2>/dev/null)
    if [ -z "$minikube_ip" ]; then
        log_error "Could not determine minikube IP"
        return 1
    fi
    
    log_info "Minikube IP: $minikube_ip"
    
    local needs_update=false
    for host in "${KUBE_HOSTS[@]}"; do
        current_ip=$(grep -E "\\s${host}$" /etc/hosts 2>/dev/null | awk '{print $1}' | head -1)
        if [ "$current_ip" != "$minikube_ip" ]; then
            needs_update=true
            break
        fi
    done
    
    if [ "$needs_update" = false ]; then
        log_success "/etc/hosts already up to date"
        return 0
    fi
    
    log_info "Sudo required to update /etc/hosts..."
    
    local hosts_entry="$minikube_ip ${KUBE_HOSTS[*]}"
    
    # Remove old portfolio.kube entries, then append new one
    sudo sh -c "
        sed -i '/portfolio\.kube/d' /etc/hosts
        echo '$hosts_entry' >> /etc/hosts
    "
    
    log_success "/etc/hosts updated: $hosts_entry"
}

setup_docker_env() {
    log_info "Configuring Docker to use minikube daemon..."
    
    eval $(minikube docker-env)
    log_success "Docker environment configured for minikube"
}

build_images() {
    log_info "Building service images for minikube..."
    
    for service in "${SERVICES[@]}"; do
        if [ ! -d "$service" ]; then
            log_warning "$service directory not found, skipping"
            continue
        fi
        
        DOCKERFILE="$service/docker/deploy/php/Dockerfile"
        
        if [ ! -f "$DOCKERFILE" ]; then
            log_warning "$DOCKERFILE not found, skipping $service"
            continue
        fi
        
        IMAGE_TAG="${IMAGE_REGISTRY}-${service}:latest"
        log_info "Building $IMAGE_TAG..."
        
        # build context points to the service's src directory (Dockerfile expects files under /src)
        # build context is the service root directory so that Dockerfile COPY commands
        # which reference ../src or src/* will resolve correctly
        CONTEXT_DIR="$service"
        docker build \
            -t "$IMAGE_TAG" \
            -f "$DOCKERFILE" \
            "$CONTEXT_DIR" \
            --progress=plain
        
        log_success "$IMAGE_TAG built successfully"
    done
}

update_manifests() {
    log_info "Updating deployment manifests with local image tags..."
    
    for service in "${SERVICES[@]}"; do
        DEPLOY_FILE="$service/k8s/deployment.yaml"
        
        if [ ! -f "$DEPLOY_FILE" ]; then
            log_warning "$DEPLOY_FILE not found, skipping"
            continue
        fi
        
        IMAGE_TAG="${IMAGE_REGISTRY}-${service}:latest"
        
        # Update image in deployment.yaml
        # Use minikube's imagePullPolicy=Never to use local images
        sed -i "s|image:.*portfolio.*|image: ${IMAGE_TAG}|g" "$DEPLOY_FILE"
        
        # Ensure imagePullPolicy is set to Never for local images
        if ! grep -q "imagePullPolicy: Never" "$DEPLOY_FILE"; then
            sed -i "/image: ${IMAGE_TAG}/a\\            imagePullPolicy: Never" "$DEPLOY_FILE"
        fi
        
        log_success "Updated $DEPLOY_FILE with image: $IMAGE_TAG"
    done
}

apply_infra() {
    log_info "Applying shared infrastructure resources..."
    
    local infra_files=(
        "infra/k8s/namespace.yaml"
        "infra/k8s/rabbitmq.yaml"
    )
    
    for f in "${infra_files[@]}"; do
        if [ -f "$f" ]; then
            if kubectl apply -f "$f"; then
                log_success "Applied $f"
            else
                log_warning "Could not apply $f"
            fi
        else
            log_warning "$f not found, skipping"
        fi
    done
    
    log_info "Waiting for namespace $NAMESPACE to be ready..."
    kubectl wait --for=jsonpath='{.status.phase}'=Active "namespace/$NAMESPACE" --timeout=30s 2>/dev/null || true
}

apply_services() {
    log_info "Applying all K8s resources for services..."
    
    # Order matters: secrets/configmaps before databases, databases before apps
    local manifest_order=(
        secret.yaml
        configmap.yaml
        mysql.yaml
        redis.yaml
        service.yaml
        deployment.yaml
        consumer-deployment.yaml
        ingress.yaml
    )
    
    for service in "${SERVICES[@]}"; do
        local k8s_dir="$service/k8s"
        if [ ! -d "$k8s_dir" ]; then
            log_warning "$k8s_dir not found, skipping"
            continue
        fi
        
        log_info "Applying manifests for $service..."
        
        for manifest in "${manifest_order[@]}"; do
            local filepath="$k8s_dir/$manifest"
            if [ -f "$filepath" ]; then
                if kubectl apply -f "$filepath" 2>/dev/null; then
                    log_success "  $manifest"
                else
                    log_warning "  $manifest (failed - check dependencies)"
                fi
            fi
        done
    done
}

ensure_tls() {
    log_info "Ensuring TLS certificates exist..."
    
    local tls_secrets=(frontend-tls admin-tls sso-tls)
    local needs_cert=false
    local missing_secrets=()
    
    for secret in "${tls_secrets[@]}"; do
        if ! kubectl get secret "$secret" -n "$NAMESPACE" &>/dev/null; then
            needs_cert=true
            missing_secrets+=("$secret")
        fi
    done
    
    if [ "$needs_cert" = false ]; then
        log_success "All TLS secrets already exist"
        return 0
    fi
    
    log_info "Generating self-signed TLS certificate..."
    
    local tmp_dir
    tmp_dir=$(mktemp -d)
    local san_list
    san_list=$(printf "DNS:%s," "${KUBE_HOSTS[@]}")
    san_list="${san_list%,}"
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$tmp_dir/tls.key" -out "$tmp_dir/tls.crt" \
        -subj "/CN=portfolio.kube" \
        -addext "subjectAltName=$san_list" 2>/dev/null
    
    for secret in "${missing_secrets[@]}"; do
        kubectl create secret tls "$secret" \
            --cert="$tmp_dir/tls.crt" --key="$tmp_dir/tls.key" \
            -n "$NAMESPACE" 2>/dev/null \
            && log_success "Created TLS secret: $secret" \
            || log_warning "Could not create TLS secret: $secret"
    done
    
    rm -rf "$tmp_dir"
}

apply_manifests() {
    apply_infra
    apply_services
    ensure_tls
}

sync_argocd() {
    log_info "Syncing ArgoCD applications..."
    
    # Check if ArgoCD is available
    argocd_pods=$(kubectl get pods -n argocd 2>/dev/null | grep -c "Running" 2>/dev/null) || argocd_pods=0
    if [ "${argocd_pods:-0}" -eq 0 ]; then
        log_warning "ArgoCD pods not running in argocd namespace"
        log_info "Proceeding without ArgoCD sync..."
        return 0
    fi
    
    # Get ArgoCD server pod for CLI access
    argocd_server=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
    
    if [ -z "$argocd_server" ]; then
        log_warning "ArgoCD server pod not found"
        log_info "Manual sync may be needed in ArgoCD UI"
        return 0
    fi
    
    log_info "Triggering manual sync in ArgoCD..."
    
    # Sync each application (deployment names: admin-app, blog-app, etc.)
    for service in "${SERVICES[@]}"; do
        deployment="${service}-app"
        log_info "Syncing portfolio-${service} (deployment/${deployment})..."
        
        kubectl rollout restart deployment/$deployment -n $NAMESPACE 2>/dev/null || log_warning "Could not restart deployment/$deployment"
    done
    
    log_success "ArgoCD applications triggered for sync"
}

check_deployments() {
    log_info "Checking deployment status..."
    echo ""
    
    kubectl get deployments -n $NAMESPACE --no-headers 2>/dev/null || log_warning "No deployments found"
    echo ""
    
    kubectl get statefulsets -n $NAMESPACE --no-headers 2>/dev/null || true
    echo ""
    
    kubectl get pods -n $NAMESPACE 2>/dev/null || log_warning "No pods found"
}

wait_for_pods() {
    log_info "Waiting for pods to be ready (timeout 5m)..."
    
    local timeout=300
    local elapsed=0
    local interval=10
    
    while [ $elapsed -lt $timeout ]; do
        local not_ready
        not_ready=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null \
            | grep -v "Running\|Completed" | wc -l) || not_ready=99
        
        if [ "$not_ready" -eq 0 ]; then
            local total
            total=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l)
            if [ "$total" -gt 0 ]; then
                log_success "All $total pods are running"
                return 0
            fi
        fi
        
        log_info "  $not_ready pod(s) not yet ready... (${elapsed}s/${timeout}s)"
        sleep $interval
        elapsed=$((elapsed + interval))
    done
    
    log_warning "Some pods may not be fully ready yet. Check with: ./k8s-deploy.sh status"
}

show_urls() {
    log_info "Service URLs:"
    echo ""
    
    echo "  Frontend:  https://portfolio.kube"
    echo "  Admin:     https://admin.portfolio.kube"
    echo "  SSO:       https://sso.portfolio.kube"
    echo ""
    
    log_info "Internal services (cluster-only): blog, users, analytics"
    echo ""
    
    log_info "For ArgoCD UI:"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8081:443"
    echo "  https://localhost:8081 (admin / <password>)"
}

main() {
    local ACTION="${1:-all}"
    
    case "$ACTION" in
        up)
            start_minikube
            update_hosts
            setup_docker_env
            apply_infra
            apply_services
            ensure_tls
            wait_for_pods
            check_deployments
            show_urls
            ;;
        build)
            check_minikube || exit 1
            setup_docker_env
            build_images
            update_manifests
            apply_manifests
            ;;
        sync)
            sync_argocd
            check_deployments
            show_urls
            ;;
        all)
            check_minikube || exit 1
            setup_docker_env
            build_images
            update_manifests
            apply_manifests
            sync_argocd
            check_deployments
            show_urls
            ;;
        status)
            check_deployments
            ;;
        urls)
            show_urls
            ;;
        *)
            echo "Usage: $0 [up|build|sync|all|status|urls]"
            echo ""
            echo "Commands:"
            echo "  up      - Start minikube, apply all manifests, update /etc/hosts (full bootstrap)"
            echo "  build   - Build service images for minikube"
            echo "  sync    - Trigger ArgoCD sync and check status"
            echo "  all     - Build images, apply manifests, and sync (complete deployment)"
            echo "  status  - Check deployment status"
            echo "  urls    - Show service URLs"
            echo ""
            echo "After reboot:  ./k8s-deploy.sh up"
            echo "After changes: ./k8s-deploy.sh all"
            exit 1
            ;;
    esac
}

main "$@"
