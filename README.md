# Executive Assistant — Форк с MCP ktalk

> **Форк оригинального executive-assistant с интеграцией Naomi Talk**

Шаблон репозитория для создания персонального AI-ассистента на базе **Claude Code + VS Code**. Этот форк добавляет интеграцию с Naomi Talk (MCP ktalk) для автоматического импорта транскриптов встреч.

Оригинал: [mdemyanov/executive-assistant](https://github.com/mdemyanov/executive-assistant)

## Возможности

Все возможности оригинала + новые:

| Возможность | Описание |
|-------------|----------|
| **Контакты и люди** | Карточки сотрудников, стейкхолдеров |
| **Встречи 1-1** | Подготовка, проведение, фиксация |
| **Проекты** | Отслеживание активных проектов |
| **Решения** | Журнал решений (ADR) |
| **Протоколы** | Обработка стенограмм |
| **База знаний** | Семантический поиск (qmd) |
| **MCP ktalk** | **НОВОЕ:** Импорт транскриптов из Naomi Talk |
| **/process-transcript** | **НОВОЕ:** Анализ встреч с извлечением задач |

## Требования

- **VS Code** с расширением Claude Code
- **Claude Code** CLI
- **Node.js 18+** (для qmd, опционально)

## Быстрый старт

```bash
git clone https://github.com/mdemyanov/executive-assistant.git my-vault
cd my-vault
code .
```

В Claude Code выполните:
```
/setup
```

## Доступные команды

| Команда | Описание |
|---------|----------|
| `/setup` | Настройка vault с ktalk |
| `/init` | Оригинальная настройка |
| `/process-transcript` | **НОВОЕ:** Обработать транскрипт из ktalk |
| `/find-person` | Поиск информации о человеке |
| `/new-1-1` | Создать протокол 1-1 |
| `/new-decision` | Фиксировать решение |
| `/new-project` | Создать проект |
| `/kb-stats` | Статистика vault |
| `/meeting-debrief` | Обработка стенограммы |

## Структура vault

Johnny Decimal как в оригинале + `ktalk/`:

```
00_CORE/          — идентичность, стратегия
10_PEOPLE/        — карточки людей
20_MEETINGS/      — встречи
  ├── ktalk/      — НОВОЕ: транскрипты Naomi Talk
  └── committees/ — комитеты
30_PROJECTS/      — проекты
40_DECISIONS/     — решения
50_KNOWLEDGE/     — база знаний
60_DOMAIN/        — доменная область
90_TEMPLATES/     — шаблоны
99_ARCHIVE/       — архив
```

## MCP ktalk

### Настройка

1. Получите API ключ: https://naumen.ai → Настройки → API ключ
2. Запустите `/setup` и выберите "Подключить Naomi Talk"
3. Вставьте токен

### Конфигурация `.mcp.json`

```json
{
  "mcpServers": {
    "ktalk": {
      "transport": {
        "type": "http",
        "url": "https://ktalk.ai-office.nau.team/mcp",
        "headers": {
          "Authorization": "Bearer <TOKEN>"
        }
      }
    }
  }
}
```

## Инструменты

### qmd (опционально)

```bash
bash scripts/install-tools.sh --qmd
```

### tg-parser (опционально)

```bash
bash scripts/install-tools.sh --tg-parser
```

## Что нового в форке

| Добавлено | Описание |
|-----------|----------|
| `20_MEETINGS/ktalk/` | Папка для транскриптов |
| `/process-transcript` | Команда обработки встреч |
| `/setup` | Расширенный `/init` с ktalk |
| Автосоздание профилей | Из участников встреч |

## Совместимость

Полная обратная совместимость с оригиналом:

| Параметр | Значение |
|----------|----------|
| **ID схема** | `{первая_буква_имени}{фамилия}` |
| **Плейсхолдеры** | `{{PLACEHOLDER}}` |
| **Структура** | Johnny Decimal |
| **Команды** | Все оригинальные сохранены |

## Лицензия

MIT (как у оригинала)
