# Executive Assistant — Персональный AI-ассистент

> **Template repository для создания персонального AI-ассистента**

Шаблон репозитория для создания персонального AI-ассистента на базе **Claude Code + VS Code**. Позволяет организовать рабочее пространство: управление контактами, встречами 1-1, проектами, решениями, протоколами, а также вести базу знаний с семантическим поиском.

## Возможности

| Возможность | Описание |
|-------------|----------|
| **Контакты и люди** | Карточки сотрудников, стейкхолдеров |
| **Встречи 1-1** | Подготовка, проведение, фиксация |
| **Проекты** | Отслеживание активных проектов |
| **Решения** | Журнал решений (ADR) |
| **Протоколы** | Обработка стенограмм |
| **База знаний** | Семантический поиск (QMD) |
| **MCP ktalk** | Автоматический импорт из Naomi Talk |
| **/process-transcript** | Анализ встреч с извлечением задач |

## Требования

- **VS Code** с расширением Claude Code
- **Claude Code** CLI
- **Node.js 18+** (для QMD)

## Быстрый старт

```bash
git clone https://github.com/vonavikon/Personal-Assistant-Test.git my-vault
cd my-vault
code .
```

В Claude Code выполните:
```
/init
```

## Доступные команды

| Команда | Описание |
|---------|----------|
| `/init` | Настройка vault с ktalk и QMD |
| `/process-transcript` | Обработать транскрипт из ktalk |
| `/find-person` | Поиск информации о человеке |
| `/new-1-1` | Создать протокол 1-1 |
| `/new-decision` | Фиксировать решение |
| `/new-project` | Создать проект |
| `/kb-stats` | Статистика vault |
| `/meeting-debrief` | Обработка стенограммы |

## Структура vault

Johnny Decimal:

```
00_CORE/          — идентичность, стратегия
10_PEOPLE/        — карточки людей
20_MEETINGS/      — встречи
  ├── ktalk/      — транскрипты Naomi Talk
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

1. Получите API ключ: https://naomi.nau.im/ → Профиль → Настройки → API ключ
2. Запустите `/init` и выберите "Подключить Naomi Talk"
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

## QMD — Семантический поиск

Автоматически настраивается при `/init`.

```bash
npm install -g @tobilu/qmd
```

## Лицензия

MIT

## Поддержка

telegram: @vonavikon
