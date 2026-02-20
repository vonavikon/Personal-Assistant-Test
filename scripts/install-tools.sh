#!/bin/bash
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}✓${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1" >&2; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
info() { echo -e "→ $1"; }

SKILLS_DIR="$HOME/.claude/skills"

install_qmd() {
    info "Installing qmd..."
    if command -v qmd &>/dev/null; then
        success "qmd already installed ($(qmd --version 2>/dev/null || echo 'unknown version'))"
        return 0
    fi
    if ! command -v node &>/dev/null; then
        error "Node.js not found. Install Node.js 18+ first: https://nodejs.org"
        return 1
    fi
    npm install -g @tobilu/qmd
    if command -v qmd &>/dev/null; then
        success "qmd installed ($(qmd --version))"
    else
        error "qmd installation failed"
        return 1
    fi
}

install_tg_parser() {
    info "Installing tg-parser..."
    if command -v tg-parser &>/dev/null; then
        success "tg-parser already installed"
        return 0
    fi
    if command -v uv &>/dev/null; then
        uv tool install tg-parser
    elif command -v pip3 &>/dev/null; then
        pip3 install tg-parser
    else
        error "Neither uv nor pip3 found. Install uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
        return 1
    fi
    success "tg-parser installed"
}

install_skill() {
    local repo_url="$1"
    local skill_path="$2"
    local skill_name="$3"

    info "Installing skill: $skill_name..."

    local target="$SKILLS_DIR/$skill_name"
    if [ -d "$target" ]; then
        warn "$skill_name already exists, skipping"
        return 0
    fi

    mkdir -p "$SKILLS_DIR"
    local tmp_dir=$(mktemp -d)
    git clone --depth 1 --filter=blob:none --sparse "$repo_url" "$tmp_dir" 2>/dev/null
    git -C "$tmp_dir" sparse-checkout set "$skill_path" 2>/dev/null

    if [ -d "$tmp_dir/$skill_path" ]; then
        cp -r "$tmp_dir/$skill_path" "$target"
        success "$skill_name installed to $target"
    else
        error "Could not find $skill_path in repo"
    fi
    rm -rf "$tmp_dir"
}

echo ""
echo "=== Executive Assistant — Tool Installer ==="
echo ""

# Parse arguments
INSTALL_QMD=false
INSTALL_TG=false
INSTALL_SKILLS=false

for arg in "$@"; do
    case $arg in
        --qmd) INSTALL_QMD=true ;;
        --tg-parser) INSTALL_TG=true ;;
        --skills) INSTALL_SKILLS=true ;;
        --all) INSTALL_QMD=true; INSTALL_TG=true; INSTALL_SKILLS=true ;;
        --help) echo "Usage: $0 [--qmd] [--tg-parser] [--skills] [--all]"; exit 0 ;;
    esac
done

if [ "$INSTALL_QMD" = true ]; then
    install_qmd || true
fi

if [ "$INSTALL_TG" = true ]; then
    install_tg_parser || true
fi

if [ "$INSTALL_SKILLS" = true ]; then
    install_skill "https://github.com/mdemyanov/ai-assistants" "skills/meeting-debrief" "meeting-debrief"
    install_skill "https://github.com/mdemyanov/ai-assistants" "skills/correspondence-2" "correspondence-2"
    install_skill "https://github.com/mdemyanov/ai-assistants" "skills/meeting-prep" "meeting-prep"
fi

echo ""
echo "=== Done ==="
