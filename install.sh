#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}==================================${NC}"
echo -e "${YELLOW}   Networking Tool Kit - Installer   ${NC}"
echo -e "${GREEN}==================================${NC}"

# List of required commands
deps=("ping" "traceroute" "netstat" "nslookup" "whois" "telnet" "ssh" "nc" "wget" "curl")
missing=()

echo "Checking dependencies..."
for cmd in "${deps[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $cmd"
    else
        echo -e "${RED}✗${NC} $cmd"
        missing+=("$cmd")
    fi
done

if [ ${#missing[@]} -eq 0 ]; then
    echo -e "\n${GREEN}All dependencies are installed!${NC}"
    echo "You can run ./networking_tool_kit.sh"
else
    echo -e "\n${YELLOW}Missing dependencies: ${missing[*]}${NC}"
    echo "Install them using your package manager:"
    echo "  Debian/Ubuntu: sudo apt install ${missing[*]}"
    echo "  RHEL/CentOS:   sudo yum install ${missing[*]}"
    echo "  Arch:          sudo pacman -S ${missing[*]}"
fi

# Make scripts executable
echo -e "\nSetting execute permissions..."
chmod +x networking_tool_kit.sh
chmod +x tools/*.sh 2>/dev/null

echo -e "${GREEN}Installation check complete!${NC}"
