# ⚠️  DEPRECATED - DOTENV REMOVED

> **Важно:** Этот документ устарел!
>
> `dotenv-cli` был удален из проекта. Проблемы с Ctrl+C больше не актуальны.
>
> См. [DOTENV_REMOVAL.md](./DOTENV_REMOVAL.md) для современной информации.

---

# Исправление проблемы с Ctrl+C (ELIFECYCLE Command failed)

## Проблема
При нажатии Ctrl+C для остановки dev сервера:
1. Появляется `ELIFECYCLE Command failed`
2. Нужно нажимать Ctrl+C дважды
3. Терминал "зависает" и не возвращается к приглашению

## Несколько вариантов решения

### 🥇 Вариант 1: Прямой вызов (рекомендуется)
```bash
# Новые команды без промежуточных npm слоев:
npm run serve:dev    # Development - прямой вызов vite dev
npm run serve:prod   # Production - Node.js сервер (adapter-node)  
npm run serve:test   # Test - Node.js сервер (adapter-node)
```
**Преимущества:** Минимум промежуточных процессов, чистое завершение

### 🥈 Вариант 2: Обновленный dev.sh с clean scripts
```bash
./dev.sh start development  # Использует scripts/start-clean.sh
./dev.sh start production   # Использует scripts/start-clean.sh
./dev.sh start test         # Использует scripts/start-clean.sh
```
**Преимущества:** Сохраняет привычный интерфейс dev.sh

### 🥉 Вариант 3: Ultra-clean wrapper
```bash
./scripts/clean-start.sh npm run dev              # С полным управлением терминалом
./scripts/clean-start.sh vite dev --port 3000     # Прямой запуск
```
**Преимущества:** Максимальный контроль над процессом и терминалом

### 🛠️ Вариант 4: Глобальное подавление ошибок npm
Добавлен `.npmrc` с настройками:
```
loglevel=error
quiet=true
progress=false
```
**Преимущества:** Исправляет проблему для всех npm команд

## Тестирование

### Быстрый тест
```bash
./test-shutdown.sh  # Покажет все доступные варианты
```

### Ручное тестирование
1. **Тест прямого вызова:**
   ```bash
   npm run serve:dev
   # Нажмите Ctrl+C - должно завершиться чисто
   ```

2. **Тест через dev.sh:**
   ```bash
   ./dev.sh start development
   # Нажмите Ctrl+C - должно завершиться чисто
   ```

3. **Тест ultra-clean:**
   ```bash
   ./scripts/clean-start.sh npm run dev
   # Нажмите Ctrl+C - должно завершиться чисто
   ```

## Какой вариант выбрать?

### Если вы используете dev.sh
→ **Никаких изменений!** Просто используйте как раньше:
```bash
./dev.sh start production  # Теперь использует clean scripts
```

### Если вы запускаете напрямую через npm
→ **Используйте новые serve: команды:**
```bash
npm run serve:prod  # Вместо npm run start:prod
npm run serve:dev   # Вместо npm run start:dev
```

### Если ничего не помогает
→ **Ultra-clean wrapper:**
```bash
./scripts/clean-start.sh <ваша-команда>
```

## Что изменилось технически

### 1. Убраны промежуточные npm слои
**Было:** `npm` → `dotenv-cli` → `npm run start` → `vite preview`  
**Стало:** `dotenv-cli` → `vite preview`

### 2. Добавлен exec для замены процесса
```bash
exec npx dotenv-cli -e .env.production -- vite preview --port 3001
```
`exec` заменяет shell процесс, убирая промежуточные слои.

### 3. Правильная обработка сигналов
```bash
trap cleanup INT TERM EXIT
```
Теперь SIGINT (Ctrl+C) обрабатывается корректно.

### 4. Подавление npm ошибок
```bash
export npm_config_loglevel=error
export npm_config_quiet=true
```

## Диагностика проблем

### Если все еще два Ctrl+C
```bash
# Проверьте зомби-процессы:
ps aux | grep -E "(vite|npm|node)" | grep defunct

# Убейте их:
pkill -f vite
pkill -f npm
```

### Если команды не работают
```bash
# Проверьте права на выполнение:
ls -la scripts/*.sh

# Если нет прав:
chmod +x scripts/*.sh
```

### Если терминал все еще "висит"
```bash
# В другом терминале:
pkill -f "(vite|node)"

# Или восстановите терминал:
reset
```

## Откат к старому поведению

Если нужно временно вернуться к старому поведению:

1. **Переименуйте .npmrc:**
   ```bash
   mv .npmrc .npmrc.backup
   ```

2. **Используйте старые команды:**
   ```bash
   npm run start:prod  # Старый способ
   npm run dev         # Старый способ
   ```

## Совместимость

- ✅ **Windows/Linux/macOS:** Все скрипты кроссплатформенные
- ✅ **npm/pnpm/yarn:** Работает с любым пакетным менеджером
- ✅ **Docker:** Правильно обрабатывает сигналы в контейнерах
- ✅ **CI/CD:** Не ломает автоматические сборки
- ✅ **Существующие скрипты:** dev.sh работает как раньше

---

**Итог:** Теперь у вас есть 4 разных способа решения проблемы. Начните с `npm run serve:dev` или просто продолжайте использовать `./dev.sh start production` как раньше!
