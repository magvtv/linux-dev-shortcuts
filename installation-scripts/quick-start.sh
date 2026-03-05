#!/bin/bash

# Quick Start Script for dev-shortcuts
# Interactive installation guide
# Author: ZRW

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print functions
print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                   ║"
    echo "║           ${BOLD}ZRW's Dev Shortcuts - Quick Start${NC}${CYAN}                  ║"
    echo "║                                                                   ║"
    echo "║         ${NC}${GREEN}Make your scripts accessible from anywhere!${NC}${CYAN}            ║"
    echo "║                                                                   ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_header() {
    echo ""
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════${NC}"
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

print_tip() {
    echo -e "${CYAN}[💡]${NC} ${BOLD}Tip:${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"

    local all_good=true

    # Check if we're in the right directory
    if [ ! -f "$SCRIPT_DIR/install-system-wide-enhanced.sh" ]; then
        print_error "Cannot find installation scripts in current directory"
        print_status "Please run this script from the dev-shortcuts directory"
        all_good=false
    else
        print_success "Found installation scripts"
    fi

    # Check bash
    if command -v bash >/dev/null 2>&1; then
        print_success "Bash is installed"
    else
        print_error "Bash is not installed"
        all_good=false
    fi

    # Check if .bashrc exists
    if [ -f "$HOME/.bashrc" ]; then
        print_success "Found .bashrc"
    else
        print_warning ".bashrc not found (will be created)"
    fi

    # Check write permissions for /usr/local/bin
    if [ -w "/usr/local/bin" ]; then
        print_success "Have write access to /usr/local/bin"
    else
        print_warning "Will need sudo for enhanced installation"
    fi

    echo ""

    if [ "$all_good" = false ]; then
        print_error "Prerequisites check failed"
        exit 1
    fi
}

# Show installation options
show_installation_menu() {
    print_banner
    print_header "Choose Installation Method"

    echo -e "${GREEN}1.${NC} ${BOLD}Enhanced Installation${NC} ${CYAN}(Recommended)${NC}"
    echo "   • Installs to /usr/local/bin for true system-wide access"
    echo "   • Scripts work from ANY directory (including /projects)"
    echo "   • Works for all users on the system"
    echo "   • Requires sudo privileges"
    echo ""

    echo -e "${GREEN}2.${NC} ${BOLD}PATH-based Installation${NC}"
    echo "   • Adds dev-shortcuts directory to your PATH"
    echo "   • Scripts run directly from dev-shortcuts directory"
    echo "   • No sudo required"
    echo "   • Good for single-user setups"
    echo ""

    echo -e "${GREEN}3.${NC} ${BOLD}Show More Info${NC}"
    echo "   • Learn more about each installation method"
    echo ""

    echo -e "${GREEN}4.${NC} ${BOLD}Exit${NC}"
    echo ""
}

# Show detailed information
show_detailed_info() {
    print_banner
    print_header "Installation Methods Explained"

    echo -e "${CYAN}${BOLD}Enhanced Installation:${NC}"
    echo "This method creates wrapper scripts in /usr/local/bin that point to"
    echo "your dev-shortcuts scripts. This is the standard Linux way to install"
    echo "system-wide commands."
    echo ""
    echo -e "${GREEN}Pros:${NC}"
    echo "  ✓ Scripts work from any partition (/projects, /home, /tmp, etc.)"
    echo "  ✓ Scripts work for all users (if run with sudo)"
    echo "  ✓ Standard location that's always in PATH"
    echo "  ✓ Updates automatically (wrappers point to latest version)"
    echo ""
    echo -e "${YELLOW}Cons:${NC}"
    echo "  ✗ Requires sudo privileges"
    echo ""
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${CYAN}${BOLD}PATH-based Installation:${NC}"
    echo "This method adds the dev-shortcuts directory to your shell's PATH"
    echo "environment variable. Scripts run directly from the directory."
    echo ""
    echo -e "${GREEN}Pros:${NC}"
    echo "  ✓ No sudo required"
    echo "  ✓ Simple and straightforward"
    echo "  ✓ Easy to modify scripts"
    echo ""
    echo -e "${YELLOW}Cons:${NC}"
    echo "  ✗ Only works for current user"
    echo "  ✗ Slightly slower (longer PATH)"
    echo ""

    echo ""
    read -p "Press Enter to return to menu..."
}

# Perform enhanced installation
do_enhanced_install() {
    print_banner
    print_header "Enhanced Installation"

    print_status "This will install scripts to /usr/local/bin"
    print_warning "You will be prompted for your sudo password"
    echo ""

    read -p "Continue? (yes/no): " confirm
    if [[ ! "$confirm" =~ ^[Yy][Ee][Ss]$ ]]; then
        print_status "Installation cancelled"
        return
    fi

    echo ""
    print_status "Starting enhanced installation..."
    echo ""

    if [ -f "$SCRIPT_DIR/install-system-wide-enhanced.sh" ]; then
        sudo "$SCRIPT_DIR/install-system-wide-enhanced.sh"

        echo ""
        print_success "Installation completed!"
        echo ""
        print_tip "Reload your shell: ${CYAN}source ~/.bashrc${NC}"
        echo ""

        show_test_commands
    else
        print_error "install-system-wide-enhanced.sh not found!"
        exit 1
    fi

    read -p "Press Enter to continue..."
}

# Perform PATH-based installation
do_path_install() {
    print_banner
    print_header "PATH-based Installation"

    print_status "This will add dev-shortcuts to your PATH"
    echo ""

    read -p "Continue? (yes/no): " confirm
    if [[ ! "$confirm" =~ ^[Yy][Ee][Ss]$ ]]; then
        print_status "Installation cancelled"
        return
    fi

    echo ""
    print_status "Starting PATH-based installation..."
    echo ""

    if [ -f "$SCRIPT_DIR/install-system-wide.sh" ]; then
        "$SCRIPT_DIR/install-system-wide.sh"

        echo ""
        print_success "Installation completed!"
        echo ""
        print_tip "Reload your shell: ${CYAN}source ~/.bashrc${NC}"
        echo ""

        show_test_commands
    else
        print_error "install-system-wide.sh not found!"
        exit 1
    fi

    read -p "Press Enter to continue..."
}

# Show test commands
show_test_commands() {
    print_header "Testing Your Installation"

    echo -e "${CYAN}Try these commands to verify installation:${NC}"
    echo ""
    echo -e "  ${GREEN}which update.sh${NC}"
    echo "  Should show: /usr/local/bin/update.sh (or dev-shortcuts path)"
    echo ""
    echo -e "  ${GREEN}update.sh${NC}"
    echo "  Should open the interactive update menu"
    echo ""
    echo -e "  ${GREEN}system-info.sh${NC}"
    echo "  Should display system information"
    echo ""
    echo -e "  ${GREEN}cd /tmp && update.sh${NC}"
    echo "  Should work from any directory"
    echo ""
}

# Show what's available
show_available_scripts() {
    print_banner
    print_header "Available Scripts After Installation"

    echo -e "${CYAN}${BOLD}Main System Scripts:${NC}"
    echo -e "  ${GREEN}update.sh${NC}              - Interactive system update menu"
    echo -e "  ${GREEN}system-info.sh${NC}         - Display system information"
    echo -e "  ${GREEN}update-cursor.sh${NC}       - Update Cursor AppImage"
    echo -e "  ${GREEN}update-vscode.sh${NC}       - Update VS Code"
    echo -e "  ${GREEN}update-original.sh${NC}     - Original update script"
    echo ""

    echo -e "${CYAN}${BOLD}Git Shortcuts:${NC}"
    echo -e "  ${GREEN}ga${NC} or ${GREEN}smart_git_add${NC}  - Interactive git add"
    echo -e "  ${GREEN}githelp${NC}                - Show git alias cheat sheet"
    echo -e "  ${GREEN}git_commit_with_type.sh${NC} - Interactive commit helper"
    echo ""

    echo -e "${CYAN}${BOLD}Development Tools:${NC}"
    echo -e "  ${GREEN}docker-cleanup.sh${NC}      - Docker cleanup utilities"
    echo -e "  ${GREEN}setup-node-project.sh${NC}  - Node.js project setup"
    echo -e "  ${GREEN}connect-earbuds.sh${NC}     - Bluetooth connection helper"
    echo ""

    echo -e "${CYAN}${BOLD}Usage Examples:${NC}"
    echo -e "  ${YELLOW}cd /projects/my-app && update.sh${NC}"
    echo -e "  ${YELLOW}system-info.sh${NC}"
    echo -e "  ${YELLOW}ga${NC}  (smart git add)"
    echo ""

    read -p "Press Enter to return to menu..."
}

# Main menu loop
main() {
    check_prerequisites

    while true; do
        show_installation_menu

        read -p "Choose an option (1-4): " choice

        case $choice in
            1)
                do_enhanced_install
                ;;
            2)
                do_path_install
                ;;
            3)
                show_detailed_info
                ;;
            4)
                print_banner
                print_success "Thank you for using dev-shortcuts!"
                echo ""
                print_tip "For more info, see: ${CYAN}SYSTEM-WIDE-INSTALL.md${NC}"
                echo ""
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please select 1-4."
                sleep 2
                ;;
        esac
    done
}

# Show available scripts if --help
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    print_banner
    show_available_scripts
    exit 0
fi

# Run main menu
main "$@"
