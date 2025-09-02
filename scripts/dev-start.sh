#!/bin/bash

# Development server with terminal fix
# Usage: ./scripts/dev-start.sh

echo "🚀 Starting development server"
echo "💡 Press Ctrl+C to stop"

# Simple approach - let npm handle the terminal
npx dotenv-cli -e .env.development -- npm run dev

# Ensure terminal is reset after exit
stty sane 2>/dev/null || true
echo "✅ Development server stopped"
