#!/bin/bash

# Comprehensive System Update Script
# Author: ZRW
# Description: Interactive system update script combining original functionality with enhanced features

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check reboot requirement
check_reboot() {
    if [ -f /var/run/reboot-required ]; then
        print_warning "System reboot is required!"
        echo -e "${YELLOW}Run 'sudo reboot' when convenient.${NC}"
    fi
}

# Individual update functions (matching original script)
update_only() {
    print_status "Updating package lists..."
    sudo apt-get update
    print_success "Package lists updated!"
    check_reboot
}

upgrade_only() {
    print_status "Performing full upgrade..."
    sudo apt-get full-upgrade
    print_success "System upgrade completed!"
    check_reboot
}

autoclean_only() {
    print_status "Cleaning package cache..."
    sudo apt autoclean
    print_success "Package cache cleaned!"
}

autoremove_only() {
    print_status "Removing unnecessary packages..."
    sudo apt autoremove
    print_success "Unnecessary packages removed!"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Update Cursor AppImage
update_cursor() {
    print_status "Updating Cursor AppImage..."
    if [ -f "$SCRIPT_DIR/update-cursor.sh" ]; then
        bash "$SCRIPT_DIR/update-cursor.sh"
    else
        print_error "update-cursor.sh not found in $SCRIPT_DIR"
    fi
}

# Update VS Code
update_vscode() {
    print_status "Updating VS Code..."
    if [ -f "$SCRIPT_DIR/update-vscode.sh" ]; then
        bash "$SCRIPT_DIR/update-vscode.sh"
    else
        print_error "update-vscode.sh not found in $SCRIPT_DIR"
    fi
}

# Enhanced "All" function - comprehensive system update
all_updates() {
    print_status "Starting comprehensive system update..."
    
    # Original script functionality: update && upgrade, autoclean && autoremove
    print_status "Updating package lists and upgrading packages..."
    sudo apt-get update && sudo apt-get upgrade -y
    
    print_status "Cleaning up packages..."
    sudo apt autoclean && sudo apt autoremove -y
    
    # Enhanced features: additional package managers
    if command_exists snap; then
        print_status "Updating snap packages..."
        sudo snap refresh
    fi
    
    if command_exists flatpak; then
        print_status "Updating flatpak packages..."
        flatpak update -y
    fi
    
    if command_exists npm; then
        print_status "Updating global npm packages..."
        npm update -g 2>/dev/null || print_warning "Some npm packages may need manual update"
    fi
    
    if command_exists pip3; then
        print_status "Updating pip packages..."
        pip3 list --outdated --format=freeze 2>/dev/null | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 2>/dev/null || print_warning "Some pip packages may need manual update"
    fi
    
    print_success "Comprehensive system update completed!"
    check_reboot
}

# Main menu function (enhanced version of original)
show_menu() {
    clear
    print_header "ZRW's System Update Menu"
    echo -e "${GREEN}1.${NC} Update"
    echo -e "${GREEN}2.${NC} Upgrade"
    echo -e "${GREEN}3.${NC} Autoclean"
    echo -e "${GREEN}4.${NC} Autoremove"
    echo -e "${GREEN}5.${NC} All (Comprehensive Update)"
    echo -e "${GREEN}6.${NC} Update Cursor"
    echo -e "${GREEN}7.${NC} Update VS Code"
    echo -e "${GREEN}8.${NC} Exit"
    echo ""
}

# Main program (preserving original logic structure)
main() {
    while true; do
        show_menu
        read -p "Choose command number: " command
        echo ""
        
        case $command in
            "1")
                update_only
                ;;
            "2")
                upgrade_only
                ;;
            "3")
                autoclean_only
                ;;
            "4")
                autoremove_only
                ;;
            "5")
                all_updates
                ;;
            "6")
                update_cursor
                ;;
            "7")
                update_vscode
                ;;
            "8")
                print_success "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please select 1-8."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
