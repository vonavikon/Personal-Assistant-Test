# Руководство по установке - Форк executive-assistant с MCP ktalk

> **Расширение оригинального executive-assistant**
>
> Этот форк добавляет интеграцию с Naomi Talk (MCP ktalk) для автоматического импорта транскриптов встреч.

---

## Что нового

| Возможность | Описание |
|-------------|----------|
| **MCP ktalk** | Автоматический импорт транскриптов из Naomi Talk |
| **/process-transcript** | Анализ встреч с извлечением решений и задач |
| **/setup** | Расширенный `/init` с настройкой ktalk |

Полная обратная совместимость с оригинальным [executive-assistant](https://github.com/mdemyanov/executive-assistant).

---

## Требования

| Компонент | Версия | Для чего |
|-----------|--------|----------|
| **VS Code** | Последняя | Рабочая среда |
| **Claude Code** | Последняя | MCP + команды |
| **Node.js 18+** | — | qmd (опционально) |

### Опционально

| Компонент | Для чего |
|-----------|----------|
| **qmd** | Семантический поиск |
| **Obsidian** | Альтернативный UI |

---

## Быстрый старт

### Вариант 1: Новый vault

```bash
# Клонируйте этот форк
git clone https://github.com/mdemyanov/executive-assistant.git my-vault
cd my-vault

# Откройте в VS Code
code .

# Запустите настройку в Claude Code
/setup
```

### Вариант 2: Существующий vault

Если у вас уже настроенный executive-assistant:

```
/setup
```

Выберите "Добавить MCP ktalk".

---

## Настройка MCP ktalk

### Получение API ключа

1. Откройте: https://naomi.nau.im/
2. Профиль → Настройки → Аккаунт → API ключ
3. Скопируйте ключ

### Конфигурация `.mcp.json`

```json
{
  "mcpServers": {
    "ktalk": {
      "transport": {
        "type": "http",
        "url": "https://ktalk.ai-office.nau.team/mcp",
        "headers": {
          "Authorization": "Bearer <ВАШ_ТОКЕН>"
        }
      }
    }
  }
}
```

---

## Доступные команды

Все команды оригинального executive-assistant + новые:

| Команда | Описание |
|---------|----------|
| `/setup` | Настройка vault с ktalk |
| `/init` | Оригинальная настройка (без ktalk) |
| `/process-transcript` | **НОВОЕ:** Обработать транскрипт из ktalk |
| `/find-person` | Поиск человека |
| `/new-1-1` | Создать 1-1 встречу |
| `/new-decision` | Создать решение |
| `/new-project` | Создать проект |
| `/kb-stats` | Статистика vault |
| `/meeting-debrief` | Обработать стенограмму |

---

## Структура vault

Johnny Decimal как в оригинале + папка для ktalk:

```
00_CORE/          — идентичность, стратегия
10_PEOPLE/        — профили людей
20_MEETINGS/      — встречи
  ├── ktalk/      — НОВОЕ: транскрипты из Naomi Talk
  └── committees/ — комитеты
30_PROJECTS/      — проекты
40_DECISIONS/     — решения
50_KNOWLEDGE/     — база знаний
60_DOMAIN/        — доменная область
90_TEMPLATES/     — шаблоны
99_ARCHIVE/       — архив
```

---

## Схема ID

Используется та же схема, что и в оригинале:

```
ID = {первая_буква_имени}{фамилия_транслит}
```

Примеры:
- Демьянов Максим → `mdemyanov`
- Иванов Константин → `kivanov`
- Зыков Петр → `pzykov`

---

## Примеры использования

### Импорт встречи из ktalk

```
/process-transcript
```

Ассистент покажет список записей, выберите нужную.

### Создание проекта из задачи встречи

```
/new-project
```

### Поиск человека

```
/find-person ivanov
```

---

## Troubleshooting

### Проблема: ktalk не подключается

**Проверьте:**
1. Токен в `.mcp.json` действительный
2. URL корректный: `https://ktalk.ai-office.nau.team/mcp`
3. Есть доступ к Naomi

### Проблема: Команда не найдена

**Решение:**
1. Проверьте `.claude/commands/setup.md`
2. Перезагрузите Claude Code

### Проблема: Профиль не создаётся

**Решение:**
Проверьте шаблон `90_TEMPLATES/template_person.md`

---

## Проверка установки

```bash
# Структура
ls -la 20_MEETINGS/ktalk/

# MCP конфиг
cat .mcp.json

# Профиль владельца
cat 10_PEOPLE/{your_id}/{your_id}.md
```

---

## Следующие шаги

1. **Заполните профиль** в `00_CORE/identity/role_scope.md`
2. **Импортируйте встречи:** `/process-transcript`
3. **Попробуйте команды:** `/find-person`, `/new-project`

---

## Совместимость

| Параметр | Значение |
|----------|----------|
| **Оригинал** | executive-assistant |
| **Форк** | добавляет ktalk |
| **ID схема** | идентичная |
| **Структура** | идентичная + `20_MEETINGS/ktalk/` |
| **Команды** | все оригинальные + `/process-transcript` |
| **Редактор** | VS Code (Obsidian опционально) |

---

## Поддержка

telegram: @vonavikon

---

## Лицензия

MIT