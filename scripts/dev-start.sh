#!/bin/bash

# Development server with proper signal handling
# Usage: ./scripts/dev-start.sh

echo "🚀 Starting development server"
echo "💡 Press Ctrl+C to stop"

# Use exec to replace the shell process directly
# This avoids signal propagation issues through process chains
exec npx dotenv-cli -e .env.development -- vite dev
