#!/bin/bash
# Docker Compose utility functions

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

# Get Docker Compose command
DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)

# Export for use in other scripts
export DOCKER_COMPOSE_CMD

echo "📦 Docker Compose command: $DOCKER_COMPOSE_CMD"
