# Удаление dotenv и dotenv-cli

## ✅ Что было изменено

### Удаленные зависимости:
- ❌ `dotenv: 17.2.1` (dependencies)
- ❌ `dotenv-cli: 10.0.0` (devDependencies)

### Обновленные npm скрипты:
Вместо `npx dotenv-cli -e .env.X --` теперь используется `export $(grep -v '^#' .env.X | xargs) &&`

**Было:**
```json
"dev:local": "npx dotenv-cli -e .env.development -- npm run dev",
"start:prod": "npx dotenv-cli -e .env.production -- npm run start"
```

**Стало:**
```json
"dev:local": "export $(grep -v '^#' .env.development | xargs) && npm run dev",
"start:prod": "export $(grep -v '^#' .env.production | xargs) && npm run start"
```

### Обновленные shell-скрипты:

#### `dev.sh`
- Удалена логика детекции `dotenv-cli`
- Добавлена функция `load_env()` для загрузки переменных из .env файлов
- Упрощена логика запуска серверов

#### `scripts/*.sh`
- `build-clean.sh` - переписан без использования dotenv-cli
- `dev-start.sh` - загружает .env.development напрямую
- `start-clean.sh` - добавлена функция load_env
- `start-server.sh` - загружает переменные без dotenv-cli
- `simple-start.sh` - упрощен, убран dotenv-cli

#### Тестовые скрипты:
- `test-local.sh` - заменены вызовы dotenv-cli
- `test-shutdown.sh` - обновлены примеры команд

## 🚀 Как использовать

### Запуск development сервера:
```bash
# Способ 1: через npm скрипт (рекомендуется)
npm run dev:local

# Способ 2: через dev.sh
./dev.sh start development

# Способ 3: вручную
export $(grep -v '^#' .env.development | xargs) && npm run dev
```

### Запуск production сервера:
```bash
# Способ 1: через npm скрипт
npm run start:prod  # загружает .env.production

# Способ 2: через dev.sh
./dev.sh start production

# Способ 3: вручную
export $(grep -v '^#' .env.production | xargs) && npm run start
```

### Запуск тестов:
```bash
# С автоматической загрузкой .env.test
npm run test

# Или через dev.sh
./dev.sh test
```

### Docker использование:
В Docker переменные окружения задаются через docker-compose.yml или Dockerfile,
поэтому удаление dotenv-cli делает проект более Docker-friendly:

```yaml
# docker-compose.yml
environment:
  - NODE_ENV=production
  - PORT=3001
  - PUBLIC_SALEOR_API_URL=https://api.example.com
```

## ✨ Преимущества

1. **Убрали зависимости** - проект стал легче на 2 пакета
2. **Стандартный подход** - используем shell переменные напрямую
3. **Меньше абстракций** - прозрачнее что происходит
4. **Docker-friendly** - env vars через docker-compose работают естественно
5. **Совместимость с CI/CD** - переменные можно задавать в pipeline

## 🔧 Функция загрузки переменных

Во всех shell-скриптах используется единообразная функция:
```bash
load_env() {
    local env_file="$1"
    if [ -f "$env_file" ]; then
        export $(grep -v '^#' "$env_file" | xargs)
        echo "🔧 Environment loaded from $env_file"
    else
        echo "⚠️  Warning: Environment file $env_file not found"
    fi
}
```

Эта функция:
- Проверяет существование файла
- Игнорирует комментарии (строки начинающиеся с #)
- Экспортирует все переменные в текущую shell сессию
- Выводит информативные сообщения

## 📝 Файлы окружения

Проект продолжает использовать те же файлы:
- `.env.development` - для разработки (PORT=3000)
- `.env.production` - для продакшена (PORT=3001) 
- `.env.test` - для тестов (PORT=3002)
- `.env.example` - пример конфигурации

## 🐛 Устранение неполадок

### "No matching export in src/gql/index.ts"

**Проблема:** Vite не может найти GraphQL типы в src/gql/index.ts

**Решение:**
1. Убедитесь, что переменная `PUBLIC_SALEOR_API_URL` задана:
   ```bash
   export $(grep -v '^#' .env.development | xargs)
   echo $PUBLIC_SALEOR_API_URL
   ```

2. Запустите генерацию GraphQL типов:
   ```bash
   # После установки зависимостей
   pnpm install
   pnpm run generate
   ```

3. Если проблема сохраняется, проверьте что файл `src/gql/index.ts` содержит нужные экспорты.

**Временное решение:** Файл `src/gql/index.ts` содержит placeholder-экспорты, которые предотвращают ошибки импорта до генерации настоящих типов.

### "PUBLIC_SALEOR_API_URL not set" во время pnpm install

Эта проблема исправлена в последних версиях - скрипты автоматически загружают переменные из `.env.development` и `.env`.

Если проблема сохраняется:
```bash
export $(grep -v '^#' .env.development | xargs)
pnpm install
```
