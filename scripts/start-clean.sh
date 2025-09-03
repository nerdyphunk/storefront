#!/bin/bash

# Clean server start with proper signal handling
# Usage: ./scripts/start-clean.sh <environment>

ENV=${1:-development}

# Prevent npm lifecycle errors by setting proper signal handling
export npm_config_loglevel=error
export npm_config_progress=false

# Process PID tracking
server_pid=""
shutdown_in_progress=false

# Function to restore terminal and cleanup
cleanup() {
    if [ "$shutdown_in_progress" = true ]; then
        echo "\n⚡ Force killing..."
        if [ -n "$server_pid" ]; then
            kill -KILL "$server_pid" 2>/dev/null || true
        fi
        exit 1
    fi
    
    shutdown_in_progress=true
    echo "\n🛑 Shutting down $ENV server..."
    
    # Kill server process with proper signal propagation
    if [ -n "$server_pid" ]; then
        # Send SIGTERM first
        kill -TERM "$server_pid" 2>/dev/null || true
        
        # Wait up to 5 seconds for graceful shutdown
        local count=0
        while [ $count -lt 50 ] && kill -0 "$server_pid" 2>/dev/null; do
            sleep 0.1
            count=$((count + 1))
        done
        
        # Force kill if still running
        if kill -0 "$server_pid" 2>/dev/null; then
            echo "⚠️  Force killing after timeout"
            kill -KILL "$server_pid" 2>/dev/null || true
        fi
    fi
    
    echo "✅ Server stopped"
    exit 0
}

# Set up signal traps
trap cleanup INT TERM
# Also handle EXIT to cleanup on script exit
trap cleanup EXIT

echo "🚀 Starting $ENV server (clean mode)"
echo "💡 Press Ctrl+C once to stop (double Ctrl+C to force)"

# Load environment variables
load_env() {
    local env_file=".env.$1"
    if [ -f "$env_file" ]; then
        export $(grep -v '^#' "$env_file" | xargs)
        echo "🔧 Environment loaded from $env_file"
    else
        echo "⚠️  Warning: Environment file $env_file not found"
    fi
}

# Start server based on environment with exec to replace the shell process
case $ENV in
    development)
        load_env "development"
        # Use exec to replace shell process, avoiding extra process layer
        exec node_modules/.bin/vite dev --port 3000
        ;;
    production)
        load_env "production"
        # Direct execution to avoid npm wrapper issues  
        echo "Server PID: $$"
        exec node build/index.js
        ;;
    test)
        load_env "test"
        # Direct execution to avoid npm wrapper issues
        echo "Server PID: $$"
        exec node build/index.js
        ;;
    *)
        echo "❌ Unknown environment: $ENV"
        exit 1
        ;;
esac
