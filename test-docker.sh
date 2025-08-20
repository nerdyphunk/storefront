#!/bin/bash

# Скрипт для запуска тестов в Docker контейнере

set -e

# Цветовая раскраска вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Запуск тестов в Docker контейнере...${NC}"

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker не установлен. Установите Docker для продолжения.${NC}"
    exit 1
fi

# Проверяем наличие Docker Compose
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo -e "${RED}Docker Compose не найден. Установите Docker Compose для продолжения.${NC}"
    exit 1
fi

echo -e "${YELLOW}Используем ${DOCKER_COMPOSE_CMD}${NC}"

# Функция очистки при выходе
cleanup() {
    echo -e "\n${YELLOW}Остановка и очистка контейнеров...${NC}"
    $DOCKER_COMPOSE_CMD -f docker-compose.test.yml down --remove-orphans
    # Удаляем volumes если надо
    # $DOCKER_COMPOSE_CMD -f docker-compose.test.yml down --volumes
}

# Устанавливаем обработчик сигналов
trap cleanup EXIT INT TERM

# Останавливаем существующие контейнеры
echo -e "${YELLOW}Остановка существующих тестовых контейнеров...${NC}"
$DOCKER_COMPOSE_CMD -f docker-compose.test.yml down --remove-orphans 2>/dev/null || true

# Создаем директории для результатов тестов
echo -e "${YELLOW}Создаем директории для результатов тестов...${NC}"
mkdir -p test-results playwright-report

# Собираем и запускаем тесты
echo -e "${BLUE}Сборка и запуск тестового контейнера...${NC}"

# Передаем переменные среды
if [ -f .env.test ]; then
    set -a  # Автоматически экспортируем переменные
    source .env.test
    set +a
fi

# Получаем аргументы командной строки для передачи в тесты
TEST_ARGS="$@"

# Выполняем сборку и запуск
if $DOCKER_COMPOSE_CMD -f docker-compose.test.yml up --build --abort-on-container-exit; then
    echo -e "${GREEN}Тесты успешно выполнены!${NC}"
    
    # Проверяем наличие репортов
    if [ -d "playwright-report" ] && [ "$(ls -A playwright-report)" ]; then
        echo -e "${BLUE}Репорт по тестам доступен в ./playwright-report/${NC}"
        echo -e "${BLUE}Для просмотра HTML репорта используйте: npx playwright show-report${NC}"
    fi
    
    exit 0
else
    echo -e "${RED}Тесты завершились с ошибкой!${NC}"
    
    # Показываем логи контейнера
    echo -e "${YELLOW}Логи контейнера:${NC}"
    $DOCKER_COMPOSE_CMD -f docker-compose.test.yml logs
    
    exit 1
fi
