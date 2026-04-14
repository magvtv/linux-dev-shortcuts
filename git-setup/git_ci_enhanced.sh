#!/bin/bash

# ============================================================
# git_ci_enhanced.sh
# Enhanced "git ci" command — shows a commit type guide (TOC),
# lets you write a commit summary and optional multi-line
# description, then creates the commit locally.
# No bash logic is embedded in .gitconfig.
# ============================================================

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ── 1. Show the commit types cheatsheet (TOC) ──────────────
# Resolve path to the cheatsheet relative to this script's
# real location, then fall back to ~/bin if needed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEATSHEET="$SCRIPT_DIR/commit_types_cheatsheet.sh"

if [ ! -x "$CHEATSHEET" ]; then
  CHEATSHEET="$HOME/bin/commit_types_cheatsheet.sh"
fi

if [ -x "$CHEATSHEET" ]; then
  bash "$CHEATSHEET"
else
  echo -e "${YELLOW}⚠  Commit types cheatsheet not found.${RESET}"
fi

# ── 2. Continue prompt ─────────────────────────────────────
echo ""
read -rp "Press Enter to continue to commit or Ctrl+C to cancel... "

# ── 3. Show git status ─────────────────────────────────────
echo ""
echo -e "${BOLD}Current git status:${RESET}"
git status -s
echo ""

# ── 4. Commit summary ─────────────────────────────────────
echo -e "${CYAN}Enter commit summary${RESET} (type prefix recommended, e.g. ${GREEN}feat: add login${RESET}):"
read -r summary

if [ -z "$summary" ]; then
  echo -e "${RED}Error: Commit message cannot be empty.${RESET}"
  exit 1
fi

# ── 5. Optional multi-line description ────────────────────
echo ""
echo -e "${CYAN}Enter description${RESET} (optional — one or more lines)."
echo -e "  • Type each line and press ${BOLD}Enter${RESET}."
echo -e "  • Press ${BOLD}Enter on a blank line${RESET} when finished (or skip to commit now)."
echo ""

description_lines=()
while IFS= read -r line; do
  # Stop on first blank line
  [[ -z "$line" ]] && break
  description_lines+=("$line")
done

# Join collected lines with newlines
description=""
if [ ${#description_lines[@]} -gt 0 ]; then
  description=$(printf '%s\n' "${description_lines[@]}")
fi

# ── 6. Create the commit ──────────────────────────────────
if [ -n "$description" ]; then
  git commit -m "$summary" -m "$description"
else
  git commit -m "$summary"
fi

echo ""
echo -e "${GREEN}✅ Commit created successfully${RESET}"
