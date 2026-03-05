#!/bin/bash

# Git Aliases Help Script
# Displays all custom git aliases in a organized, readable format

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Header
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${YELLOW}            CUSTOM GIT ALIASES - Quick Reference${CYAN}                  ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}\n"

# Get git aliases
git config --get-regexp alias | while read -r alias command; do
    alias_name="${alias#alias.}"
    # Truncate long commands for display
    display_cmd="${command:0:50}"
    if [ ${#command} -gt 50 ]; then
        display_cmd="${display_cmd}..."
    fi
    
    # Format output
    printf "${GREEN}%-12s${NC} → ${BLUE}%s${NC}\n" "$alias_name" "$display_cmd"
done

echo ""

# Show commonly used ones with descriptions
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Quick Access Commands:${NC}\n"

echo -e "${GREEN}st${NC}         Status check"
echo -e "${GREEN}ci${NC}         Commit with interactive prompts"
echo -e "${GREEN}ac${NC}         Add all changes then commit"
echo -e "${GREEN}br${NC}         Branch overview with timestamps"
echo -e "${GREEN}co${NC}         Checkout branch"
echo -e "${GREEN}lg${NC}         Pretty commit log"
echo -e "${GREEN}timeline${NC}   Full git history visualization"
echo -e "${GREEN}compare${NC}    Compare current branch with others"
echo -e "${GREEN}ps${NC}         Smart push (sets upstream if needed)"
echo -e "${GREEN}sync${NC}       Fetch and pull with rebase"
echo -e "${GREEN}new${NC}        Create new branch interactively"
echo -e "${GREEN}sw${NC}         Switch branch with fuzzy search"
echo -e "${GREEN}cleanup${NC}    Remove merged branches"
echo -e "${GREEN}undo${NC}       Undo last commit (interactive)"
echo -e "${GREEN}unstage${NC}    Unstage all files"
echo -e "${GREEN}pop${NC}        Restore stashed changes"

echo -e "\n${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "Use ${MAGENTA}git <alias>${NC} to run any of these commands"
echo -e "Use ${MAGENTA}githelp${NC} to display this message anytime\n"
