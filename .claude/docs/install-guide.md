# Руководство по установке

> **Personal Assistant — Интерактивная настройка за 5-10 минут**

---

## Требования

| Компонент | Версия | Для чего |
|-----------|--------|----------|
| **VS Code** | Последняя | Рабочая среда |
| **Claude Code** | Последняя | MCP + команды |
| **Node.js 18+** | — | QMD (опционально) |

### Windows-специфичные требования (для QMD)

| Компонент | Для чего | Автоустановка |
|-----------|----------|---------------|
| **Visual Studio Build Tools** | Компиляция нативных модулей | Да (winget) |
| **Python 3.x** | node-gyp | Да (winget) |

При `/install-vault` на Windows автоматически проверяются и устанавливаются недостающие компоненты через winget с запросом прав администратора.

---

## Быстрый старт

### Вариант 1: Новый vault

```bash
git clone https://github.com/vonavikon/Personal-Assistant-Test.git my-vault
cd my-vault
code .
```

В Claude Code:
```
/init
```

### Вариант 2: Существующий vault

Если vault уже настроен:
```
/init
```

Выберите "Добавить MCP ktalk" или "Добавить QMD".

---

## Что делает /init

| Шаг | Описание |
|-----|----------|
| 1 | Приветствие |
| 2 | Интервью (7 вопросов) |
| 3 | Подтверждение данных |
| 4 | Создание структуры vault |
| 5 | Генерация конфигов |
| 6 | Создание профилей |
| 7 | Настройка MCP ktalk |
| 8 | Настройка QMD |
| 9 | Финальный отчёт |

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

## Настройка QMD

Автоматически настраивается при `/init`.

Ручная настройка:
```bash
npm install -g @tobilu/qmd
```

---

## Доступные команды

| Команда | Описание |
|---------|----------|
| `/init` | Настройка vault |
| `/process-transcript` | Обработать транскрипт из ktalk |
| `/find-person` | Поиск человека |
| `/new-1-1` | Создать 1-1 встречу |
| `/new-decision` | Создать решение |
| `/new-project` | Создать проект |
| `/kb-stats` | Статистика vault |

---

## Структура vault

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

---

## Схема ID

```
ID = {первая_буква_имени}{фамилия_транслит}
```

Примеры:
- Демьянов Максим → `mdemyanov`
- Иванов Константин → `kivanov`
- Зыков Петр → `pzykov`

---

## Примеры использования

### Импорт встречи

```
/process-transcript
```

### Создание проекта

```
/new-project
```

### Поиск человека

```
/find-person ivanov
```

---

## Troubleshooting

### Проблема: QMD не устанавливается на Windows (gyp ERR!)

**Причина:** Отсутствуют Visual Studio Build Tools или Python.

**Решение:**
1. Запустите `/install-vault` — автоматически установит зависимости
2. Если не сработало — установите вручную:
   - [Visual Studio Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) (workload: Desktop development with C++)
   - [Python 3.12](https://www.python.org/downloads/) (отметьте "Add Python to PATH")
3. Перезапустите VS Code
4. Выполните: `npm install -g @tobilu/qmd`

### Проблема: ktalk не подключается

**Решение:**
1. Проверьте токен в `.mcp.json`
2. URL: `https://ktalk.ai-office.nau.team/mcp`
3. Перезагрузите Claude Code

### Проблема: QMD не находит файлы

**Решение:**
```bash
qmd collection list
qmd update
qmd embed
```

### Проблема: Команда не работает

**Решение:**
1. Проверьте `.claude/commands/`
2. Перезагрузите Claude Code

---

## Проверка установки

```bash
# Структура
ls -la 20_MEETINGS/ktalk/

# MCP
cat .mcp.json

# Профиль
cat 10_PEOPLE/{your_id}/{your_id}.md

# QMD
qmd collection list
```

---

## Поддержка

telegram: @vonavikon

---

## Лицензия

MIT
