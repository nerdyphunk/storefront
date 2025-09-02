#!/bin/bash

# Development server with terminal fix
# Usage: ./scripts/dev-start.sh

echo "🚀 Starting development server"
echo "💡 Press Ctrl+C to stop"

# Direct approach - call vite dev directly with proper signal handling
npx dotenv-cli -e .env.development -- vite dev

# Ensure terminal is reset after exit
stty sane 2>/dev/null || true
echo "✅ Development server stopped"
