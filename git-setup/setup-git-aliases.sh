#!/bin/bash

# Git Aliases Setup Script
# This script properly installs git aliases and bash integration

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Git Aliases Setup ===${NC}\n"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Step 1: Setup bin directory and install scripts
echo -e "${YELLOW}[1/5]${NC} Installing scripts to ~/bin..."
mkdir -p ~/bin

# Core scripts to install
for script in git-alias-help.sh git_smart_commit.sh smart_git_add.sh commit_types_cheatsheet.sh commit_shorthand_notes.md git_ci_enhanced.sh; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        cp "$SCRIPT_DIR/$script" ~/bin/"$script"
        chmod +x ~/bin/"$script"
        echo -e "  ${GREEN}✓${NC} $script"
    else
        echo -e "  ${RED}✗${NC} $script not found in $SCRIPT_DIR"
    fi
done
echo ""

# Step 2: Merge git config
echo -e "${YELLOW}[2/5]${NC} Setting up git configuration..."

# Check if .gitconfig exists
if [ -f ~/.gitconfig ]; then
    echo "Found existing ~/.gitconfig"
    
    # Check if aliases from git-setup are already there
    if grep -q "\[alias\]" ~/.gitconfig && grep -q "st = status" ~/.gitconfig; then
        echo -e "${GREEN}✓${NC} Git aliases already configured\n"
    else
        echo "Merging aliases into existing .gitconfig..."
        # Extract the alias section from git-setup/.gitconfig and append to ~/.gitconfig
        sed -n '/\[alias\]/,/^\[/p' "$SCRIPT_DIR/.gitconfig" | sed '$ d' >> ~/.gitconfig
        echo -e "${GREEN}✓${NC} Aliases merged into ~/.gitconfig\n"
    fi
else
    echo "No existing .gitconfig found, copying from git-setup..."
    cp "$SCRIPT_DIR/.gitconfig" ~/.gitconfig
    echo -e "${GREEN}✓${NC} .gitconfig installed to ~\n"
fi

# Step 3: Update bashrc with improved function
echo -e "${YELLOW}[3/5]${NC} Updating ~/.bashrc with git alias integration..."

# Create the new bashrc content
BASHRC_ADDITION='
# ============================================
# Custom Git Aliases - Auto Display
# ============================================
# Show git aliases when entering git repositories (Desktop or /projects)
show_git_aliases_in_projects() {
  local current_dir=$(pwd)
  
  # Check if we are in a git repo in Desktop or /projects directories
  if { [[ "$current_dir" == "/home/pharoh/Desktop"* ]] || [[ "$current_dir" == "/projects"* ]]; } && \
     git rev-parse --git-dir > /dev/null 2>&1; then
    # Dont show if we already showed in this directory (avoid showing on every command)
    if [[ "$LAST_GIT_ALIAS_HELP_DIR" != "$current_dir" ]]; then
      ~/bin/git-alias-help.sh
      export LAST_GIT_ALIAS_HELP_DIR="$current_dir"
    fi
  else
    # Reset when we leave git repos in those directories
    if [[ "$current_dir" != "/home/pharoh/Desktop"* ]] && [[ "$current_dir" != "/projects"* ]]; then
      export LAST_GIT_ALIAS_HELP_DIR=""
    fi
  fi
}

# Add the function to PROMPT_COMMAND
PROMPT_COMMAND="show_git_aliases_in_projects;${PROMPT_COMMAND:+$PROMPT_COMMAND}"

# Create an explicit command to show git aliases
alias githelp=~/bin/git-alias-help.sh

# ============================================
# Git Smart Tools - System-wide Commands
# ============================================
# Smart commit with conventional commit types
alias gitcommit="~/bin/git_smart_commit.sh"
alias gc="~/bin/git_smart_commit.sh -q"

# Smart add with fuzzy file matching
source ~/bin/smart_git_add.sh 2>/dev/null
alias ga=smart_git_add

# Quick cheatsheet for commit types
alias gitcheat="~/bin/commit_types_cheatsheet.sh"

# ============================================
# Git Context-Sensitive Helper Wrapper
# ============================================
# Wraps git to show relevant tips after add and before commit
git() {
  case "$1" in
    add)
      command git "$@"
      local _status=$?
      if [ $_status -eq 0 ]; then
        echo ""
        local staged
        staged=$(command git diff --cached --name-only 2>/dev/null)
        if [ -n "$staged" ]; then
          echo -e "\033[1m📋 Staged files:\033[0m"
          command git diff --cached --stat --no-color | tail -n +1
          echo ""
          echo -e "\033[33m💡 Ready to commit? Use \033[1mgc\033[0m\033[33m (smart commit) or \033[1mgitcommit\033[0m\033[33m (full guide)\033[0m"
        fi
      fi
      return $_status
      ;;
    commit)
      if [[ "$2" != "-h" && "$2" != "--help" ]]; then
        echo -e "\033[1m┌─ Commit Type Quick Reference ─────────────────────────────────┐\033[0m"
        echo -e "\033[1m│\033[0m \033[32mfeat\033[0m \033[31mfix\033[0m \033[33mchore\033[0m \033[36mperf\033[0m \033[34mdocs\033[0m \033[35mstyle\033[0m \033[33mrefactor\033[0m \033[34mtest\033[0m \033[31mhotfix\033[0m \033[35mrevert\033[0m \033[1m│\033[0m"
        echo -e "\033[1m│\033[0m Format: \033[1m<type>: <message>\033[0m  e.g. feat: add login page       \033[1m│\033[0m"
        echo -e "\033[1m│\033[0m \033[33m💡 Tip: use \033[1mgc\033[0m\033[33m for interactive type selection\033[0m                 \033[1m│\033[0m"
        echo -e "\033[1m└───────────────────────────────────────────────────────────────┘\033[0m"
        echo ""
      fi
      command git "$@"
      ;;
    *)
      command git "$@"
      ;;
  esac
}
'

# Check if any of our additions are already in bashrc
if grep -q "Custom Git Aliases\|Git Smart Tools\|Git Context-Sensitive" ~/.bashrc 2>/dev/null; then
    echo -e "${YELLOW}!${NC} Git integration already in ~/.bashrc, replacing..."
    
    # Remove all previous sections cleanly
    sed -i '/show_git_aliases_in_desktop/,/^$/d' ~/.bashrc 2>/dev/null || true
    sed -i '/show_git_aliases_in_projects/,/^$/d' ~/.bashrc 2>/dev/null || true
    sed -i '/PROMPT_COMMAND="show_git_aliases/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias githelp=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias gitcommit=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias gc=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias ga=smart_git_add/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias gitcheat=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/source ~\/bin\/smart_git_add.sh/d' ~/.bashrc 2>/dev/null || true
    # Remove the old git wrapper function block
    sed -i '/# Git Context-Sensitive Helper/,/^}/d' ~/.bashrc 2>/dev/null || true
    # Remove section headers
    sed -i '/# Custom Git Aliases - Auto Display/d' ~/.bashrc 2>/dev/null || true
    sed -i '/# Git Smart Tools - System-wide/d' ~/.bashrc 2>/dev/null || true
    sed -i '/# =\+$/d' ~/.bashrc 2>/dev/null || true
    
    # Add the new content
    echo "$BASHRC_ADDITION" >> ~/.bashrc
    echo -e "${GREEN}✓${NC} Updated ~/.bashrc\n"
else
    echo "Adding git alias integration to ~/.bashrc..."
    echo "$BASHRC_ADDITION" >> ~/.bashrc
    echo -e "${GREEN}✓${NC} Added to ~/.bashrc\n"
fi

# Step 4: Update git aliases to use smart commit
echo -e "${YELLOW}[4/5]${NC} Updating git aliases for smart commit..."

# ci alias: delegate cleanly to script (no inline bash in .gitconfig)
git config --global alias.ci '!~/bin/git_ci_enhanced.sh'
# Update ac alias to add all + smart commit
git config --global alias.ac '!git add -A && ~/bin/git_smart_commit.sh -q'
echo -e "${GREEN}✓${NC} git ci → enhanced commit script (cheatsheet + summary + description)"
echo -e "${GREEN}✓${NC} git ac → add all + smart commit (quick mode)\n"

# Step 5: Verify installation
echo -e "${YELLOW}[5/5]${NC} Verifying installation..."

if command -v git &> /dev/null && grep -q "st = status" ~/.gitconfig; then
    echo -e "${GREEN}✓${NC} Git is installed and configured"
fi

for script in git-alias-help.sh git_smart_commit.sh smart_git_add.sh commit_types_cheatsheet.sh git_ci_enhanced.sh; do
    if [ -x ~/bin/$script ]; then
        echo -e "${GREEN}✓${NC} $script is executable"
    else
        echo -e "${RED}✗${NC} $script is missing or not executable"
    fi
done

if grep -q "show_git_aliases_in_projects" ~/.bashrc 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Bash integration is configured"
fi

echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "To activate the new configuration, run:"
echo -e "  ${BLUE}source ~/.bashrc${NC}"
echo ""
echo "Your git aliases will now be:"
echo "  • Automatically displayed when entering git repos in ~/Desktop or /projects"
echo "  • Available via ${BLUE}githelp${NC} command anytime"
echo ""
echo -e "${BOLD}System-wide git tools:${NC}"
echo -e "  ${GREEN}gitcommit${NC}   Smart commit with type selection + cheatsheet"
echo -e "  ${GREEN}gc${NC}          Quick smart commit (skip cheatsheet)"
echo -e "  ${GREEN}ga${NC}          Smart add with fuzzy file matching"
echo -e "  ${GREEN}gitcheat${NC}    Show commit types cheatsheet"
echo -e "  ${GREEN}git ci${NC}      Smart commit (quick mode via git alias)"
echo -e "  ${GREEN}git ac${NC}      Add all + smart commit (quick mode via git alias)"
echo ""
echo -e "Try: ${BLUE}source ~/.bashrc && gitcommit${NC}"
