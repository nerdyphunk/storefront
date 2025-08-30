#!/bin/bash
set -e

# Скрипт для генерации GraphQL кода без npm warnings

echo "🔄 Generating GraphQL types..."

# Используем правильный пакетный менеджер
if command -v pnpm > /dev/null 2>&1; then
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

echo "✅ GraphQL types generated successfully!"
