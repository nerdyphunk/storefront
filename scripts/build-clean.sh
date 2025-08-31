#!/bin/bash
set -e

# Скрипт для сборки без npm warnings
# Использование: ./scripts/build-clean.sh [env-file]

ENV_FILE=${1:-.env.development}
echo "🏗️  Building with environment: $ENV_FILE"

# Определяем пакетный менеджер (приоритет pnpm)
if [ -f "pnpm-lock.yaml" ] && (command -v pnpm > /dev/null 2>&1 || command -v corepack > /dev/null 2>&1); then
    PKG_MANAGER="pnpm"
    PKG_EXEC="pnpm exec"
    # Если pnpm недоступен, активируем через corepack
    if ! command -v pnpm > /dev/null 2>&1; then
        corepack enable 2>/dev/null || true
    fi
else
    PKG_MANAGER="npm"
    PKG_EXEC="npx"
    # Временно убираем проблемные настройки для npm
    export npm_config_verify_deps_before_run=false
    export npm_config__jsr_registry=
fi

echo "📦 Using package manager: $PKG_MANAGER"

# Запускаем сборку с правильной конфигурацией окружения
$PKG_EXEC dotenv-cli -e "$ENV_FILE" -- $PKG_MANAGER run build

echo "✅ Build completed successfully!"
