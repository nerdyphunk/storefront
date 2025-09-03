#!/bin/bash

# Development server with proper signal handling
# Usage: ./scripts/dev-start.sh

echo "🚀 Starting development server"
echo "💡 Press Ctrl+C to stop"

# Load environment variables
if [ -f ".env.development" ]; then
    export $(grep -v '^#' .env.development | xargs)
    echo "🔧 Environment loaded from .env.development"
fi

# Use exec to replace the shell process directly
# This avoids signal propagation issues through process chains
exec vite dev
