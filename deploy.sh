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

# Parse environment from arguments or environment variable
ENV=${1:-${NODE_ENV:-development}}
COMPOSE_FILE="docker-compose.${ENV}.yml"

# Fallback to default compose file if environment-specific file doesn't exist
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "⚠️  Environment-specific compose file $COMPOSE_FILE not found, using docker-compose.yml"
    COMPOSE_FILE="docker-compose.yml"
fi

echo "📦 Using: $DOCKER_COMPOSE_CMD"
echo "🌍 Environment: $ENV"
echo "📄 Compose file: $COMPOSE_FILE"

echo "🚀 Deploying Saleor Storefront..."

# Check and create appropriate .env file
ENV_FILE=".env.${ENV}"
if [ ! -f .env ]; then
    if [ -f "$ENV_FILE" ]; then
        echo "⚠️  Creating .env from $ENV_FILE"
        cp "$ENV_FILE" .env
    else
        echo "⚠️  Creating .env from .env.example"
        cp .env.example .env
        echo "📝 Please edit .env with your Saleor backend URL"
    fi
fi

# Load environment variables from file
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Build and start with Docker Compose
echo "🏗️  Building Docker image..."
echo "📦 Updating browserslist database..."
npx update-browserslist-db@latest 2>/dev/null || echo "⚠️  Could not update browserslist (not critical)"

$DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" build

echo "🚀 Starting application..."
$DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" up -d

echo "✅ Deployment complete!"
echo "🌍 Environment: $ENV"

# Display correct port based on environment
case $ENV in
    development)
        echo "🌐 Application available at: http://localhost:3000"
        ;;
    production)
        echo "🌐 Application available at: http://localhost:3001"
        ;;
    test)
        echo "🌐 Application available at: http://localhost:3002"
        ;;
    *)
        echo "🌐 Application available at: http://localhost:3000"
        ;;
esac
echo "📊 Check status with: $DOCKER_COMPOSE_CMD -f $COMPOSE_FILE ps"
echo "📝 View logs with: $DOCKER_COMPOSE_CMD -f $COMPOSE_FILE logs -f"

# Show container status
echo "\n📊 Container Status:"
$DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" ps
