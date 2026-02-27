---
description: "Первичная настройка персонального ассистента. Проводит интервью, создаёт структуру vault, генерирует профили, настраивает MCP ktalk, QMD и skills."
---

# Первичная настройка ассистента

> **НЕ ВЫПОЛНЯЙТЕ ЭТУ КОМАНДУ БЕЗ ЗАПРОСА ПОЛЬЗОВАТЕЛЯ**
>
> Эта команда запускается ТОЛЬКО когда пользователь вводит `/install-vault`

---

## Шаг 1: Приветствие

```
👋 Добро пожаловать в настройку Personal Assistant!

Я проведу вас через интервью, создам структуру vault
и настрою интеграции (MCP ktalk, QMD, skills).

Это займёт 5-10 минут.

Начинаем?
```

Ждите ответа пользователя.

---

## Шаг 2: Интервью (задавайте ПО ОДНОМУ вопросу)

### Вопрос 1
```
В какой компании вы работаете?
```
Сохраните как `COMPANY_NAME`.

### Вопрос 2
```
Как вас зовут? (Фамилия Имя)

Пример: Иванов Иван
```
Сохраните как `OWNER_NAME`.

Сгенерируйте `OWNER_ID`:
- Первая буква имени + фамилия транслитом
- Нижний регистр

Примеры: Иванов Иван → `iivanov`, Петров Сергей → `spetrov`

### Вопрос 3
```
Какая у вас должность?
```
Сохраните как `OWNER_ROLE`.

Определите `DOMAIN_DIR`:
- "технолог", "CTO", "IT", "разработ" → `60_DOMAIN/technology`
- "продукт", "CPO", "product" → `60_DOMAIN/product`
- "финанс", "CFO" → `60_DOMAIN/finance`
- "HR", "персонал" → `60_DOMAIN/hr`
- Иначе → спросите домен

### Вопрос 4
```
Кто ваш непосредственный руководитель?
(Имя и должность, или "нет")
```

### Вопрос 5
```
Перечислите ваших прямых подчинённых.
(Имя и должность на каждой строке, или "нет")
```

### Вопрос 6
```
Есть ли другие важные контакты?
(Имя, должность — или "нет")
```

### Вопрос 7
```
Хотите подключить Naomi Talk (ktalk)?
1. Да
2. Нет
```

Сохраните выбор как `USE_KTALK` (true/false).

---

## Шаг 3: Подтверждение

Покажите таблицу:

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

---

## Шаг 4: Создание структуры ВЫПОЛНИТЬ BASH

Выполните через Bash tool:

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

echo "✓ Струкура создана"
```

---

## Шаг 5: Копирование шаблонов ВЫПОЛНИТЬ BASH

```bash
#!/bin/bash
set -e

echo "📋 Копирую шаблоны..."

cp templates/template_*.md 90_TEMPLATES/ 2>/dev/null || true
cp templates/frontmatter-guide.md 90_TEMPLATES/ 2>/dev/null || true

echo "✓ Шаблоны скопированы"
```

### Создание словаря терминов

Создайте файл `50_KNOWLEDGE/glossary.md`:

```markdown
---
type: knowledge
id: glossary
title: "Словарь терминов"
status: active
tags:
  - glossary
  - reference
---

# Словарь терминов

Термины и сокращения, встречающиеся в работе.

| Термин | Расшифровка | Контекст | Добавлен |
|--------|-------------|----------|----------|
| | | | |

---

## Как добавлять термины

При обработке встреч ассистент автоматически предлагает добавить неизвестные термины в этот словарь.
```

---

## Шаг 6: Создание .mcp.json

Создайте файл `.mcp.json`:

**Базовый (без ktalk):**
```json
{
  "mcpServers": {}
}
```

**С ktalk (если пользователь выбрал Да):**

Создайте файл с плейсхолдером:

```json
{
  "mcpServers": {
    "ktalk": {
      "type": "http",
      "url": "https://ktalk.ai-office.nau.team/mcp",
      "headers": {
        "Authorization": "Bearer <ВАШ КЛЮЧ ИЗ NAOMI>"
      }
    }
  }
}
```

Затем скажите пользователю:

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

---

## Шаг 7: Создание CLAUDE.md

Создайте файл `CLAUDE.md`:

```markdown
# Инструкции для Claude Code

**Версия:** 1.0 | **Настроен:** {текущая дата}

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
| `/install-vault` | Первичная настройка |
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

## Шаг 8: Создание профиля владельца

Выполните BASH:

```bash
mkdir -p 10_PEOPLE/{OWNER_ID}
```

Создайте файл `10_PEOPLE/{OWNER_ID}/{OWNER_ID}.md`:

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

## Шаг 9: Создание профилей других людей

Для каждого человека из интервью создайте аналогичные профили.

---

## Шаг 10: Создание 00_CORE документов

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

\`\`\`mermaid
graph TD
    OWNER_ID["{OWNER_NAME}"]
\`\`\`
```

---

## Шаг 10.5: Проверка зависимостей для QMD (Windows)

> **Примечание:** Этот шаг только для Windows. На Mac/Linux пропустите его.

```
🔍 Проверяю зависимости для QMD...
```

Выполните проверку зависимостей:

```bash
powershell.exe -Command '
$missing = @()

# Проверка Node.js
try {
    $nodeVersion = node --version 2>$null
    Write-Host "[OK] Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "[ОТСУТСТВУЕТ] Node.js" -ForegroundColor Red
    $missing += "nodejs"
}

# Проверка Python
try {
    $pythonVersion = python --version 2>$null
    Write-Host "[OK] Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "[ОТСУТСТВУЕТ] Python" -ForegroundColor Red
    $missing += "python"
}

# Проверка VS Build Tools
$vsWhere = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
$buildTools = $false
if (Test-Path $vsWhere) {
    $buildTools = & $vsWhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>$null
}
if ($buildTools) {
    Write-Host "[OK] VS Build Tools установлены" -ForegroundColor Green
} else {
    Write-Host "[ОТСУТСТВУЕТ] VS Build Tools" -ForegroundColor Red
    $missing += "vsbuildtools"
}

# Установка отсутствующих компонентов
if ($missing.Count -gt 0) {
    Write-Host ""
    Write-Host "Обнаружены отсутствующие зависимости. Устанавливаю..." -ForegroundColor Yellow
    Write-Host ""

    $wingetAvailable = Get-Command winget -ErrorAction SilentlyContinue

    if ($wingetAvailable) {
        Write-Host "Использую winget для установки. Может потребоваться подтверждение UAC." -ForegroundColor Yellow
        Write-Host ""

        if ($missing -contains "nodejs") {
            Write-Host "Установка Node.js LTS..." -ForegroundColor Cyan
            $result = winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Ошибка установки Node.js: $result" -ForegroundColor Red
            }
        }

        if ($missing -contains "python") {
            Write-Host "Установка Python 3.12..." -ForegroundColor Cyan
            $result = winget install Python.Python.3.12 --accept-source-agreements --accept-package-agreements 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Ошибка установки Python: $result" -ForegroundColor Red
            }
        }

        if ($missing -contains "vsbuildtools") {
            Write-Host "Установка VS Build Tools..." -ForegroundColor Cyan
            Write-Host "ВАЖНО: В установщике выберите `"Разработка классических приложений на C++`"" -ForegroundColor Yellow
            $result = winget install Microsoft.VisualStudio.2022.BuildTools --override "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" --accept-source-agreements 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Ошибка установки VS Build Tools: $result" -ForegroundColor Red
            }
        }

        Write-Host ""
        Write-Host "Установка завершена. Перезапустите терминал и выполните /install-vault снова." -ForegroundColor Green
    } else {
        Write-Host "winget недоступен. Установите вручную:" -ForegroundColor Red
        Write-Host ""
        Write-Host "1. Node.js: https://nodejs.org/ (LTS версия)" -ForegroundColor White
        Write-Host "2. Python: https://www.python.org/downloads/ (3.12+)" -ForegroundColor White
        Write-Host "3. VS Build Tools: https://visualstudio.microsoft.com/visual-cpp-build-tools/" -ForegroundColor White
        Write-Host "   (выберите `"Разработка классических приложений на C++`")" -ForegroundColor Gray
        Write-Host ""
        Write-Host "После установки перезапустите терминал и выполните /install-vault снова." -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "Все зависимости установлены. Продолжаю настройку..." -ForegroundColor Green
}
'
```

Если зависимости были установлены, попросите пользователя перезапустить терминал и выполнить `/install-vault` снова.

---

## Шаг 11: Установка QMD

```
📦 Устанавливаю QMD...
```

Выполните через Bash tool:

```bash
# Проверка Node.js
if ! command -v node &>/dev/null; then
    echo "Node.js не установлен"
    echo "На Windows: зависимости должны были установиться на предыдущем шаге"
    echo "На Mac/Linux: установите Node.js 18+ с https://nodejs.org"
    exit 1
fi

# Установка QMD
if command -v qmd &>/dev/null; then
    echo "QMD уже установлен ($(qmd --version 2>/dev/null || echo 'unknown'))"
else
    npm install -g @tobilu/qmd
    if command -v qmd &>/dev/null; then
        echo "QMD установлен успешно"
    else
        echo "Ошибка установки QMD"
        exit 1
    fi
fi
```

Если установка прошла успешно:

```bash
qmd collection add ./10_PEOPLE --name vault-people --mask "*.md" 2>/dev/null || true
qmd collection add ./30_PROJECTS --name vault-projects --mask "*.md" 2>/dev/null || true
qmd collection add ./20_MEETINGS --name vault-meetings --mask "*.md" 2>/dev/null || true
qmd collection add ./00_CORE --name vault-core --mask "*.md" 2>/dev/null || true
qmd collection add ./40_DECISIONS --name vault-decisions --mask "*.md" 2>/dev/null || true
qmd collection add ./50_KNOWLEDGE --name vault-knowledge --mask "*.md" 2>/dev/null || true
qmd collection add ./60_DOMAIN --name vault-domain --mask "*.md" 2>/dev/null || true

qmd update 2>/dev/null || true
qmd embed 2>/dev/null || true
```

Если QMD не установился:
```
⚠️ QMD не установлен. Можно установить позже командой:
   npm install -g @tobilu/qmd
```

---

## Шаг 12: Установка Skills ВЫПОЛНИТЬ BASH

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

## Шаг 13: Финальный отчёт

```
✅ Настройка завершена!

## Создано:
📁 Структура vault
👤 Ваш профиль: 10_PEOPLE/{OWNER_ID}/{OWNER_ID}.md
🔧 CLAUDE.md, .mcp.json

## Интеграции:
🔗 MCP ktalk: {статус}
🔍 QMD: {статус}
   • Если "✓ установлен" — готов к использованию
   • Если "⚠️ требует настройки" — выполните `/install-vault` после установки Node.js
📦 Skills: meeting-debrief, correspondence-2, meeting-prep

## Доступные команды:
/install-vault — настройка
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
