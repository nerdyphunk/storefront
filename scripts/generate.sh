#!/bin/bash
set -e

# Скрипт для генерации GraphQL кода без npm warnings

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

echo "🔄 Generating GraphQL types..."
echo "🔍 Using PUBLIC_SALEOR_API_URL: $PUBLIC_SALEOR_API_URL"

# Создаем директорию src/gql если она не существует
mkdir -p src/gql

# Определяем правильный пакетный менеджер
if [ -f "pnpm-lock.yaml" ] && (command -v pnpm > /dev/null 2>&1 || command -v corepack > /dev/null 2>&1); then
    # Если pnpm недоступен, активируем через corepack
    if ! command -v pnpm > /dev/null 2>&1; then
        corepack enable 2>/dev/null || true
    fi
    pnpm exec graphql-codegen --config .graphqlrc.ts
elif command -v npx > /dev/null 2>&1; then
    # Временно устанавливаем чистую конфигурацию для npm
    export npm_config_verify_deps_before_run=false
    export npm_config__jsr_registry=
    npx graphql-codegen --config .graphqlrc.ts
else
    echo "❌ No package manager found"
    exit 1
fi

# Check if GraphQL codegen created proper types
echo "🔧 Checking GraphQL exports..."

if [ -f "src/gql/index.ts" ] && grep -q "export.*Document" src/gql/index.ts; then
    echo "✅ GraphQL codegen created proper types"
else
    echo "⚠️  GraphQL codegen didn't create proper exports, creating fallback"
    echo 'export * from "./gql";
export * from "./graphql";' > src/gql/index.ts
fi

echo "✅ GraphQL types generated successfully!"
