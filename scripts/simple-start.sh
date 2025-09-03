#!/bin/bash

# Ultra-simple server start for troubleshooting
# Usage: ./scripts/simple-start.sh <environment>

ENV=${1:-development}

echo "🚀 Starting $ENV server (simple mode)"

# Function to load environment variables
load_env() {
    local env_file=".env.$1"
    if [ -f "$env_file" ]; then
        export $(grep -v '^#' "$env_file" | xargs)
        echo "🔧 Environment loaded from $env_file"
    else
        echo "⚠️  Warning: Environment file $env_file not found"
    fi
}

case $ENV in
    development)
        load_env "development"
        echo "Command: vite dev --port 3000"
        vite dev --port 3000
        ;;
    production)
        load_env "production"
        echo "Command: node build/index.js"
        node build/index.js
        ;;
    test)
        load_env "test"
        echo "Command: node build/index.js"
        node build/index.js
        ;;
    *)
        echo "❌ Unknown environment: $ENV"
        exit 1
        ;;
esac

echo "\n✅ Server stopped"
