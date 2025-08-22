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

# Get the appropriate Docker Compose command
DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
echo "📦 Using: $DOCKER_COMPOSE_CMD"

echo "📊 Checking application status..."
$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml ps

echo ""
echo "🌐 Applications should be available at:"
echo "  Development:  http://localhost:3000"
echo "  Production:   http://localhost:3001"
echo "  Test:         http://localhost:3002"
echo "📝 To view logs: ./logs.sh"
echo "🛑 To stop: ./stop.sh"
