#!/bin/bash

# --- Color Definitions ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 
BOLD='\033[1m'

# --- UI Header ---
clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${CYAN}${BOLD}      📊 DISK STORAGE MONITOR v1.0       ${NC}"
echo -e "${BLUE}==========================================${NC}"

# --- Logic ---
echo -e "${BLUE}[*] Scanning filesystem...${NC}"
disk_usage=$(df / --output=pcent | sed -n "2p" | cut -d "%" -f 1)

# --- Output & Notification ---
echo -e "${CYAN}Current Disk Usage: ${BOLD}${disk_usage}%${NC}"

if (( disk_usage >= 80 )); then
    echo -e "${RED}${BOLD}[!] ALERT: Disk usage is critically high!${NC}"
    notify-send -u critical -i drive-harddisk-alert "Disk Alert" "Usage is at ${disk_usage}%! Clean up needed."
else 
    echo -e "${GREEN}[✓] Disk health is within normal range.${NC}"
    notify-send -i drive-harddisk "Disk Health" "Current usage: ${disk_usage}%. All systems nominal."
fi

echo -e "${BLUE}==========================================${NC}"