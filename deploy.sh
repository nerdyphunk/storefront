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

echo "🚀 Deploying Saleor Storefront..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  Creating .env from .env.example"
    cp .env.example .env
    echo "📝 Please edit .env with your Saleor backend URL"
fi

# Build and start with Docker Compose
echo "🏗️  Building Docker image..."
echo "📦 Updating browserslist database..."
npx update-browserslist-db@latest 2>/dev/null || echo "⚠️  Could not update browserslist (not critical)"

$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml build

echo "🚀 Starting application..."
$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml up -d

echo "✅ Deployment complete!"
echo "🌐 Application available at: http://localhost:3000"
echo "📊 Check status with: $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml ps"
echo "📝 View logs with: $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml logs -f"
