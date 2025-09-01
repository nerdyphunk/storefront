#!/bin/bash

# Ultra-clean server start that handles Ctrl+C properly
# Usage: ./scripts/clean-start.sh <command> [args...]

if [ $# -eq 0 ]; then
    echo "Usage: $0 <command> [args...]"
    echo "Example: $0 npm run dev"
    exit 1
fi

# Save original terminal settings
original_stty=$(stty -g)

# Function to restore terminal and exit cleanly
cleanup() {
    echo "\n💫 Cleaning up..."
    
    # Restore terminal settings
    stty "$original_stty" 2>/dev/null
    
    # Kill child processes
    if [ ! -z "$child_pid" ]; then
        kill -TERM "$child_pid" 2>/dev/null
        wait "$child_pid" 2>/dev/null
    fi
    
    echo "✅ Done"
    exit 0
}

# Set up trap
trap cleanup INT TERM EXIT

echo "🚀 Starting: $@"
echo "💡 Press Ctrl+C to stop cleanly"

# Execute command and capture PID
"$@" &
child_pid=$!

# Wait for child process
wait "$child_pid" 2>/dev/null
exit_code=$?

# Clean exit
stty "$original_stty" 2>/dev/null
exit $exit_code
