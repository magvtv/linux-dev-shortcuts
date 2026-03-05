#!/bin/bash

# Uninstall Script for dev-shortcuts System-Wide Installation
# This script removes dev-shortcuts from system-wide access
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

INSTALL_DIR="/usr/local/bin"
BASHRC="$HOME/.bashrc"
PROFILE="$HOME/.profile"
GITCONFIG="$HOME/.gitconfig"

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

# Confirm uninstallation
confirm_uninstall() {
    print_header "dev-shortcuts Uninstaller"

    echo -e "${YELLOW}This will remove:${NC}"
    echo -e "  • Script wrappers from $INSTALL_DIR"
    echo -e "  • PATH entries from .bashrc and .profile"
    echo -e "  • Git configuration entries"
    echo -e "  • Shell integration (smart_git_add, etc.)"
    echo ""
    echo -e "${RED}WARNING: This action cannot be undone!${NC}"
    echo ""

    read -p "Are you sure you want to uninstall? (yes/no): " confirm

    if [[ ! "$confirm" =~ ^[Yy][Ee][Ss]$ ]]; then
        print_status "Uninstallation cancelled."
        exit 0
    fi
}

# Remove scripts from /usr/local/bin
remove_scripts() {
    print_header "Removing Scripts from $INSTALL_DIR"

    local removed=0
    local scripts=(
        "update.sh"
        "update-cursor.sh"
        "update-vscode.sh"
        "update-original.sh"
        "system-info.sh"
        "git_commit_with_type.sh"
        "docker-cleanup.sh"
        "connect-earbuds.sh"
        "setup-node-project.sh"
    )

    for script in "${scripts[@]}"; do
        if [ -f "$INSTALL_DIR/$script" ]; then
            if [ -w "$INSTALL_DIR/$script" ]; then
                rm -f "$INSTALL_DIR/$script"
                print_success "Removed $script"
                ((removed++))
            else
                print_error "Cannot remove $script (permission denied)"
                print_status "Try running with sudo: sudo $0"
            fi
        fi
    done

    # Remove any other dev-shortcuts related scripts
    print_status "Scanning for additional dev-shortcuts scripts..."
    local found=0
    for script in "$INSTALL_DIR"/*.sh; do
        if [ -f "$script" ]; then
            # Check if it's a dev-shortcuts wrapper
            if grep -q "dev-shortcuts" "$script" 2>/dev/null; then
                if [ -w "$script" ]; then
                    rm -f "$script"
                    print_success "Removed $(basename "$script")"
                    ((removed++))
                    ((found++))
                fi
            fi
        fi
    done

    if [ $found -eq 0 ]; then
        print_status "No additional scripts found"
    fi

    print_success "Removed $removed scripts total"
}

# Clean up shell configuration
clean_shell_config() {
    print_header "Cleaning Shell Configuration"

    # Markers to look for
    local markers=(
        "# Added by dev-shortcuts install-system-wide-enhanced.sh"
        "# Added by dev-shortcuts install-system-wide.sh"
        "# Added by dev-shortcuts - smart_git_add"
        "# Added by dev-shortcuts git-setup"
    )

    # Clean .bashrc
    if [ -f "$BASHRC" ]; then
        print_status "Backing up .bashrc to .bashrc.backup..."
        cp "$BASHRC" "$BASHRC.backup"

        local temp_file=$(mktemp)
        local in_block=0

        while IFS= read -r line; do
            local skip=0
            for marker in "${markers[@]}"; do
                if [[ "$line" == "$marker" ]]; then
                    in_block=1
                    skip=1
                    break
                fi
            done

            # Skip lines containing dev-shortcuts paths
            if [[ "$line" =~ dev-shortcuts ]] && [ $in_block -eq 1 ]; then
                skip=1
            fi

            # Exit block on empty line or new comment
            if [ $in_block -eq 1 ] && [[ -z "$line" || ("$line" =~ ^[^#] && ! "$line" =~ dev-shortcuts) ]]; then
                in_block=0
            fi

            if [ $skip -eq 0 ]; then
                echo "$line" >> "$temp_file"
            fi
        done < "$BASHRC"

        mv "$temp_file" "$BASHRC"
        print_success "Cleaned .bashrc (backup saved)"
    fi

    # Clean .profile
    if [ -f "$PROFILE" ]; then
        print_status "Backing up .profile to .profile.backup..."
        cp "$PROFILE" "$PROFILE.backup"

        local temp_file=$(mktemp)
        local in_block=0

        while IFS= read -r line; do
            local skip=0
            for marker in "${markers[@]}"; do
                if [[ "$line" == "$marker" ]]; then
                    in_block=1
                    skip=1
                    break
                fi
            done

            if [[ "$line" =~ dev-shortcuts ]] && [ $in_block -eq 1 ]; then
                skip=1
            fi

            if [ $in_block -eq 1 ] && [[ -z "$line" || ("$line" =~ ^[^#] && ! "$line" =~ dev-shortcuts) ]]; then
                in_block=0
            fi

            if [ $skip -eq 0 ]; then
                echo "$line" >> "$temp_file"
            fi
        done < "$PROFILE"

        mv "$temp_file" "$PROFILE"
        print_success "Cleaned .profile (backup saved)"
    fi
}

# Clean git configuration
clean_git_config() {
    print_header "Cleaning Git Configuration"

    if [ -f "$GITCONFIG" ]; then
        if grep -q "# Added by dev-shortcuts" "$GITCONFIG" 2>/dev/null; then
            print_status "Backing up .gitconfig to .gitconfig.backup..."
            cp "$GITCONFIG" "$GITCONFIG.backup"

            local temp_file=$(mktemp)
            local in_block=0

            while IFS= read -r line; do
                if [[ "$line" == "# Added by dev-shortcuts"* ]]; then
                    in_block=1
                    continue
                fi

                # Exit block on empty line or new section
                if [ $in_block -eq 1 ] && [[ -z "$line" || "$line" =~ ^\[.*\]$ ]]; then
                    in_block=0
                fi

                if [ $in_block -eq 0 ]; then
                    echo "$line" >> "$temp_file"
                fi
            done < "$GITCONFIG"

            mv "$temp_file" "$GITCONFIG"
            print_success "Cleaned .gitconfig (backup saved)"
        else
            print_status "No dev-shortcuts entries found in .gitconfig"
        fi
    else
        print_status ".gitconfig not found (nothing to clean)"
    fi
}

# Display completion message
show_completion() {
    print_header "Uninstallation Complete"

    echo -e "${GREEN}✓${NC} dev-shortcuts has been removed from system-wide access"
    echo ""
    print_status "What was removed:"
    echo -e "  • Script wrappers from $INSTALL_DIR"
    echo -e "  • PATH entries from shell configuration"
    echo -e "  • Git configuration entries"
    echo ""
    print_status "Backup files created:"
    echo -e "  • ~/.bashrc.backup"
    echo -e "  • ~/.profile.backup"
    [ -f "$GITCONFIG.backup" ] && echo -e "  • ~/.gitconfig.backup"
    echo ""
    print_warning "To complete uninstallation, reload your shell:"
    echo -e "  ${CYAN}source ~/.bashrc${NC}"
    echo -e "  Or open a new terminal window"
    echo ""
    print_status "The dev-shortcuts directory has NOT been deleted."
    print_status "You can still run scripts directly from the directory."
    echo ""
}

# Main uninstallation process
main() {
    clear
    confirm_uninstall

    echo ""
    print_status "Starting uninstallation..."
    echo ""

    remove_scripts
    clean_shell_config
    clean_git_config
    show_completion

    print_success "Uninstallation completed successfully!"
    echo ""
}

# Run main function
main "$@"
