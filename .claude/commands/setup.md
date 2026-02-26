---
description: "Первичная настройка персонального ассистента. Проводит интервью, создаёт структуру vault, генерирует профили и конфигурации. Совместим с executive-assistant."
---

# Первичная настройка ассистента (с MCP ktalk)

Эта команда расширяет оригинальный `/init` из executive-assistant, добавляя интеграцию с Naomi Talk (MCP ktalk).

## Предварительная проверка

Проверь, есть ли файл `CLAUDE.md` в корне проекта. Если да — vault уже инициализирован. Спроси: "Vault уже настроен. Хочешь добавить MCP ktalk или перенастроить?"

Если `CLAUDE.md` нет — запусти полную настройку.

---

## Полная настройка (без CLAUDE.md)

Следуй алгоритму из оригинального `/init` с дополнениями для ktalk:

### Фаза 1 — Интервью (как в /init)

Проведи интервью по схеме executive-assistant:

1. **Компания** → `COMPANY_NAME`
2. **Имя** → `OWNER_NAME`, `OWNER_ID` (первая буква имени + фамилия транслитом)
3. **Должность** → `OWNER_ROLE`, определи `DOMAIN_DIR`
4. **Руководитель** → имя, должность (если есть)
5. **Подчинённые** → список с ролями
6. **Ключевые контакты** → список

### Фаза 2 — Подтверждение (как в /init)

Покажи сводную таблицу и дождись подтверждения.

### Фаза 3 — Создание структуры (как в /init)

Выполни команды из `scripts/setup.sh` или создай папки вручную:

```bash
mkdir -p 00_CORE/identity 00_CORE/strategy 00_CORE/stakeholders
mkdir -p 10_PEOPLE 20_MEETINGS/ktalk 20_MEETINGS/committees
mkdir -p 30_PROJECTS/active 30_PROJECTS/archive
mkdir -p 40_DECISIONS 50_KNOWLEDGE 60_DOMAIN/{{DOMAIN_DIR}}
mkdir -p 70_ARCHIVES 80_PERSONAL 90_TEMPLATES 99_ARCHIVE
mkdir -p .claude/commands .claude/docs
```

Скопируй шаблоны:
```bash
cp templates/template_*.md 90_TEMPLATES/
cp templates/frontmatter-guide.md 90_TEMPLATES/
```

### Фаза 4 — Генерация конфигов (как в /init)

Замени плейсхолдеры в `presets/base/*.template`:

| Плейсхолдер | Значение |
|-------------|----------|
| `{{OWNER_NAME}}` | Из интервью |
| `{{OWNER_ID}}` | Сгенерированный (буква+фамилия) |
| `{{OWNER_ROLE}}` | Из интервью |
| `{{COMPANY_NAME}}` | Из интервью |
| `{{VAULT_NAME}}` | `{COMPANY_NAME}_{ROLE}` транслит snake_case |
| `{{VAULT_PATH}}` | Текущая директория |
| `{{DOMAIN_DIR}}` | Определённый домен |
| `{{DATE}}` | DD.MM.YYYY |
| `{{YEAR}}` | Текущий год |

Запиши:
- `CLAUDE.md`
- `AGENTS.md`
- `Dashboard.md`
- `.claude/docs/vault-config.md`
- `.claude/settings.local.json`
- `.mcp.json` (с ktalk!)

### Фаза 5 — Создание профилей (как в /init)

Создай профили для:
- Владельца (`10_PEOPLE/{{OWNER_ID}}/{{OWNER_ID}}.md`)
- Руководителя (если есть)
- Подчинённых
- Контактов

### Фаза 6 — Настройка MCP ktalk (НОВОЕ!)

Спроси: "Хочешь подключить Naomi Talk для автоматического импорта транскриптов встреч?"

Если да:
1. Запроси API токен ktalk
2. Обнови `.mcp.json`:

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

**Где получить токен:**
1. https://naumen.ai
2. Настройки → API ключ
3. Скопировать

### Фаза 7 — Создание 00_CORE документов (как в /init)

- `00_CORE/identity/role_scope.md`
- `00_CORE/identity/constraints.md`
- `00_CORE/strategy/current_priorities.md`
- `00_CORE/stakeholders/relationship_map.md`

### Фаза 8 — Инструменты (как в /init)

Предложи qmd для семантического поиска.

---

## Добавление ktalk к существующему vault (с CLAUDE.md)

Если vault уже настроен, только добавь MCP ktalk:

1. Запроси API токен
2. Обнови `.mcp.json` (см. выше)
3. Создай папку `20_MEETINGS/ktalk/`
4. Обнови `CLAUDE.md` — добавь в команды `/process-transcript`

---

## Финальный отчёт

```
## Настройка завершена!

### Создано
- {N} папок в структуре vault
- {N} профилей людей
- {N} шаблонов в 90_TEMPLATES/
- CLAUDE.md, AGENTS.md, Dashboard.md
- MCP ktalk интеграция

### Настроено
- Команды: /new-1-1, /new-decision, /find-person, /kb-stats, /meeting-debrief, /new-project
- НОВОЕ: /process-transcript — обработка транскриптов ktalk
- MCP: qmd (опционально), ktalk

### Следующие шаги
1. Заполни `00_CORE/identity/role_scope.md`
2. Заполни `00_CORE/strategy/current_priorities.md`
3. Попробуй: `/process-transcript` — импортируй встречу из ktalk
```

---

## Совместимость с executive-assistant

| Параметр | Значение |
|----------|----------|
| ID схема | `{первая_буква_имени}{фамилия}` как в оригинале |
| Плейсхолдеры | `{{PLACEHOLDER}}` как в оригинале |
| Структура | Johnny Decimal как в оригинале |
| Команды | Все оригинальные + `/process-transcript` |
| Редактор | VS Code или Obsidian (оба работают) |
