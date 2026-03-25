#!/bin/bash

# Test script for Git Smart Tools setup
# Run this AFTER running setup-git-aliases.sh and sourcing ~/.bashrc
# Usage: bash test-git-help.sh

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[1;31m'
BOLD='\033[1m'
RESET='\033[0m'

divider() {
  echo -e "\n${GREEN}=== $1 ===${RESET}\n"
}

# ─── Check Prerequisites ──────────────────────────────────────────────────

divider "CHECKING PREREQUISITES"

PASS=true

for script in git-alias-help.sh git_smart_commit.sh smart_git_add.sh commit_types_cheatsheet.sh; do
  if [ -x ~/bin/$script ]; then
    echo -e "  ${GREEN}✓${RESET} ~/bin/$script"
  else
    echo -e "  ${RED}✗${RESET} ~/bin/$script missing or not executable"
    PASS=false
  fi
done

if [ -f ~/bin/commit_shorthand_notes.md ]; then
  echo -e "  ${GREEN}✓${RESET} ~/bin/commit_shorthand_notes.md"
else
  echo -e "  ${RED}✗${RESET} ~/bin/commit_shorthand_notes.md missing"
  PASS=false
fi

if grep -q "Git Context-Sensitive Helper" ~/.bashrc 2>/dev/null; then
  echo -e "  ${GREEN}✓${RESET} Bash integration installed in ~/.bashrc"
else
  echo -e "  ${RED}✗${RESET} Bash integration NOT found in ~/.bashrc"
  PASS=false
fi

if [ "$PASS" = false ]; then
  echo -e "\n${RED}Some prerequisites are missing. Run setup-git-aliases.sh first.${RESET}"
  echo -e "  bash $(dirname "$0")/setup-git-aliases.sh"
  echo -e "  source ~/.bashrc"
  exit 1
fi

echo -e "\n${GREEN}All prerequisites met.${RESET}"

# ─── Test 1: Auto-display on directory entry ───────────────────────────────

divider "TEST 1: Auto-display when entering a git repo"

export LAST_GIT_ALIAS_HELP_DIR=""

echo -e "${YELLOW}Simulating entering a non-git directory...${RESET}"
pushd /tmp > /dev/null
show_git_aliases_in_projects 2>/dev/null
echo -e "${CYAN}→ No alias help should appear above${RESET}\n"
popd > /dev/null

echo -e "${YELLOW}Simulating entering a git project directory...${RESET}"
# Use current repo since we know it's a git repo
pushd "$(git -C "$(dirname "$0")" rev-parse --show-toplevel)" > /dev/null
export LAST_GIT_ALIAS_HELP_DIR=""
show_git_aliases_in_projects 2>/dev/null
echo -e "${CYAN}→ Alias help should appear above${RESET}\n"

echo -e "${YELLOW}Simulating running another command in same repo...${RESET}"
show_git_aliases_in_projects 2>/dev/null
echo -e "${CYAN}→ Alias help should NOT appear again (shown once per dir)${RESET}"
popd > /dev/null

# ─── Test 2: githelp command ──────────────────────────────────────────────

divider "TEST 2: Manual 'githelp' command"
echo -e "${YELLOW}Running githelp...${RESET}"
~/bin/git-alias-help.sh
echo -e "${CYAN}→ Full alias cheat sheet should appear above${RESET}"

# ─── Test 3: Commit types cheatsheet ─────────────────────────────────────

divider "TEST 3: Commit types cheatsheet (gitcheat)"
echo -e "${YELLOW}Running commit_types_cheatsheet.sh...${RESET}"
~/bin/commit_types_cheatsheet.sh
echo -e "${CYAN}→ Colorful commit type guide should appear above${RESET}"

# ─── Test 4: Smart commit help ───────────────────────────────────────────

divider "TEST 4: Smart commit help (gitcommit -h)"
echo -e "${YELLOW}Running git_smart_commit.sh -h...${RESET}"
~/bin/git_smart_commit.sh -h
echo -e "\n${CYAN}→ Smart commit usage info should appear above${RESET}"

# ─── Test 5: Context-sensitive git wrapper ───────────────────────────────

divider "TEST 5: Context-sensitive git wrapper"

if type -t git | grep -q "function"; then
  echo -e "  ${GREEN}✓${RESET} git is wrapped as a bash function"
else
  echo -e "  ${RED}✗${RESET} git wrapper function not loaded"
  echo -e "  ${YELLOW}Make sure you ran: source ~/.bashrc${RESET}"
fi

echo ""
echo -e "${YELLOW}What the git wrapper does:${RESET}"
echo -e "  ${BOLD}git add <file>${RESET}    → runs git add, then shows staged files + commit hint"
echo -e "  ${BOLD}git commit -m ..${RESET}  → shows commit type quick-reference box, then commits"
echo -e "  ${BOLD}git <anything>${RESET}    → passes through unchanged"

# ─── Test 6: Smart add function ──────────────────────────────────────────

divider "TEST 6: Smart add function (ga)"

if type -t smart_git_add | grep -q "function"; then
  echo -e "  ${GREEN}✓${RESET} smart_git_add function is loaded"
else
  echo -e "  ${RED}✗${RESET} smart_git_add function not loaded"
  echo -e "  ${YELLOW}Make sure you ran: source ~/.bashrc${RESET}"
fi

echo ""
echo -e "${YELLOW}Smart add usage:${RESET}"
echo -e "  ${BOLD}ga filename.ext${RESET}               → fuzzy match by filename"
echo -e "  ${BOLD}ga partial/path filename.ext${RESET}  → match by path + filename"

# ─── Summary ─────────────────────────────────────────────────────────────

divider "AVAILABLE COMMANDS SUMMARY"

echo -e "  ${GREEN}gitcommit${RESET}    Full interactive commit (cheatsheet → type menu → message)"
echo -e "  ${GREEN}gc${RESET}           Quick smart commit (type menu → message)"
echo -e "  ${GREEN}ga <file>${RESET}    Smart add with fuzzy file matching"
echo -e "  ${GREEN}gitcheat${RESET}     Show commit types cheatsheet"
echo -e "  ${GREEN}githelp${RESET}      Show all git aliases"
echo -e "  ${GREEN}git ci${RESET}       Git alias → smart commit (quick mode)"
echo -e "  ${GREEN}git ac${RESET}       Git alias → add all + smart commit"
echo ""
echo -e "${CYAN}Context-sensitive helpers (automatic):${RESET}"
echo -e "  ${GREEN}git add${RESET}      → shows staged files + commit hint after adding"
echo -e "  ${GREEN}git commit${RESET}   → shows commit type reference before committing"
echo ""
echo -e "${BOLD}Setup complete! Restart your terminal or run 'source ~/.bashrc' to activate.${RESET}"
