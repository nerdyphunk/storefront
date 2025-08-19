#!/bin/bash
set -e

echo "🚀 Deploying Saleor Storefront..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  Creating .env from .env.example"
    cp .env.example .env
    echo "📝 Please edit .env with your Saleor backend URL"
fi

# Build and start with Docker Compose
echo "🏗️  Building Docker image..."
docker-compose -f docker-compose.prod.yml build

echo "🚀 Starting application..."
docker-compose -f docker-compose.prod.yml up -d

echo "✅ Deployment complete!"
echo "🌐 Application available at: http://localhost:3000"
echo "📊 Check status with: docker-compose -f docker-compose.prod.yml ps"
echo "📝 View logs with: docker-compose -f docker-compose.prod.yml logs -f"
