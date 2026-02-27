# QMD Windows Dependencies Installation — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Добавить автоматическую проверку и установку зависимостей QMD (Python, VS Build Tools, Node.js) на Windows через winget с UAC prompt.

**Architecture:** PowerShell-функции встраиваются в существующий `/install-vault` flow. Проверка зависимостей происходит перед установкой QMD. При отсутствии компонентов — автоматическая установка через winget с запросом UAC. Fallback на инструкции при ошибках.

**Tech Stack:** PowerShell, winget, npm, Markdown

---

## Task 1: Добавить функции проверки зависимостей в install-vault.md

**Files:**
- Modify: `.claude/commands/install-vault.md`

**Step 1: Добавить Шаг 10.5 — Проверка зависимостей для QMD**

Вставить после строки `## Шаг 10: Создание 00_CORE документов` (после этого шага, перед Шаг 11):

```markdown
---

## Шаг 10.5: Проверка зависимостей для QMD (Windows)

> Только для Windows. На Mac/Linux пропустить этот шаг.

```
🔍 Проверяю зависимости для QMD...
```

Выполните через Bash tool:

```bash
# PowerShell скрипт для проверки и установки зависимостей
powershell.exe -ExecutionPolicy Bypass -Command '
function Test-Command {
    param($Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Test-VSBuildTools {
    $vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $vsWhere) {
        $installed = & $vsWhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 2>$null
        return [bool]$installed
    }
    return $false
}

function Get-MissingDependencies {
    $missing = @()

    if (-not (Test-Command "node")) {
        $missing += "OpenJS.NodeJS.LTS"
    }

    if (-not (Test-Command "python")) {
        $missing += "Python.Python.3.12"
    }

    if (-not (Test-VSBuildTools)) {
        $missing += "Microsoft.VisualStudio.2022.BuildTools"
    }

    return $missing
}

function Install-ViaWinget {
    param([string[]]$Packages)

    foreach ($pkg in $Packages) {
        Write-Host "Installing $pkg..." -ForegroundColor Yellow

        # Запуск winget с UAC
        $process = Start-Process -FilePath "winget" -ArgumentList "install", "--id", $pkg, "-e", "--accept-source-agreements", "--accept-package-agreements" -Verb RunAs -Wait -PassThru

        if ($process.ExitCode -ne 0) {
            Write-Host "Failed to install $pkg. Exit code: $($process.ExitCode)" -ForegroundColor Red
            return $false
        }
    }
    return $true
}

function Get-ManualInstructions {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "ИНСТРУКЦИЯ ДЛЯ РУЧНОЙ УСТАНОВКИ" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Установите следующие компоненты:"
    Write-Host ""
    Write-Host "1. Node.js LTS:" -ForegroundColor Cyan
    Write-Host "   https://nodejs.org/en/download/"
    Write-Host ""
    Write-Host "2. Python 3.12:" -ForegroundColor Cyan
    Write-Host "   https://www.python.org/downloads/"
    Write-Host "   IMPORTANT: Отметьте 'Add Python to PATH' при установке"
    Write-Host ""
    Write-Host "3. Visual Studio Build Tools:" -ForegroundColor Cyan
    Write-Host "   https://visualstudio.microsoft.com/visual-cpp-build-tools/"
    Write-Host "   Выберите workload: 'Desktop development with C++'"
    Write-Host ""
    Write-Host "После установки перезапустите VS Code и выполните:"
    Write-Host "   /install-vault"
    Write-Host ""
}

# Main logic
if ($IsLinux -or $IsMacOS) {
    Write-Host "Not Windows - skipping dependency checks"
    exit 0
}

$missing = Get-MissingDependencies

if ($missing.Count -eq 0) {
    Write-Host "All dependencies installed!" -ForegroundColor Green
    exit 0
}

Write-Host "Missing dependencies: $($missing -join ', ')" -ForegroundColor Yellow

# Check winget
if (-not (Test-Command "winget")) {
    Write-Host "winget not available" -ForegroundColor Red
    Get-ManualInstructions
    exit 1
}

Write-Host "Requesting administrator privileges for installation..." -ForegroundColor Cyan

if (Install-ViaWinget $missing) {
    Write-Host "All dependencies installed successfully!" -ForegroundColor Green
    Write-Host "IMPORTANT: Restart VS Code to apply changes" -ForegroundColor Yellow
    exit 0
} else {
    Get-ManualInstructions
    exit 1
}
'
```

Если скрипт вернул ошибку — покажите пользователю инструкции из вывода.
```

**Step 2: Проверить, что вставка корректна**

Убедиться, что:
- Шаг 10.5 находится между Шаг 10 и Шаг 11
- Markdown-разметка корректна
- Блоки кода правильно закрыты

---

## Task 2: Обновить Шаг 11 (Настройка QMD)

**Files:**
- Modify: `.claude/commands/install-vault.md`

**Step 1: Упростить Шаг 11**

Заменить текущий Шаг 11 на:

```markdown
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
```

---

## Task 3: Обновить финальный отчёт

**Files:**
- Modify: `.claude/commands/install-vault.md`

**Step 1: Обновить секцию "Интеграции" в Шаге 13**

Найти в Шаге 13 блок:
```markdown
## Интеграции:
🔗 MCP ktalk: {статус}
🔍 QMD: {статус}
```

Заменить на:
```markdown
## Интеграции:
🔗 MCP ktalk: {статус}
🔍 QMD: {статус}
   • Если "✓ установлен" — готов к использованию
   • Если "⚠️ требует настройки" — выполните `/install-vault` после установки Node.js
```

---

## Task 4: Обновить install-guide.md

**Files:**
- Modify: `.claude/docs/install-guide.md`

**Step 1: Добавить секцию требований для Windows**

После строки `| **Node.js 18+** | — | QMD (опционально) |` добавить:

```markdown
### Windows-специфичные требования (для QMD)

| Компонент | Для чего | Автоустановка |
|-----------|----------|---------------|
| **Visual Studio Build Tools** | Компиляция нативных модулей | Да (winget) |
| **Python 3.x** | node-gyp | Да (winget) |

При `/install-vault` на Windows автоматически проверяются и устанавливаются недостающие компоненты через winget с запросом прав администратора.
```

**Step 2: Обновить troubleshooting**

Добавить в секцию `## Troubleshooting`:

```markdown
### Проблема: QMD не устанавливается на Windows (gyp ERR!)

**Причина:** Отсутствуют Visual Studio Build Tools или Python.

**Решение:**
1. Запустите `/install-vault` — автоматически установит зависимости
2. Если не сработало — установите вручную:
   - [Visual Studio Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) (workload: Desktop development with C++)
   - [Python 3.12](https://www.python.org/downloads/) (отметьте "Add Python to PATH")
3. Перезапустите VS Code
4. Выполните: `npm install -g @tobilu/qmd`
```

---

## Task 5: Тестирование

**Files:**
- Test: Ручное тестирование на Windows

**Step 1: Проверить синтаксис PowerShell**

Открыть PowerShell и выполнить:
```powershell
# Проверка синтаксиса
$code = Get-Content -Raw ".claude\commands\install-vault.md"
# Найти блок PowerShell и проверить синтаксис
```

**Step 2: Тест на чистой Windows-машине (если возможно)**

1. Запустить `/install-vault`
2. Пройти интервью
3. Дождаться Шага 10.5
4. Подтвердить UAC
5. Проверить установку компонентов
6. Проверить установку QMD

**Step 3: Тест fallback на инструкциях**

1. Эмулировать отсутствие winget (переименовать временно)
2. Запустить `/install-vault`
3. Проверить, что выводятся инструкции

---

## Task 6: Коммит изменений

**Step 1: Закоммитить все изменения**

```bash
git add .claude/commands/install-vault.md
git add .claude/docs/install-guide.md
git add docs/plans/2026-02-27-qmd-windows-deps-implementation.md
git commit -m "$(cat <<'EOF'
feat: auto-install QMD dependencies on Windows via winget

- Add Step 10.5 to /install-vault with PowerShell dependency checker
- Install Node.js, Python, VS Build Tools via winget with UAC prompt
- Fallback to manual instructions on error
- Update install-guide.md with Windows requirements

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Summary

| Task | Description |
|------|-------------|
| 1 | Add Step 10.5 with PowerShell functions |
| 2 | Simplify Step 11 (QMD installation) |
| 3 | Update final report |
| 4 | Update install-guide.md |
| 5 | Testing |
| 6 | Commit |
