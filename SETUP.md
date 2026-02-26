# Setup Instructions for Claude

> **Claude: When user asks to run setup or install this vault, execute the steps below.**

---

## Step 1: Greet the User

```
👋 Добро пожаловать в настройку Personal Assistant!

Я проведу вас через интервью, создам структуру vault
и настрою интеграции (MCP ktalk, QMD, skills).

Это займёт 5-10 минут.

Начинаем?
```

Wait for user confirmation.

---

## Step 2: Interview (ask ONE question at a time)

### Question 1
```
В какой компании вы работаете?
```
Save as `COMPANY_NAME`.

### Question 2
```
Как вас зовут? (Фамилия Имя)

Пример: Иванов Иван
```
Save as `OWNER_NAME`.

Generate `OWNER_ID`:
- First letter of name + surname in translit
- Lowercase

Examples: Иванов Иван → `iivanov`, Петров Сергей → `spetrov`

### Question 3
```
Какая у вас должность?
```
Save as `OWNER_ROLE`.

Determine `DOMAIN_DIR`:
- "технолог", "CTO", "IT", "разработ" → `60_DOMAIN/technology`
- "продукт", "CPO", "product" → `60_DOMAIN/product`
- "финанс", "CFO" → `60_DOMAIN/finance`
- "HR", "персонал" → `60_DOMAIN/hr`
- Else → ask user

### Question 4
```
Кто ваш непосредственный руководитель?
(Имя и должность, или "нет")
```

### Question 5
```
Перечислите ваших прямых подчинённых.
(Имя и должность на каждой строке, или "нет")
```

### Question 6
```
Есть ли другие важные контакты?
(Имя, должность — или "нет")
```

### Question 7
```
Хотите подключить Naomi Talk (ktalk)?
1. Да
2. Нет
```

Save as `USE_KTALK` (true/false).

---

## Step 3: Confirmation

Show table:

```
## Проверьте данные

| Параметр | Значение |
|----------|----------|
| Компания | {COMPANY_NAME} |
| Имя | {OWNER_NAME} |
| ID | {OWNER_ID} |
| Должность | {OWNER_ROLE} |
| Руководитель | {имя или нет} |
| Подчинённых | {N} |
| Контактов | {N} |
| MCP ktalk | {да/нет} |

Все верно? Создаю vault?
```

Wait for confirmation.

---

## Step 4: Create Directory Structure

Execute via Bash:

```bash
#!/bin/bash
set -e

echo "📁 Создаю структуру vault..."

mkdir -p 00_CORE/identity
mkdir -p 00_CORE/strategy
mkdir -p 00_CORE/stakeholders
mkdir -p 10_PEOPLE
mkdir -p 20_MEETINGS/ktalk
mkdir -p 20_MEETINGS/committees
mkdir -p 30_PROJECTS/active
mkdir -p 30_PROJECTS/archive
mkdir -p 40_DECISIONS
mkdir -p 50_KNOWLEDGE
mkdir -p 60_DOMAIN/product
mkdir -p 70_ARCHIVES
mkdir -p 80_PERSONAL
mkdir -p 90_TEMPLATES
mkdir -p 99_ARCHIVE

echo "✓ Структура создана"
```

---

## Step 5: Copy Templates

```bash
#!/bin/bash
set -e

echo "📋 Копирую шаблоны..."

cp templates/template_*.md 90_TEMPLATES/ 2>/dev/null || true
cp templates/frontmatter-guide.md 90_TEMPLATES/ 2>/dev/null || true

echo "✓ Шаблоны скопированы"
```

---

## Step 6: Create .mcp.json

Create file `.mcp.json`:

**Basic (without ktalk):**
```json
{
  "mcpServers": {}
}
```

**With ktalk (if user chose Yes):**

```json
{
  "mcpServers": {
    "ktalk": {
      "transport": {
        "type": "http",
        "url": "https://ktalk.ai-office.nau.team/mcp",
        "headers": {
          "Authorization": "Bearer <ВСТАВЬТЕ_ВАШ_API_КЛЮЧ_ТУДА>"
        }
      }
    }
  }
}
```

Then tell user:

```
📝 Файл .mcp.json создан!

Откройте его и замените <ВСТАВЬТЕ_ВАШ_API_КЛЮЧ_ТУДА> на ваш ключ.

Где взять ключ:
1. https://naomi.nau.im/
2. Профиль → Настройки → Аккаунт → API ключ
3. Скопируйте ключ

[.mcp.json](.mcp.json) ← откройте файл

Сохраните и напишите "готово" когда закончите.
```

Wait for user to confirm.

---

## Step 7: Create CLAUDE.md

Create file `CLAUDE.md`:

```markdown
# Инструкции для Claude Code

**Версия:** 1.0 | **Настроен:** {current_date}

---

## Владелец vault

| Параметр | Значение |
|----------|----------|
| **Имя** | {OWNER_NAME} |
| **ID в vault** | {OWNER_ID} |
| **Должность** | {OWNER_ROLE} |
| **Компания** | {COMPANY_NAME} |
| **Профиль** | `10_PEOPLE/{OWNER_ID}/{OWNER_ID}.md` |

Когда пользователь говорит "я", "мой", "мне" — это {OWNER_NAME} ({OWNER_ID}).

---

## Режим работы

Ты работаешь как **персональный ассистент руководителя**.

---

## Инструменты

| Инструмент | Когда использовать |
|------------|-------------------|
| **Grep** | Поиск по содержимому |
| **Glob** | Поиск файлов |
| **Read** | Чтение файлов |
| **Web Search** | Поиск информации |

---

## Доступные команды

| Команда | Описание |
|---------|----------|
| `/process-transcript` | Импорт из ktalk |
| `/new-1-1` | Создать 1-1 |
| `/new-project` | Создать проект |
| `/new-decision` | Создать решение |
| `/find-person` | Найти человека |
| `/kb-stats` | Статистика |
| `/meeting-debrief` | Постобработка встреч |
| `/correspondence-2` | Деловая переписка |
| `/meeting-prep` | Подготовка к встречам |

---

## Правила

1. **Русский язык** — рабочий язык
2. **Frontmatter обязателен**
3. **Критическое мышление**
```

---

## Step 8: Create Owner Profile

Execute BASH:

```bash
mkdir -p 10_PEOPLE/{OWNER_ID}
```

Create file `10_PEOPLE/{OWNER_ID}/{OWNER_ID}.md`:

```markdown
---
type: person
id: {OWNER_ID}
name: {OWNER_NAME}
role: {OWNER_ROLE}
company: {COMPANY_NAME}
status: active
reporting: owner
created: {YYYY-MM-DD}
tags: []
---

# {OWNER_NAME}

**Должность:** {OWNER_ROLE}
**Компания:** {COMPANY_NAME}

## Обо мне
> Заполните информацию о себе

## Контакты
- Email:
- Telegram:

## Навыки
> Основные навыки
```

---

## Step 9: Create Profiles for Other People

For each person from interview, create similar profiles.

---

## Step 10: Create 00_CORE Documents

### 00_CORE/identity/role_scope.md

```markdown
---
type: knowledge
id: role-scope
title: "Скоуп роли: {OWNER_ROLE}"
status: active
---

# Скоуп роли: {OWNER_ROLE}

**Компания:** {COMPANY_NAME}

## Зона ответственности
> Заполните

## Полномочия
> Заполните

## Ограничения
> Заполните

## Ключевые метрики
> Заполните
```

### 00_CORE/identity/constraints.md

```markdown
---
type: knowledge
id: constraints
title: "Ограничения"
status: active
---

# Ограничения и правила

## Бюджетные
-

## Организационные
-

## Технические
-
```

### 00_CORE/strategy/current_priorities.md

```markdown
---
type: knowledge
id: current-priorities
title: "Приоритеты"
status: active
date: {YYYY-MM-DD}
---

# Текущие приоритеты

## Приоритет 1
> Заполните

## Приоритет 2
> Заполните

## Приоритет 3
> Заполните
```

### 00_CORE/stakeholders/relationship_map.md

```markdown
---
type: knowledge
id: relationship-map
title: "Карта связей"
status: active
---

# Карта связей

```mermaid
graph TD
    {OWNER_ID}["{OWNER_NAME}"]
```
```

---

## Step 11: Setup QMD

```
🔍 Настраиваю QMD...
```

Check Node.js:

```bash
node --version
```

If not found:
```
⚠️ Node.js не найден. Установите с https://nodejs.org/
```

If exists:

```bash
npm install -g @tobilu/qmd
```

```bash
qmd collection add ./10_PEOPLE --name vault-people --mask "*.md"
qmd collection add ./30_PROJECTS --name vault-projects --mask "*.md"
qmd collection add ./20_MEETINGS --name vault-meetings --mask "*.md"
qmd collection add ./00_CORE --name vault-core --mask "*.md"
qmd collection add ./40_DECISIONS --name vault-decisions --mask "*.md"
qmd collection add ./50_KNOWLEDGE --name vault-knowledge --mask "*.md"
qmd collection add ./60_DOMAIN --name vault-domain --mask "*.md"
```

```bash
qmd update
qmd embed
```

---

## Step 12: Install Skills

```
📦 Устанавливаю дополнительные skills...
```

```bash
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

# meeting-debrief
tmp_dir=$(mktemp -d)
git clone --depth 1 --filter=blob:none --sparse "https://github.com/mdemyanov/ai-assistants" "$tmp_dir" 2>/dev/null
git -C "$tmp_dir" sparse-checkout set "skills/meeting-debrief" 2>/dev/null
cp -r "$tmp_dir/skills/meeting-debrief" "$SKILLS_DIR/"
rm -rf "$tmp_dir"

# correspondence-2
tmp_dir=$(mktemp -d)
git clone --depth 1 --filter=blob:none --sparse "https://github.com/mdemyanov/ai-assistants" "$tmp_dir" 2>/dev/null
git -C "$tmp_dir" sparse-checkout set "skills/correspondence-2" 2>/dev/null
cp -r "$tmp_dir/skills/correspondence-2" "$SKILLS_DIR/"
rm -rf "$tmp_dir"

# meeting-prep
tmp_dir=$(mktemp -d)
git clone --depth 1 --filter=blob:none --sparse "https://github.com/mdemyanov/ai-assistants" "$tmp_dir" 2>/dev/null
git -C "$tmp_dir" sparse-checkout set "skills/meeting-prep" 2>/dev/null
cp -r "$tmp_dir/skills/meeting-prep" "$SKILLS_DIR/"
rm -rf "$tmp_dir"

echo "✓ Skills установлены: meeting-debrief, correspondence-2, meeting-prep"
```

---

## Step 13: Final Report

```
✅ Настройка завершена!

## Создано:
📁 Структура vault
👤 Ваш профиль: 10_PEOPLE/{OWNER_ID}/{OWNER_ID}.md
🔧 CLAUDE.md, .mcp.json

## Интеграции:
🔗 MCP ktalk: {статус}
🔍 QMD: {статус}
📦 Skills: meeting-debrief, correspondence-2, meeting-prep

## Доступные команды:
/process-transcript — импорт из ktalk
/new-1-1 — 1-1 встреча
/new-project — проект
/find-person — поиск
/meeting-debrief — постобработка встреч
/correspondence-2 — деловая переписка
/meeting-prep — подготовка к встречам

## Следующие шаги:
1. Заполните 00_CORE/identity/role_scope.md
2. Заполните 00_CORE/strategy/current_priorities.md
3. Попробуйте: /process-transcript
```

---

## End of Setup
