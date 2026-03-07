#!/bin/bash

# =============================================================================
# Minikube + ArgoCD Deployment Script
# Builds services for minikube and syncs with ArgoCD
# Usage: ./k8s-deploy.sh [build|sync|all]
# =============================================================================

set -e

SERVICES=(admin blog frontend sso users analytics)
IMAGE_REGISTRY="portfolio"  # Local minikube registry prefix
NAMESPACE="microservices"

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
    
    status=$(minikube status 2>/dev/null | grep -c "Running" || echo "0")
    if [ "$status" -eq 0 ]; then
        log_error "minikube is not running"
        log_info "Run: minikube start"
        return 1
    fi
    
    log_success "minikube is running"
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

sync_argocd() {
    log_info "Syncing ArgoCD applications..."
    
    # Check if ArgoCD is available
    argocd_pods=$(kubectl get pods -n argocd 2>/dev/null | grep -c "Running" || echo "0")
    if [ "$argocd_pods" -eq 0 ]; then
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
    
    # Sync each application
    for service in "${SERVICES[@]}"; do
        app_name="portfolio-${service}"
        log_info "Syncing $app_name..."
        
        kubectl rollout restart deployment/$service -n $NAMESPACE 2>/dev/null || log_warning "Could not restart deployment/$service"
    done
    
    log_success "ArgoCD applications triggered for sync"
}

check_deployments() {
    log_info "Checking deployment status..."
    echo ""
    
    kubectl get deployments -n $NAMESPACE --no-headers || log_warning "No deployments found"
    echo ""
    
    kubectl get pods -n $NAMESPACE --no-headers || log_warning "No pods found"
    echo ""
    
    log_info "Watching pods (Ctrl+C to exit)..."
    kubectl get pods -n $NAMESPACE -w
}

show_urls() {
    log_info "Service URLs:"
    echo ""
    
    MINIKUBE_IP=$(minikube ip 2>/dev/null || echo "localhost")
    
    echo "Admin:     http://$MINIKUBE_IP/admin"
    echo "Blog:      http://$MINIKUBE_IP/blog"
    echo "Frontend:  http://$MINIKUBE_IP/frontend"
    echo "SSO:       http://$MINIKUBE_IP/sso"
    echo "Users:     http://$MINIKUBE_IP/users"
    echo "Analytics: http://$MINIKUBE_IP/analytics"
    echo ""
    
    log_info "For ArgoCD UI:"
    echo "kubectl port-forward svc/argocd-server -n argocd 8081:443"
    echo "https://localhost:8081 (admin / <password>)"
}

main() {
    local ACTION="${1:-all}"
    
    case "$ACTION" in
        build)
            check_minikube || exit 1
            setup_docker_env
            build_images
            update_manifests
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
            echo "Usage: $0 [build|sync|all|status|urls]"
            echo ""
            echo "Commands:"
            echo "  build   - Build service images for minikube"
            echo "  sync    - Trigger ArgoCD sync and check status"
            echo "  all     - Build and sync (complete deployment)"
            echo "  status  - Check deployment status and watch pods"
            echo "  urls    - Show service URLs"
            echo ""
            echo "Example:"
            echo "  ./k8s-deploy.sh all"
            exit 1
            ;;
    esac
}

main "$@"
