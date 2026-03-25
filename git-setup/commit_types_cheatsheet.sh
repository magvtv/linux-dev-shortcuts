#!/bin/bash

# Display a colorful commit type cheatsheet
# This script shows conventional commit types with examples

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

clear
echo -e "${BOLD}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║                    GIT COMMIT TYPE GUIDE                     ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════════╝${RESET}"
echo -e ""
echo -e "${BOLD}Prefix your commit messages with one of these types:${RESET}"
echo -e ""
echo -e "${GREEN}${BOLD}feat:${RESET} A new feature"
echo -e "  ${CYAN}Example:${RESET} feat: add user authentication"
echo -e ""
echo -e "${RED}${BOLD}fix:${RESET} A bug fix"
echo -e "  ${CYAN}Example:${RESET} fix: resolve login button not working"
echo -e ""
echo -e "${BLUE}${BOLD}docs:${RESET} Documentation changes"
echo -e "  ${CYAN}Example:${RESET} docs: update API documentation"
echo -e ""
echo -e "${PURPLE}${BOLD}style:${RESET} Code style changes (formatting, indentation)"
echo -e "  ${CYAN}Example:${RESET} style: format code according to style guide"
echo -e ""
echo -e "${YELLOW}${BOLD}refactor:${RESET} Code refactoring (no feature/bug changes)"
echo -e "  ${CYAN}Example:${RESET} refactor: simplify authentication logic"
echo -e ""
echo -e "${CYAN}${BOLD}perf:${RESET} Performance improvements"
echo -e "  ${CYAN}Example:${RESET} perf: optimize database queries"
echo -e ""
echo -e "${BLUE}${BOLD}test:${RESET} Adding or updating tests"
echo -e "  ${CYAN}Example:${RESET} test: add unit tests for user module"
echo -e ""
echo -e "${YELLOW}${BOLD}chore:${RESET} Build process, tools or dependencies updates"
echo -e "  ${CYAN}Example:${RESET} chore: update npm dependencies"
echo -e ""
echo -e "${RED}${BOLD}hotfix:${RESET} Critical bug fixes requiring immediate attention"
echo -e "  ${CYAN}Example:${RESET} hotfix: fix security vulnerability in auth"
echo -e ""
echo -e "${PURPLE}${BOLD}revert:${RESET} Revert a previous commit"
echo -e "  ${CYAN}Example:${RESET} revert: return to version before feature X"
echo -e ""
echo -e "${BOLD}To see detailed explanations, use:${RESET} gitcommit or gitcheat"
echo -e ""
echo -e "${BOLD}Common format:${RESET} <type>: <short summary>"
echo -e "${BOLD}Example:${RESET} feat: add new user dashboard"
echo -e ""
echo -e "${BOLD}Best Practices:${RESET}"
echo -e "• Use imperative mood (\"add\" not \"added\")"
echo -e "• Keep first line under 50 characters"
echo -e "• Consider adding detailed description after summary"
echo -e "• Reference issue numbers if applicable"
echo -e ""
