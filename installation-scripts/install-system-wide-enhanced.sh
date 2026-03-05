#!/bin/bash

# Enhanced System-wide Installation Script for dev-shortcuts
# This script installs dev-shortcuts scripts to /usr/local/bin for system-wide access
# Works on all partitions including /projects
# Author: ZRW

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Get the absolute path of the dev-shortcuts directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEV_SHORTCUTS_DIR="$SCRIPT_DIR"
INSTALL_DIR="/usr/local/bin"
BASHRC="$HOME/.bashrc"
PROFILE="$HOME/.profile"

# Print functions
print_header() {
    echo ""
    echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}$1${NC}"
    echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if script is run with proper permissions
check_permissions() {
    if [ ! -w "$INSTALL_DIR" ]; then
        print_error "Cannot write to $INSTALL_DIR"
        print_status "Please run this script with sudo or as root"
        exit 1
    fi
}

# Verify dev-shortcuts directory
verify_directory() {
    if [ ! -d "$DEV_SHORTCUTS_DIR" ]; then
        print_error "dev-shortcuts directory not found at $DEV_SHORTCUTS_DIR"
        exit 1
    fi
    print_success "Found dev-shortcuts at: $DEV_SHORTCUTS_DIR"
}

# Create wrapper scripts in /usr/local/bin
create_wrapper() {
    local script_path="$1"
    local script_name="$2"
    local wrapper_path="$INSTALL_DIR/$script_name"

    print_status "Installing $script_name..."

    # Create wrapper script that calls the original
    cat > "$wrapper_path" << EOF
#!/bin/bash
# Auto-generated wrapper for $script_name
# Points to: $script_path
exec "$script_path" "\$@"
EOF

    chmod +x "$wrapper_path"
    print_success "Installed $script_name to $INSTALL_DIR"
}

# Install main scripts
install_scripts() {
    print_header "Installing Scripts to $INSTALL_DIR"

    # Priority scripts to install
    local -A SCRIPTS=(
        ["maintenance-scripts/update.sh"]="update.sh"
        ["maintenance-scripts/update-cursor.sh"]="update-cursor.sh"
        ["maintenance-scripts/update-vscode.sh"]="update-vscode.sh"
        ["maintenance-scripts/update-original.sh"]="update-original.sh"
        ["system-monitoring/system-info.sh"]="system-info.sh"
        ["bin/git_commit_with_type.sh"]="git_commit_with_type.sh"
    )

    # Install priority scripts
    for script_rel in "${!SCRIPTS[@]}"; do
        local script_path="$DEV_SHORTCUTS_DIR/$script_rel"
        local install_name="${SCRIPTS[$script_rel]}"

        if [ -f "$script_path" ]; then
            chmod +x "$script_path"
            create_wrapper "$script_path" "$install_name"
        else
            print_warning "Script not found: $script_path (skipping)"
        fi
    done

    # Install all other .sh scripts from subdirectories
    print_status "Scanning for additional scripts..."
    local count=0
    while IFS= read -r -d '' script; do
        local script_name=$(basename "$script")
        local script_path="$script"

        # Skip if already installed
        if [ -f "$INSTALL_DIR/$script_name" ]; then
            continue
        fi

        # Skip install script itself
        if [[ "$script_name" == "install-system-wide"* ]]; then
            continue
        fi

        chmod +x "$script_path"
        create_wrapper "$script_path" "$script_name"
        ((count++))
    done < <(find "$DEV_SHORTCUTS_DIR" -type f -name "*.sh" -print0)

    print_success "Installed $count additional scripts"
}

# Setup shell integration
setup_shell_integration() {
    print_header "Setting up Shell Integration"

    # Add dev-shortcuts directory to PATH for direct access
    local PATH_ENTRY="export PATH=\"\$PATH:$DEV_SHORTCUTS_DIR\""
    local PATH_MARKER="# Added by dev-shortcuts install-system-wide-enhanced.sh"

    # Update .bashrc
    if [ -f "$BASHRC" ]; then
        if ! grep -Fq "$PATH_MARKER" "$BASHRC" 2>/dev/null; then
            echo "" >> "$BASHRC"
            echo "$PATH_MARKER" >> "$BASHRC"
            echo "$PATH_ENTRY" >> "$BASHRC"
            print_success "Added to .bashrc"
        else
            print_warning ".bashrc already configured"
        fi
    fi

    # Update .profile
    if [ -f "$PROFILE" ]; then
        if ! grep -Fq "$PATH_MARKER" "$PROFILE" 2>/dev/null; then
            echo "" >> "$PROFILE"
            echo "$PATH_MARKER" >> "$PROFILE"
            echo "$PATH_ENTRY" >> "$PROFILE"
            print_success "Added to .profile"
        else
            print_warning ".profile already configured"
        fi
    fi

    # Setup smart_git_add if exists
    local SMART_GIT_ADD="$DEV_SHORTCUTS_DIR/git-setup/smart_git_add.sh"
    if [ -f "$SMART_GIT_ADD" ]; then
        local GIT_MARKER="# Added by dev-shortcuts - smart_git_add"
        if ! grep -Fq "$GIT_MARKER" "$BASHRC" 2>/dev/null; then
            echo "" >> "$BASHRC"
            echo "$GIT_MARKER" >> "$BASHRC"
            echo "source \"$SMART_GIT_ADD\"" >> "$BASHRC"
            echo "alias ga='smart_git_add'" >> "$BASHRC"
            echo "alias git-add-smart='smart_git_add'" >> "$BASHRC"
            print_success "Configured smart_git_add"
        fi
    fi
}

# Setup git configuration
setup_git_config() {
    print_header "Setting up Git Configuration"

    local GIT_SETUP_DIR="$DEV_SHORTCUTS_DIR/git-setup"
    local GITCONFIG="$HOME/.gitconfig"
    local GITCONFIG_MARKER="# Added by dev-shortcuts"

    if [ ! -d "$GIT_SETUP_DIR" ]; then
        print_warning "Git setup directory not found, skipping"
        return
    fi

    # Install git config if exists
    if [ -f "$GIT_SETUP_DIR/.gitconfig" ]; then
        if [ -f "$GITCONFIG" ]; then
            if ! grep -q "$GITCONFIG_MARKER" "$GITCONFIG" 2>/dev/null; then
                print_status "Merging git aliases into .gitconfig..."
                echo "" >> "$GITCONFIG"
                echo "$GITCONFIG_MARKER" >> "$GITCONFIG"
                awk '/^\[alias\]/,/^\[/ {if (/^\[/ && !/^\[alias\]/) exit; print}' "$GIT_SETUP_DIR/.gitconfig" >> "$GITCONFIG"
                print_success "Merged git configuration"
            else
                print_warning "Git configuration already merged"
            fi
        else
            cp "$GIT_SETUP_DIR/.gitconfig" "$GITCONFIG"
            print_success "Installed .gitconfig"
        fi
    fi

    # Add git bashrc integration
    if [ -f "$GIT_SETUP_DIR/bashrc-git-portion.txt" ]; then
        local GIT_BASHRC_MARKER="# Added by dev-shortcuts git-setup"
        if ! grep -Fq "$GIT_BASHRC_MARKER" "$BASHRC" 2>/dev/null; then
            echo "" >> "$BASHRC"
            echo "$GIT_BASHRC_MARKER" >> "$BASHRC"
            sed "s|/home/pharoh/bin|$INSTALL_DIR|g" "$GIT_SETUP_DIR/bashrc-git-portion.txt" >> "$BASHRC"
            print_success "Added git bashrc integration"
        fi
    fi
}

# Verify installation
verify_installation() {
    print_header "Verifying Installation"

    local verified=0
    local failed=0

    for script in "update.sh" "system-info.sh" "update-cursor.sh" "update-vscode.sh"; do
        if command -v "$script" >/dev/null 2>&1; then
            print_success "$script is available in PATH"
            ((verified++))
        elif [ -f "$INSTALL_DIR/$script" ]; then
            print_success "$script is installed in $INSTALL_DIR"
            ((verified++))
        else
            print_error "$script installation verification failed"
            ((failed++))
        fi
    done

    echo ""
    print_status "Verified: $verified scripts"
    if [ $failed -gt 0 ]; then
        print_warning "Failed: $failed scripts"
    fi
}

# Display usage information
show_usage_info() {
    print_header "Installation Complete!"

    echo -e "${GREEN}✓${NC} Scripts are now available system-wide from any directory"
    echo -e "${GREEN}✓${NC} Works on all partitions including ${CYAN}/projects${NC}"
    echo ""

    print_status "Available Commands (run from anywhere):"
    echo ""
    echo -e "  ${CYAN}update.sh${NC}              - Interactive system update menu"
    echo -e "  ${CYAN}system-info.sh${NC}         - Display comprehensive system information"
    echo -e "  ${CYAN}update-cursor.sh${NC}       - Update Cursor AppImage"
    echo -e "  ${CYAN}update-vscode.sh${NC}       - Update VS Code"
    echo -e "  ${CYAN}update-original.sh${NC}     - Original update script"
    echo -e "  ${CYAN}git_commit_with_type.sh${NC} - Interactive git commit helper"
    echo ""

    print_status "Git Shortcuts (if configured):"
    echo ""
    echo -e "  ${CYAN}ga${NC} or ${CYAN}smart_git_add${NC}  - Smart git add with interactive selection"
    echo -e "  ${CYAN}githelp${NC}                - Display git alias cheat sheet"
    echo ""

    print_status "To use immediately in current shell:"
    echo -e "  ${YELLOW}source ~/.bashrc${NC}"
    echo ""

    print_status "Or simply open a new terminal window"
    echo ""

    print_status "Examples:"
    echo -e "  ${CYAN}cd /projects/my-project && update.sh${NC}"
    echo -e "  ${CYAN}cd /anywhere/you/want && system-info.sh${NC}"
    echo ""
}

# Main installation process
main() {
    clear
    print_header "dev-shortcuts System-Wide Installation (Enhanced)"

    print_status "Installation directory: $INSTALL_DIR"
    print_status "Source directory: $DEV_SHORTCUTS_DIR"
    echo ""

    # Run installation steps
    verify_directory
    check_permissions
    install_scripts
    setup_shell_integration
    setup_git_config
    verify_installation
    show_usage_info

    print_success "Installation completed successfully!"
    echo ""
}

# Run main function
main "$@"
