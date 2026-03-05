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

# Step 1: Setup bin directory
echo -e "${YELLOW}[1/4]${NC} Setting up ~/bin directory..."
mkdir -p ~/bin
cp "$SCRIPT_DIR/git-alias-help.sh" ~/bin/git-alias-help.sh
chmod +x ~/bin/git-alias-help.sh
echo -e "${GREEN}✓${NC} git-alias-help.sh installed to ~/bin\n"

# Step 2: Merge git config
echo -e "${YELLOW}[2/4]${NC} Setting up git configuration..."

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
echo -e "${YELLOW}[3/4]${NC} Updating ~/.bashrc with git alias integration..."

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
'

# Check if the function is already in bashrc
if grep -q "show_git_aliases_in_projects" ~/.bashrc 2>/dev/null; then
    echo -e "${YELLOW}!${NC} Git alias integration already in ~/.bashrc"
    echo "  Updating to include /projects directory..."
    
    # Replace the old function with the new one
    # First remove the old function
    sed -i '/show_git_aliases_in_desktop/,/^$/d' ~/.bashrc 2>/dev/null || true
    sed -i '/show_git_aliases_in_projects/,/^$/d' ~/.bashrc 2>/dev/null || true
    sed -i '/PROMPT_COMMAND="show_git_aliases/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias githelp=/d' ~/.bashrc 2>/dev/null || true
    
    # Add the new function
    echo "$BASHRC_ADDITION" >> ~/.bashrc
    echo -e "${GREEN}✓${NC} Updated ~/.bashrc\n"
else
    echo "Adding git alias integration to ~/.bashrc..."
    echo "$BASHRC_ADDITION" >> ~/.bashrc
    echo -e "${GREEN}✓${NC} Added to ~/.bashrc\n"
fi

# Step 4: Verify installation
echo -e "${YELLOW}[4/4]${NC} Verifying installation..."

if command -v git &> /dev/null && grep -q "st = status" ~/.gitconfig; then
    echo -e "${GREEN}✓${NC} Git is installed and configured"
fi

if [ -x ~/bin/git-alias-help.sh ]; then
    echo -e "${GREEN}✓${NC} git-alias-help.sh is executable"
fi

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
echo "Try: ${BLUE}cd ~/Desktop && git status${NC}"
