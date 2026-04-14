#!/bin/bash

# Git Smart Commit - Combined interactive commit with conventional commit types
# Merges functionality from git_commit_with_type.sh and git_ci_enhanced.sh
# Usage:
#   git_smart_commit              # Interactive: show cheatsheet + type menu + message
#   git_smart_commit -s "msg"     # Skip type selection, use custom message
#   git_smart_commit -q           # Quick mode: type menu only, no cheatsheet
#   git_smart_commit -h           # Show help

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Resolve the cheatsheet notes path relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEATSHEET_NOTES="$SCRIPT_DIR/commit_shorthand_notes.md"

# ─── Help ───────────────────────────────────────────────────────────────────

show_help() {
    echo -e "${BOLD}Git Smart Commit${RESET} — Interactive conventional commit helper"
    echo ""
    echo "Usage: git_smart_commit [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --skip     Skip type selection, commit with custom message"
    echo "                 e.g. git_smart_commit -s \"my commit message\""
    echo "  -q, --quick    Quick mode: skip cheatsheet, go straight to type menu"
    echo ""
    echo "Workflow (default):"
    echo "  1. Display commit types cheatsheet"
    echo "  2. Show current git status"
    echo "  3. Select a commit type (or custom)"
    echo "  4. Enter commit summary"
    echo "  5. Optionally enter detailed description"
    echo "  6. Confirm and commit"
    echo ""
    echo "Commit types: feat, fix, chore, perf, docs, style, refactor, test, hotfix, revert"
}

# ─── Cheatsheet Display ────────────────────────────────────────────────────

show_cheatsheet() {
    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}║                    GIT COMMIT TYPE GUIDE                     ║${RESET}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${GREEN}${BOLD}feat:${RESET}     A new feature"
    echo -e "          ${CYAN}Example:${RESET} feat: add user authentication"
    echo -e "${RED}${BOLD}fix:${RESET}      A bug fix"
    echo -e "          ${CYAN}Example:${RESET} fix: resolve login button not working"
    echo -e "${BLUE}${BOLD}docs:${RESET}     Documentation changes"
    echo -e "          ${CYAN}Example:${RESET} docs: update API documentation"
    echo -e "${PURPLE}${BOLD}style:${RESET}    Code style changes (formatting, indentation)"
    echo -e "          ${CYAN}Example:${RESET} style: format code according to style guide"
    echo -e "${YELLOW}${BOLD}refactor:${RESET} Code refactoring (no feature/bug changes)"
    echo -e "          ${CYAN}Example:${RESET} refactor: simplify authentication logic"
    echo -e "${CYAN}${BOLD}perf:${RESET}     Performance improvements"
    echo -e "          ${CYAN}Example:${RESET} perf: optimize database queries"
    echo -e "${BLUE}${BOLD}test:${RESET}     Adding or updating tests"
    echo -e "          ${CYAN}Example:${RESET} test: add unit tests for user module"
    echo -e "${YELLOW}${BOLD}chore:${RESET}    Build process, tools or dependencies updates"
    echo -e "          ${CYAN}Example:${RESET} chore: update npm dependencies"
    echo -e "${RED}${BOLD}hotfix:${RESET}   Critical bug fix requiring immediate attention"
    echo -e "          ${CYAN}Example:${RESET} hotfix: fix security vulnerability in auth"
    echo -e "${PURPLE}${BOLD}revert:${RESET}   Revert a previous commit"
    echo -e "          ${CYAN}Example:${RESET} revert: return to version before feature X"
    echo ""
    echo -e "${BOLD}Best Practices:${RESET}"
    echo -e "  • Use imperative mood (\"add\" not \"added\")"
    echo -e "  • Keep first line under 50 characters"
    echo -e "  • Consider adding a detailed description after the summary"
    echo -e "  • Reference issue numbers if applicable"
    echo ""
}

# ─── Type Selection Menu ───────────────────────────────────────────────────

show_type_menu() {
    echo -e "${BOLD}Select a commit type:${RESET}"
    echo -e "  ${GREEN}1)${RESET} feat      New feature"
    echo -e "  ${GREEN}2)${RESET} fix       Bug fix"
    echo -e "  ${GREEN}3)${RESET} chore     Routine task"
    echo -e "  ${GREEN}4)${RESET} perf      Performance improvement"
    echo -e "  ${GREEN}5)${RESET} docs      Documentation"
    echo -e "  ${GREEN}6)${RESET} style     Code style changes"
    echo -e "  ${GREEN}7)${RESET} refactor  Code refactoring"
    echo -e "  ${GREEN}8)${RESET} test      Adding/updating tests"
    echo -e "  ${GREEN}9)${RESET} hotfix    Critical bug fix"
    echo -e "  ${GREEN}10)${RESET} revert   Reverting changes"
    echo -e "  ${YELLOW}11)${RESET} custom   Enter full message manually"
    echo -e "  ${BLUE}12)${RESET} help     Show detailed type descriptions"
    echo -e "  ${RED}q)${RESET}  quit     Cancel commit"
    echo ""
    read -p "Choice (1-12 or q): " choice

    case $choice in
        1)  echo "feat" ;;
        2)  echo "fix" ;;
        3)  echo "chore" ;;
        4)  echo "perf" ;;
        5)  echo "docs" ;;
        6)  echo "style" ;;
        7)  echo "refactor" ;;
        8)  echo "test" ;;
        9)  echo "hotfix" ;;
        10) echo "revert" ;;
        11) echo "custom" ;;
        12)
            if [ -f "$CHEATSHEET_NOTES" ]; then
                less "$CHEATSHEET_NOTES"
            else
                echo -e "${YELLOW}Cheatsheet notes not found at $CHEATSHEET_NOTES${RESET}" >&2
            fi
            show_type_menu
            ;;
        q|Q)
            echo "quit"
            ;;
        *)
            echo -e "${RED}Invalid choice. Try again.${RESET}" >&2
            show_type_menu
            ;;
    esac
}

# ─── Main ──────────────────────────────────────────────────────────────────

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo -e "${RED}Error: Not in a git repository.${RESET}"
    exit 1
fi

# Skip mode: commit with custom message directly
if [[ "$1" == "-s" || "$1" == "--skip" ]]; then
    shift
    if [ -n "$1" ]; then
        git commit -m "$*"
    else
        git commit
    fi
    exit $?
fi

# Determine if quick mode (skip cheatsheet)
QUICK=false
if [[ "$1" == "-q" || "$1" == "--quick" ]]; then
    QUICK=true
    shift
fi

# Step 1: Show cheatsheet (unless quick mode)
if [ "$QUICK" = false ]; then
    show_cheatsheet
    read -p "Press Enter to continue or Ctrl+C to cancel..."
    echo ""
fi

# Step 2: Show git status
echo -e "${BOLD}Current git status:${RESET}"
git status -s
echo ""

# Step 3: Select commit type
commit_type=$(show_type_menu)

if [ "$commit_type" == "quit" ]; then
    echo -e "${YELLOW}Commit cancelled.${RESET}"
    exit 0
fi

# Step 4: Handle custom message
if [ "$commit_type" == "custom" ]; then
    read -p "Enter your full commit message: " commit_message
    if [ -z "$commit_message" ]; then
        echo -e "${RED}Error: Commit message cannot be empty.${RESET}"
        exit 1
    fi
    echo ""
    echo -e "About to commit with message: ${BOLD}\"$commit_message\"${RESET}"
    read -p "Proceed? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        git commit -m "$commit_message"
        echo -e "${GREEN}✅ Commit created successfully${RESET}"
    else
        echo -e "${YELLOW}Commit cancelled.${RESET}"
    fi
    exit $?
fi

# Step 5: Get commit summary
read -p "Enter commit summary (without type prefix): " commit_summary
if [ -z "$commit_summary" ]; then
    echo -e "${RED}Error: Commit message cannot be empty.${RESET}"
    exit 1
fi

# Step 6: Optional detailed description
echo "Enter detailed description (press Enter to skip, or type then press Enter):"
read -r description

# Step 7: Build and confirm
full_summary="$commit_type: $commit_summary"
echo ""
echo -e "About to commit with message: ${BOLD}\"$full_summary\"${RESET}"
if [ -n "$description" ]; then
    echo -e "Description: ${description}"
fi
read -p "Proceed? (y/n): " confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    if [ -n "$description" ]; then
        git commit -m "$full_summary" -m "$description"
    else
        git commit -m "$full_summary"
    fi
    echo -e "${GREEN}✅ Commit created successfully${RESET}"
else
    echo -e "${YELLOW}Commit cancelled.${RESET}"
fi
