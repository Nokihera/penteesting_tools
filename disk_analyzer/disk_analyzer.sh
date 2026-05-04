#!/bin/bash

# --- Color Definitions ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 
BOLD='\033[1m'
DIM='\033[2m'

config_file="$HOME/.config/disk_analyzer_config.txt"

# --- UI Header ---
clear
echo -e "${CYAN}${BOLD}┌────────────────────────────────────────┐${NC}"
echo -e "${CYAN}${BOLD}│       📊 DISK STORAGE MONITOR v1.1     │${NC}"
echo -e "${CYAN}${BOLD}└────────────────────────────────────────┘${NC}"

if [[ -f "$config_file" ]]; then
    bot_api=$(cat "$config_file" | grep "bot_api" | cut -d ":" -f 2-)
    chat_id=$(cat "$config_file" | grep "chat_id" | cut -d ":" -f 2-)
else
    echo -e "${YELLOW}🛠️  INITIAL SETUP: CONFIGURING TELEGRAM${NC}"
    echo -e "${DIM}──────────────────────────────────────────${NC}"
    echo -en "${CYAN}➜ Insert Bot API Token: ${NC}"
    read -r bot_api
    echo -en "${CYAN}➜ Insert Chat ID: ${NC}"
    read -r chat_id
    echo "bot_api:$bot_api" > "$config_file"
    echo "chat_id:$chat_id" >> "$config_file"
    echo -e "${GREEN}✔ Configuration saved to $config_file${NC}"
fi

# --- Logic ---
echo -e "\n${BLUE}🔎 Scanning filesystem...${NC}"
disk_usage=$(df / --output=pcent | sed -n "2p" | cut -d "%" -f 1)

# --- Output & Notification ---
echo -e "${CYAN}Current Disk Usage: ${BOLD}${disk_usage}%${NC}"

if (( disk_usage >= 80 )); then
    echo -e "${RED}${BOLD}✖ ALERT: Disk usage is critically high!${NC}"
    
    # Telegram Message (Markdown style)
    message="🚨 *Disk Space Alert* %0A────────────────%0A🔴 *Status:* Critical %0A📊 *Usage:* ${disk_usage}% %0A💻 *Host:* Arch-Linux %0A⚠️ *Action:* Immediate cleanup required!"
    curl -s -X POST "https://api.telegram.org/bot$bot_api/sendMessage" -d chat_id="$chat_id" -d text="$message" -d parse_mode="Markdown" > /dev/null
else 
    echo -e "${GREEN}✔ Disk health is within normal range.${NC}"
    
    # Telegram Message
    message="✅ *Disk Health Report* %0A────────────────%0A🟢 *Status:* Healthy %0A📊 *Usage:* ${disk_usage}% %0A💻 *Host:* Arch-Linux"
    curl -s -X POST "https://api.telegram.org/bot$bot_api/sendMessage" -d chat_id="$chat_id" -d text="$message" -d parse_mode="Markdown" > /dev/null
fi

echo -e "\n${CYAN}${BOLD}──────────────────────────────────────────${NC}"