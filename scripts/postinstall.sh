#!/bin/bash
set -e

echo "🔄 Running postinstall setup..."

# Load environment variables from .env files
load_env() {
    local env_file="$1"
    if [ -f "$env_file" ]; then
        export $(grep -v '^#' "$env_file" | xargs)
        echo "🔧 Environment loaded from $env_file"
    fi
}

# Try to load environment variables in order of preference
load_env ".env.development"
load_env ".env"

# 1. First run svelte-kit sync to create .svelte-kit directory and types
echo "📦 Running svelte-kit sync..."
if command -v pnpm > /dev/null 2>&1; then
    pnpm exec svelte-kit sync
elif command -v npx > /dev/null 2>&1; then
    npx svelte-kit sync
else
    echo "❌ No package manager found"
    exit 1
fi

# 2. Create src/gql directory if it doesn't exist
echo "📁 Creating src/gql directory..."
mkdir -p src/gql

# 3. Create basic index.ts file for @gql alias
echo "📄 Creating basic gql index file..."
if [ ! -f "src/gql/index.ts" ]; then
    echo '// Auto-generated GraphQL types will be exported from here
// This file is created during postinstall to prevent import errors during SSR
export {};' > src/gql/index.ts
fi

# 4. Run GraphQL codegen if API URL is available
echo "🔍 Checking PUBLIC_SALEOR_API_URL: $PUBLIC_SALEOR_API_URL"
if [ -n "$PUBLIC_SALEOR_API_URL" ] && [ "$PUBLIC_SALEOR_API_URL" != "" ]; then
    echo "🔄 Running GraphQL codegen..."
    if command -v pnpm > /dev/null 2>&1; then
        pnpm run generate
    else
        npm run generate
    fi
else
    echo "⚠️  PUBLIC_SALEOR_API_URL not set - skipping GraphQL codegen"
    echo "   Run 'npm run generate' after setting up your environment"
fi

echo "✅ Postinstall setup completed!"
