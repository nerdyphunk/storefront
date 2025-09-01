#!/bin/bash

# Clean server start without ELIFECYCLE errors
# Usage: ./scripts/start-clean.sh <environment>

ENV=${1:-development}

# Suppress npm lifecycle errors
export npm_config_loglevel=error
export npm_config_progress=false

echo "🚀 Starting $ENV server (clean mode)"
echo "💡 Press Ctrl+C once to stop"

# Direct execution to avoid npm wrapper issues
case $ENV in
    development)
        exec npx dotenv-cli -e .env.development -- node_modules/.bin/vite dev --port 3000
        ;;
    production)
        exec npx dotenv-cli -e .env.production -- node_modules/.bin/vite preview --port 3001
        ;;
    test)
        exec npx dotenv-cli -e .env.test -- node_modules/.bin/vite preview --port 3002
        ;;
    *)
        echo "❌ Unknown environment: $ENV"
        exit 1
        ;;
esac
