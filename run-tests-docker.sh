#!/bin/bash

# Простой скрипт для запуска тестов с приложением в Docker

set -e

# Цветовая раскраска вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Запуск приложения в Docker и выполнение тестов...${NC}"

# Определяем команду Docker Compose
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo -e "${RED}Docker Compose не найден!${NC}"
    exit 1
fi

echo -e "${YELLOW}Используем ${DOCKER_COMPOSE_CMD}${NC}"

# Функция очистки при выходе
cleanup() {
    echo -e "\n${YELLOW}Остановка контейнеров...${NC}"
    $DOCKER_COMPOSE_CMD -f docker-compose.development.yml down 2>/dev/null || true
}

# Устанавливаем обработчик сигналов
trap cleanup EXIT INT TERM

# Остановка существующих контейнеров
echo -e "${YELLOW}Остановка существующих контейнеров...${NC}"
$DOCKER_COMPOSE_CMD -f docker-compose.development.yml down 2>/dev/null || true

# Запуск приложения в Docker
echo -e "${BLUE}Запуск приложения в Docker...${NC}"
$DOCKER_COMPOSE_CMD -f docker-compose.development.yml up -d --build

# Ожидание готовности приложения
echo -e "${YELLOW}Ожидание готовности приложения...${NC}"
for i in {1..30}; do
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        echo -e "${GREEN}Приложение готово!${NC}"
        break
    fi
    echo -n "."
    sleep 2
done

if ! curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${RED}Приложение не запустилось!${NC}"
    $DOCKER_COMPOSE_CMD -f docker-compose.development.yml logs
    exit 1
fi

# Создаем директории для результатов тестов
mkdir -p test-results playwright-report

# Запуск тестов
echo -e "${BLUE}Запуск тестов...${NC}"
if BASE_URL=http://localhost:3000 pnpm exec playwright test "$@"; then
    echo -e "${GREEN}Тесты выполнены успешно!${NC}"
    
    # Показываем информацию о репортах
    if [ -d "playwright-report" ] && [ "$(ls -A playwright-report)" ]; then
        echo -e "${BLUE}Репорт по тестам доступен в ./playwright-report/${NC}"
        echo -e "${BLUE}Для просмотра HTML репорта используйте: npx playwright show-report${NC}"
    fi
    
    exit 0
else
    echo -e "${RED}Тесты завершились с ошибкой!${NC}"
    
    # Показываем логи приложения
    echo -e "${YELLOW}Логи приложения:${NC}"
    $DOCKER_COMPOSE_CMD -f docker-compose.development.yml logs --tail=50
    
    exit 1
fi
