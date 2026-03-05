#!/bin/bash

# System-wide installation script for dev-shortcuts
# This script adds the dev-shortcuts directory to your PATH
# Author: ZRW

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

DEV_SHORTCUTS_DIR="/home/pharoh/dev-shortcuts"
BASHRC="$HOME/.bashrc"
PROFILE="$HOME/.profile"
PATH_ENTRY="export PATH=\"\$PATH:$DEV_SHORTCUTS_DIR\""

print_header() {
    echo -e "${CYAN}=== $1 ===${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if dev-shortcuts directory exists
if [ ! -d "$DEV_SHORTCUTS_DIR" ]; then
    print_error "dev-shortcuts directory not found at $DEV_SHORTCUTS_DIR"
    exit 1
fi

print_header "Installing dev-shortcuts system-wide"

# Function to add PATH entry to a file
add_to_path() {
    local file=$1
    local entry=$2
    
    if [ ! -f "$file" ]; then
        print_warning "$file does not exist, creating it..."
        touch "$file"
    fi
    
    # Check if entry already exists
    if grep -Fxq "$entry" "$file" 2>/dev/null; then
        print_warning "PATH entry already exists in $file"
        return 1
    else
        echo "" >> "$file"
        echo "# Added by dev-shortcuts install-system-wide.sh" >> "$file"
        echo "$entry" >> "$file"
        print_success "Added PATH entry to $file"
        return 0
    fi
}

# Add to .bashrc
print_status "Updating .bashrc..."
if add_to_path "$BASHRC" "$PATH_ENTRY"; then
    print_success ".bashrc updated"
fi

# Add to .profile (for login shells)
print_status "Updating .profile..."
if add_to_path "$PROFILE" "$PATH_ENTRY"; then
    print_success ".profile updated"
fi

# Make all scripts executable
print_status "Ensuring all scripts are executable..."
find "$DEV_SHORTCUTS_DIR" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
print_success "Scripts are executable"

# Create symlinks for commonly used scripts in subdirectories
print_status "Creating convenience symlinks..."
mkdir -p "$DEV_SHORTCUTS_DIR/bin"

# Create symlinks for scripts in subdirectories
for script in "$DEV_SHORTCUTS_DIR"/*/*.sh; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        if [ ! -L "$DEV_SHORTCUTS_DIR/bin/$script_name" ]; then
            ln -sf "$script" "$DEV_SHORTCUTS_DIR/bin/$script_name"
        fi
    fi
done

# Also add bin directory to PATH if it exists
if [ -d "$DEV_SHORTCUTS_DIR/bin" ]; then
    BIN_PATH_ENTRY="export PATH=\"\$PATH:$DEV_SHORTCUTS_DIR/bin\""
    if ! grep -Fxq "$BIN_PATH_ENTRY" "$BASHRC" 2>/dev/null; then
        echo "$BIN_PATH_ENTRY" >> "$BASHRC"
        print_success "Added bin directory to PATH"
    fi
fi

# Source smart_git_add.sh function and create aliases
print_status "Setting up smart_git_add function..."
SMART_GIT_ADD_MARKER="# Added by dev-shortcuts - smart_git_add function"
if ! grep -Fxq "$SMART_GIT_ADD_MARKER" "$BASHRC" 2>/dev/null; then
    echo "" >> "$BASHRC"
    echo "$SMART_GIT_ADD_MARKER" >> "$BASHRC"
    echo "source $DEV_SHORTCUTS_DIR/git-setup/smart_git_add.sh" >> "$BASHRC"
    echo "alias ga='smart_git_add'" >> "$BASHRC"
    echo "alias git-add-smart='smart_git_add'" >> "$BASHRC"
    print_success "Added smart_git_add function and aliases to .bashrc"
fi

# Git setup integration
print_status "Setting up git configuration..."
GIT_SETUP_DIR="$DEV_SHORTCUTS_DIR/git-setup"

if [ -d "$GIT_SETUP_DIR" ]; then
    # Install git-alias-help.sh symlink
    if [ -f "$GIT_SETUP_DIR/git-alias-help.sh" ]; then
        if [ ! -L "$DEV_SHORTCUTS_DIR/bin/git-alias-help.sh" ]; then
            ln -sf "$GIT_SETUP_DIR/git-alias-help.sh" "$DEV_SHORTCUTS_DIR/bin/git-alias-help.sh"
            print_success "Created symlink for git-alias-help.sh"
        fi
    fi
    
    # Install git config (merge with existing)
    if [ -f "$GIT_SETUP_DIR/.gitconfig" ]; then
        GITCONFIG="$HOME/.gitconfig"
        GITCONFIG_MARKER="# Added by dev-shortcuts git-setup"
        
        if [ -f "$GITCONFIG" ]; then
            # Check if git-setup aliases are already in .gitconfig
            if ! grep -q "$GITCONFIG_MARKER" "$GITCONFIG" 2>/dev/null; then
                print_status "Merging git aliases into existing .gitconfig..."
                # Extract [alias] section from git-setup (everything from [alias] to end or next [section])
                awk '/^\[alias\]/,/^\[/ {if (/^\[/ && !/^\[alias\]/) exit; print}' "$GIT_SETUP_DIR/.gitconfig" > /tmp/git-aliases.tmp
                # Remove the last line if it's a new section header
                sed -i '$ { /^\[/d }' /tmp/git-aliases.tmp 2>/dev/null || true
                # Append to existing .gitconfig
                echo "" >> "$GITCONFIG"
                echo "$GITCONFIG_MARKER" >> "$GITCONFIG"
                cat /tmp/git-aliases.tmp >> "$GITCONFIG"
                rm -f /tmp/git-aliases.tmp
                print_success "Merged git aliases into .gitconfig"
            else
                print_warning "Git aliases already in .gitconfig (skipping merge)"
            fi
        else
            # No existing .gitconfig, copy the whole thing
            cp "$GIT_SETUP_DIR/.gitconfig" "$GITCONFIG"
            echo "" >> "$GITCONFIG"
            echo "$GITCONFIG_MARKER" >> "$GITCONFIG"
            print_success "Installed .gitconfig"
        fi
    fi
    
    # Add git-setup bashrc portion (with updated paths)
    print_status "Adding git-setup bashrc integration..."
    GIT_BASHRC_MARKER="# Added by dev-shortcuts git-setup"
    if ! grep -Fxq "$GIT_BASHRC_MARKER" "$BASHRC" 2>/dev/null; then
        echo "" >> "$BASHRC"
        echo "$GIT_BASHRC_MARKER" >> "$BASHRC"
        
        # Read bashrc-git-portion.txt and update paths
        if [ -f "$GIT_SETUP_DIR/bashrc-git-portion.txt" ]; then
            # Replace /home/pharoh/bin with dev-shortcuts/bin
            sed "s|/home/pharoh/bin|$DEV_SHORTCUTS_DIR/bin|g" "$GIT_SETUP_DIR/bashrc-git-portion.txt" >> "$BASHRC"
            print_success "Added git-setup bashrc integration"
        fi
    else
        print_warning "Git-setup bashrc integration already exists"
    fi
fi

print_header "Installation Complete!"
echo ""
print_success "dev-shortcuts has been added to your PATH"
echo ""
print_status "To use the scripts immediately, run:"
echo -e "  ${CYAN}source ~/.bashrc${NC}"
echo ""
print_status "Or open a new terminal session."
echo ""
print_status "You can now run scripts from anywhere, for example:"
echo -e "  ${CYAN}update.sh${NC}"
echo -e "  ${CYAN}update-vscode.sh${NC}"
echo -e "  ${CYAN}update-cursor.sh${NC}"
echo -e "  ${CYAN}git_commit_with_type.sh${NC}"
echo -e "  ${CYAN}docker-cleanup.sh${NC}  (from bin directory)"
echo -e "  ${CYAN}system-info.sh${NC}     (from bin directory)"
echo ""
print_status "Git shortcuts available:"
echo -e "  ${CYAN}smart_git_add${NC} or ${CYAN}ga${NC} - Smart git add function"
echo -e "  ${CYAN}githelp${NC} - Show git alias cheat sheet"
echo -e "  ${CYAN}git st${NC}, ${CYAN}git br${NC}, ${CYAN}git timeline${NC}, etc. - Git aliases"
echo ""

