#!/bin/bash

# =============================================================================
# Development Environment Startup Script
# Usage: ./dev-up.sh [start|stop|logs|status] [-d]
# Options:
#   -d    Run containers in detached mode (background)
# =============================================================================

set -e

SERVICES=(admin blog frontend sso users analytics)
COMPOSE_FILE="docker-compose.yml"
ACTION="${1:-start}"
DETACHED=""

# Check if -d flag is provided
if [ "$2" = "-d" ] || [ "$1" = "-d" ]; then
    DETACHED="-d"
    # If -d is first argument, shift to get actual action
    if [ "$1" = "-d" ]; then
        ACTION="${2:-start}"
    fi
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

start_services() {
    log_info "Starting development environment$([ -n "$DETACHED" ] && echo " (detached mode)" || echo "...")"
    
    # Start infrastructure first (if in root)
    if [ -f "docker-compose.yml" ]; then
        log_info "Starting infrastructure (Traefik, RabbitMQ, Prometheus, Grafana, Loki)..."
        docker compose -f docker-compose.yml up $DETACHED
        log_success "Infrastructure started"
        [ -z "$DETACHED" ] && sleep 5 || sleep 2
    fi
    
    # Start each service
    for service in "${SERVICES[@]}"; do
        if [ -d "$service" ]; then
            log_info "Starting $service..."
            cd "$service"
            
            if [ -f "$COMPOSE_FILE" ]; then
                docker compose -f "$COMPOSE_FILE" up $DETACHED
                log_success "$service started"
            else
                log_warning "$service/$COMPOSE_FILE not found, skipping"
            fi
            
            cd ..
        else
            log_warning "$service directory not found, skipping"
        fi
    done
    
    log_success "Development environment started!"
    echo ""
    echo -e "${BLUE}=== Service URLs ===${NC}"
    echo "Admin:     http://localhost:8080"
    echo "Blog:      http://localhost:8081"
    echo "Frontend:  http://localhost:8082"
    echo "SSO:       http://localhost:8083"
    echo "Users:     http://localhost:8084"
    echo "Analytics: http://localhost:8085"
    echo ""
    echo -e "${BLUE}=== Infrastructure URLs ===${NC}"
    echo "RabbitMQ Management: http://localhost:15672 (guest/guest)"
    echo "Grafana:             http://localhost:3000 (admin/admin)"
    echo "Prometheus:          http://localhost:9090"
    echo "Traefik Dashboard:   http://localhost:8080 (dashboard)"
    echo ""
    [ -z "$DETACHED" ] && log_info "Press Ctrl+C to stop all services" || log_info "Run './dev-up.sh logs' to see logs"
}

stop_services() {
    log_info "Stopping development environment..."
    
    # Stop each service
    for service in "${SERVICES[@]}"; do
        if [ -d "$service" ]; then
            log_info "Stopping $service..."
            cd "$service"
            
            if [ -f "$COMPOSE_FILE" ]; then
                docker compose -f "$COMPOSE_FILE" down --remove-orphans 2>/dev/null || true
                log_success "$service stopped"
            fi
            
            cd ..
        fi
    done
    
    # Stop infrastructure
    if [ -f "docker-compose.yml" ]; then
        log_info "Stopping infrastructure..."
        docker compose -f docker-compose.yml down --remove-orphans 2>/dev/null || true
        log_success "Infrastructure stopped"
    fi
    
    log_success "Development environment stopped!"
}

show_logs() {
    log_info "Showing logs (Ctrl+C to exit)..."
    
    # Build initial docker compose command
    cmd="docker compose"
    
    # Add all service compose files
    for service in "${SERVICES[@]}"; do
        if [ -d "$service" ] && [ -f "$service/$COMPOSE_FILE" ]; then
            cmd="$cmd -f $service/$COMPOSE_FILE"
        fi
    done
    
    # Add root compose file if exists
    if [ -f "$COMPOSE_FILE" ]; then
        cmd="$cmd -f $COMPOSE_FILE"
    fi
    
    cmd="$cmd logs -f"
    eval "$cmd"
}

show_status() {
    log_info "Checking services status..."
    echo ""
    
    # Check infrastructure
    if [ -f "docker-compose.yml" ]; then
        log_info "Infrastructure:"
        docker compose -f docker-compose.yml ps --no-trunc
        echo ""
    fi
    
    # Check each service
    for service in "${SERVICES[@]}"; do
        if [ -d "$service" ] && [ -f "$service/$COMPOSE_FILE" ]; then
            log_info "$service:"
            cd "$service"
            docker compose -f "$COMPOSE_FILE" ps --no-trunc
            cd ..
            echo ""
        fi
    done
}

case "$ACTION" in
    start|up)
        start_services
        ;;
    stop|down)
        stop_services
        ;;
    logs)
        show_logs
        ;;
    status|ps)
        show_status
        ;;
    restart)
        stop_services
        echo ""
        start_services
        ;;
    *)
        echo "Usage: $0 [start|stop|logs|status|restart] [-d]"
        echo ""
        echo "Commands:"
        echo "  start    - Start development environment"
        echo "  stop     - Stop development environment"
        echo "  logs     - Show logs from all services"
        echo "  status   - Show status of all services"
        echo "  restart  - Restart development environment"
        echo ""
        echo "Options:"
        echo "  -d       - Run containers in detached mode (background)"
        echo ""
        echo "Examples:"
        echo "  ./dev-up.sh start       # Start with logs shown"
        echo "  ./dev-up.sh start -d    # Start in background"
        echo "  ./dev-up.sh logs        # Show logs"
        exit 1
        ;;
esac
