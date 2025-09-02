#!/bin/bash

# Clean server start with proper signal handling
# Usage: ./scripts/start-clean.sh <environment>

ENV=${1:-development}

# Suppress npm lifecycle errors
export npm_config_loglevel=error
export npm_config_progress=false

# Save original terminal settings
original_stty=$(stty -g 2>/dev/null)

# Process PID tracking
server_pid=""
shutdown_in_progress=false

# Function to restore terminal and cleanup
cleanup() {
    if [ "$shutdown_in_progress" = true ]; then
        echo "\n⚡ Force killing..."
        if [ -n "$server_pid" ]; then
            kill -KILL "$server_pid" 2>/dev/null
        fi
        exit 1
    fi
    
    shutdown_in_progress=true
    echo "\n🛑 Shutting down $ENV server..."
    
    # Kill server process
    if [ -n "$server_pid" ]; then
        kill -TERM "$server_pid" 2>/dev/null
        
        # Wait up to 5 seconds for graceful shutdown
        local count=0
        while [ $count -lt 50 ] && kill -0 "$server_pid" 2>/dev/null; do
            sleep 0.1
            count=$((count + 1))
        done
        
        # Force kill if still running
        if kill -0 "$server_pid" 2>/dev/null; then
            echo "⚠️  Force killing after timeout"
            kill -KILL "$server_pid" 2>/dev/null
        fi
    fi
    
    # Restore terminal settings
    if [ -n "$original_stty" ]; then
        stty "$original_stty" 2>/dev/null
    fi
    
    echo "✅ Server stopped"
    exit 0
}

# Set up signal traps
trap cleanup INT TERM EXIT

echo "🚀 Starting $ENV server (clean mode)"
echo "💡 Press Ctrl+C once to stop (double Ctrl+C to force)"

# Start server based on environment
case $ENV in
    development)
        # Use stty raw mode temporarily to avoid terminal issues with vite
        stty raw 2>/dev/null; stty -raw 2>/dev/null
        npx dotenv-cli -e .env.development -- node_modules/.bin/vite dev --port 3000 &
        server_pid=$!
        ;;
    production)
        npx dotenv-cli -e .env.production -- node build/index.js &
        server_pid=$!
        ;;
    test)
        npx dotenv-cli -e .env.test -- node build/index.js &
        server_pid=$!
        ;;
    *)
        echo "❌ Unknown environment: $ENV"
        exit 1
        ;;
esac

# Check if server started successfully
if [ -z "$server_pid" ]; then
    echo "❌ Failed to start server"
    exit 1
fi

# Wait for server process
echo "Server PID: $server_pid"
wait "$server_pid" 2>/dev/null
exit_code=$?

# Clean exit
if [ "$shutdown_in_progress" != true ]; then
    echo "\nServer exited with code: $exit_code"
fi

cleanup
