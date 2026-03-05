#!/bin/bash

# System Information Script
# Author: ZRW
# Description: Display comprehensive system information

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}=== $1 ===${NC}"
}

print_info() {
    echo -e "${BLUE}$1:${NC} $2"
}

main() {
    clear
    echo -e "${GREEN}System Information Report${NC}"
    echo "Generated: $(date)"
    echo ""
    
    # System Information
    print_header "System Information"
    print_info "Hostname" "$(hostname)"
    print_info "OS" "$(lsb_release -d | cut -f2)"
    print_info "Kernel" "$(uname -r)"
    print_info "Architecture" "$(uname -m)"
    print_info "Uptime" "$(uptime -p)"
    echo ""
    
    # CPU Information
    print_header "CPU Information"
    cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//')
    cpu_cores=$(nproc)
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d% -f1)
    
    print_info "Model" "$cpu_model"
    print_info "Cores" "$cpu_cores"
    print_info "Usage" "${cpu_usage}%"
    echo ""
    
    # Memory Information
    print_header "Memory Information"
    mem_total=$(free -h | awk '/^Mem:/ {print $2}')
    mem_used=$(free -h | awk '/^Mem:/ {print $3}')
    mem_free=$(free -h | awk '/^Mem:/ {print $4}')
    mem_percent=$(free | awk '/^Mem:/ {printf "%.1f", ($3/$2) * 100}')
    
    print_info "Total" "$mem_total"
    print_info "Used" "$mem_used (${mem_percent}%)"
    print_info "Free" "$mem_free"
    echo ""
    
    # Disk Usage
    print_header "Disk Usage"
    df -h | grep -E '^/dev/' | while read filesystem size used avail percent mount; do
        print_info "$mount" "$used/$size ($percent)"
    done
    echo ""
    
    # Network Interfaces
    print_header "Network Interfaces"
    ip addr show | grep -E '^[0-9]+:' | while read line; do
        interface=$(echo $line | cut -d: -f2 | sed 's/^ *//')
        ip_addr=$(ip addr show $interface | grep 'inet ' | awk '{print $2}' | head -1)
        if [ ! -z "$ip_addr" ]; then
            print_info "$interface" "$ip_addr"
        fi
    done
    echo ""
    
    # Process Information
    print_header "Top 5 CPU Processes"
    ps aux --sort=-%cpu | head -6 | tail -5 | while read line; do
        user=$(echo $line | awk '{print $1}')
        cpu=$(echo $line | awk '{print $3}')
        command=$(echo $line | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | cut -c1-50)
        echo -e "${BLUE}$user${NC} - ${YELLOW}${cpu}%${NC} - $command"
    done
    echo ""
    
    # System Load
    print_header "System Load"
    load=$(uptime | awk -F'load average:' '{print $2}')
    print_info "Load Average" "$load"
    echo ""
}

main "$@"
