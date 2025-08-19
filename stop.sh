#!/bin/bash
set -e

# Function to detect Docker Compose command
get_docker_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        echo "docker-compose"
    elif docker compose version &> /dev/null; then
        echo "docker compose"
    else
        echo "❌ Neither 'docker-compose' nor 'docker compose' is available!" >&2
        exit 1
    fi
}

DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
ENV=${1:-${NODE_ENV:-development}}
COMPOSE_FILE="docker-compose.${ENV}.yml"

if [ ! -f "$COMPOSE_FILE" ]; then
    COMPOSE_FILE="docker-compose.yml"
fi

echo "📦 Using: $DOCKER_COMPOSE_CMD"
echo "🛑 Stopping Saleor Storefront ($ENV)..."
$DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" down

echo "✅ Application stopped!"
