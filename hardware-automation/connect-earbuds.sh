#!/bin/bash

# Enhanced Bluetooth Earbuds Connection Script
# Author: ZRW
# Description: Comprehensive script to connect Redmi Buds 6 Play (Onaji)
# Original from: Bluetooth Troubleshooting project

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Device configuration - Redmi Buds 6 Play
# EARBUD_MAC="A4:05:6E:F7:05:95"
EARBUD_MAC="54:84:50:20:AD:F9"
EARBUD_NAME="Onaji"
MAX_RETRIES=3

# Log with timestamp
log() {
    echo -e "[$(date '+%H:%M:%S')] $1"
}

# Success message
success() {
    log "${GREEN}✓ $1${NC}"
}

# Warning message
warning() {
    log "${YELLOW}⚠ $1${NC}"
}

# Error message
error() {
    log "${RED}✗ $1${NC}"
}

# Info message
info() {
    log "${BLUE}ℹ $1${NC}"
}

# Header function
show_header() {
    clear
    echo -e "${CYAN}======================================================${NC}"
    echo -e "${CYAN}     ZRW's Bluetooth Earbuds Connection Script      ${NC}"
    echo -e "${CYAN}======================================================${NC}"
    echo -e "${BLUE}Device:${NC} $EARBUD_NAME"
    echo -e "${BLUE}MAC:${NC} $EARBUD_MAC"
    echo -e "${CYAN}======================================================${NC}"
    echo ""
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
       error "This script must be run as root (sudo)"
       info "Usage: sudo $0"
       exit 1
    fi
}

# Check Bluetooth service
check_bluetooth_service() {
    info "Checking Bluetooth service..."
    if systemctl is-active --quiet bluetooth; then
        success "Bluetooth service is running"
    else
        warning "Bluetooth service is not running. Starting it..."
        systemctl start bluetooth
        sleep 2
        if systemctl is-active --quiet bluetooth; then
            success "Bluetooth service started successfully"
        else
            error "Failed to start Bluetooth service"
            exit 1
        fi
    fi
}

# Check RF-kill status
check_rfkill() {
    info "Checking if Bluetooth is blocked..."
    if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
        warning "Bluetooth is soft-blocked. Unblocking..."
        rfkill unblock bluetooth
        sleep 1
        success "Bluetooth unblocked"
    elif rfkill list bluetooth | grep -q "Hard blocked: yes"; then
        error "Bluetooth is hard-blocked. Please check physical switch or BIOS settings"
        exit 1
    else
        success "Bluetooth is not blocked"
    fi
}

# Restart Bluetooth service
restart_bluetooth() {
    info "Restarting Bluetooth service for a clean state..."
    systemctl restart bluetooth
    sleep 3
    success "Bluetooth service restarted"
}

# Activate Bluetooth adapter
activate_adapter() {
    info "Activating Bluetooth adapter..."
    if hciconfig hci0 up 2>/dev/null; then
        success "Bluetooth adapter activated"
    else
        error "Failed to activate Bluetooth adapter"
        info "Trying to resolve..."
        
        # Try restarting the service again
        systemctl restart bluetooth
        sleep 3
        if hciconfig hci0 up 2>/dev/null; then
            success "Bluetooth adapter activated after service restart"
        else
            error "Could not activate Bluetooth adapter. Please check hardware"
            exit 1
        fi
    fi
}

# Remove existing pairing
remove_existing_pairing() {
    info "Checking if device was previously paired..."
    if echo "info $EARBUD_MAC" | bluetoothctl 2>&1 | grep -q "Device $EARBUD_MAC"; then
        info "Device previously paired. Removing for a clean connection..."
        echo -e "remove $EARBUD_MAC\nquit" | bluetoothctl > /dev/null 2>&1
        sleep 2
        success "Previous pairing removed"
    else
        info "No previous pairing found"
    fi
}

# Wait for user confirmation
wait_for_pairing_mode() {
    echo ""
    info "Please prepare your earbuds for pairing:"
    info "1. Put earbuds in charging case"
    info "2. Take them out while holding both touch buttons"
    info "3. Wait for pairing mode indicator (usually blinking light)"    
    echo ""
    read -p "Press Enter when earbuds are in pairing mode..." -r
    echo ""
}

# Attempt connection
attempt_connection() {
    local attempt=$1
    info "Connection attempt $attempt of $MAX_RETRIES..."
    
    # Run bluetoothctl with comprehensive commands
    (
        echo "power off"
        sleep 1
        echo "power on"
        sleep 2
        echo "agent on"
        sleep 1
        echo "default-agent"
        sleep 1
        echo "scan on"
        sleep 10  # Longer scan time
        echo "scan off"
        sleep 1
        echo "pair $EARBUD_MAC"
        sleep 5   # Give more time for pairing
        echo "trust $EARBUD_MAC"
        sleep 2
        echo "connect $EARBUD_MAC"
        sleep 8   # Give more time for connection
        echo "quit"
    ) | bluetoothctl > /tmp/bt_output_$attempt.log 2>&1
    
    # Check connection result with multiple methods
    if grep -q "Connection successful" /tmp/bt_output_$attempt.log || 
       grep -q "Connected: yes" /tmp/bt_output_$attempt.log; then
        return 0  # Success
    fi
    
    # Secondary verification
    if echo "info $EARBUD_MAC" | bluetoothctl 2>&1 | grep -q "Connected: yes"; then
        return 0  # Success
    fi
    
    # Delay before next attempt
    sleep 3
    return 1  # Failed
}

# Set audio profile
set_audio_profile() {
    info "Checking audio profile..."
    sleep 3  # Give time for audio service to detect the new device
    
    # Try to find the card using different methods
    CARD_NAME=$(pactl list cards short 2>/dev/null | grep -i bluetooth | awk '{print $2}')
    if [ -z "$CARD_NAME" ]; then
        CARD_NAME=$(pactl list cards short 2>/dev/null | grep -i bluez | awk '{print $2}')
    fi
    
    if [ -n "$CARD_NAME" ]; then
        # Try to set A2DP profile
        info "Setting A2DP profile for better audio quality..."
        if pactl set-card-profile "$CARD_NAME" a2dp_sink 2>/dev/null; then
            success "A2DP profile set successfully"
        else
            warning "Could not set A2DP profile automatically"
            info "Trying alternative method..."
            
            # List available profiles
            PROFILES=$(pactl list cards | grep -A 20 "Name: $CARD_NAME" | grep "output:" | grep -v "off" | head -1 | awk '{print $1}' | tr -d ':')
            
            if [ -n "$PROFILES" ]; then
                if pactl set-card-profile "$CARD_NAME" "$PROFILES" 2>/dev/null; then
                    success "Audio profile set to $PROFILES"
                else
                    warning "Could not set audio profile automatically"
                    info "You may need to set the audio profile manually in sound settings"
                fi
            fi
        fi
    else
        warning "No Bluetooth audio card found yet"
        info "If the earbuds are connected but no audio, wait a few seconds and try:"
        info "  pactl set-card-profile bluez_card.$(echo $EARBUD_MAC | tr ':' '_') a2dp_sink"
    fi
}

# Show troubleshooting info
show_troubleshooting() {
    echo ""
    echo -e "${CYAN}======================================================${NC}"
    error "Failed to connect to earbuds after multiple attempts"
    echo -e "${CYAN}======================================================${NC}"
    info "Troubleshooting steps:"
    info "1. Make sure earbuds are in pairing mode"
    info "2. Restart your earbuds (put in case, take out)"
    info "3. Try disabling and re-enabling Bluetooth on your computer"
    info "4. Check if earbuds are connected to another device"
    info "5. Try manual connection with bluetoothctl:"
    info "   $ sudo bluetoothctl"
    info "   [bluetooth]# remove $EARBUD_MAC"
    info "   [bluetooth]# scan on"
    info "   [bluetooth]# pair $EARBUD_MAC"
    info "   [bluetooth]# trust $EARBUD_MAC"
    info "   [bluetooth]# connect $EARBUD_MAC"
    echo -e "${CYAN}======================================================${NC}"
}

# Main function
main() {
    show_header
    check_root
    check_bluetooth_service
    check_rfkill
    restart_bluetooth
    activate_adapter
    remove_existing_pairing
    wait_for_pairing_mode
    
    # Try connection attempts
    success=false
    for ((i=1; i<=MAX_RETRIES; i++)); do
        if attempt_connection $i; then
            success=true
            success "Successfully connected to earbuds on attempt $i!"
            break
        else
            warning "Connection attempt $i failed"
        fi
    done
    
    if [ "$success" = true ]; then
        set_audio_profile
        echo ""
        echo -e "${CYAN}======================================================${NC}"
        success "Connection process completed successfully!"
        info "Your Redmi Buds 6 Play should now be connected and ready to use"
        echo -e "${CYAN}======================================================${NC}"
    else
        show_troubleshooting
    fi
    
    # Clean up temporary files
    rm -f /tmp/bt_output_*.log 2>/dev/null
}

# Run main function
main "$@"
