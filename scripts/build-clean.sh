#!/bin/bash
set -e

# Скрипт для сборки без npm warnings
# Использование: ./scripts/build-clean.sh [env-file]

ENV_FILE=${1:-.env.development}
echo "🏗️  Building with environment: $ENV_FILE"

# Detect available package manager with preference for pnpm
if command -v corepack > /dev/null 2>&1; then
    corepack enable 2>/dev/null || true
fi

# Check for pnpm first (preferred)
if command -v pnpm > /dev/null 2>&1 && pnpm --version > /dev/null 2>&1; then
    PKG_MANAGER="pnpm"
    echo "📦 Using package manager: $PKG_MANAGER"
elif command -v npm > /dev/null 2>&1 && npm --version > /dev/null 2>&1; then
    PKG_MANAGER="npm"
    # Temporarily remove problematic npm settings
    export npm_config_verify_deps_before_run=false
    export npm_config__jsr_registry=
    echo "📦 Using package manager: $PKG_MANAGER"
else
    echo "❌ No package manager found. Please install npm or pnpm."
    exit 1
fi

# Load environment variables
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
    echo "🔧 Environment loaded from $ENV_FILE"
else
    echo "⚠️  Warning: Environment file $ENV_FILE not found"
fi

# Run build with proper environment configuration
$PKG_MANAGER run build

echo "✅ Build completed successfully!"
