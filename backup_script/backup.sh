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

# --- UI Header ---
clear
echo -e "${CYAN}${BOLD}┌────────────────────────────────────────┐${NC}"
echo -e "${CYAN}${BOLD}│       📦 ARCH SYSTEM BACKUP v1.1       │${NC}"
echo -e "${CYAN}${BOLD}└────────────────────────────────────────┘${NC}"

id=$(date +%Y%m%d_%H%M)

if [[ ! -d "$HOME/.backups" ]]; then
    echo -e "${BLUE}  Creating backup directory...${NC}"
    mkdir "$HOME/.backups"
fi

if [[ -f "$HOME/.backups/.config.txt" ]]; then
    # Logic အတိုင်း ထားထားပါတယ် (cut -d ":" -f 2)
    backup_dir=$(cat "$HOME/.backups/.config.txt" | grep backup_dir | cut -d ":" -f 2)
    bot_api=$(cat "$HOME/.backups/.config.txt" | grep bot_api | cut -d ":" -f 2-)
    chat_id=$(cat "$HOME/.backups/.config.txt" | grep chat_id | cut -d ":" -f 2-)
else
    echo -e "${YELLOW}⚙️  INITIAL SETUP REQUIRED${NC}"
    echo -e "${DIM}──────────────────────────────────────────${NC}"
    echo -en "${CYAN}➜ Enter Backup Path: ${NC}"
    read -r backup_dir
    echo -en "${CYAN}➜ Enter Telegram Token: ${NC}"
    read -r bot_api
    echo -en "${CYAN}➜ Enter Telegram Chat ID: ${NC}"
    read -r chat_id
    echo -e "${DIM}──────────────────────────────────────────${NC}"

    if [[ -d "$backup_dir" ]]; then
        echo "backup_dir:$backup_dir" > "$HOME/.backups/.config.txt"
        echo "bot_api:$bot_api" >> "$HOME/.backups/.config.txt"
        echo "chat_id:$chat_id" >> "$HOME/.backups/.config.txt"
        echo -e "${GREEN}✔ Configuration saved successfully!${NC}"
    else
        echo -e "${RED}✘ Error: Path does not exist.${NC}"
        exit 1
    fi
fi

# --- Execution Phase ---
echo -e "\n${BLUE}🔄 Starting backup sequence...${NC}"
echo -e "${DIM}Source: $backup_dir${NC}"

if tar -cvf "$HOME/.backups/backup$id.tar" "$backup_dir" 2>/dev/null ; then
    echo -e "${YELLOW}🧹 Cleaning redundant archives...${NC}"
    find "$HOME/.backups/" -name "backup*" ! -name "backup$id.tar" -delete
    
    # Telegram Message UI
    message="✅ *Backup Successful* %0A────────────────%0A💻 *Host:* Arch-Linux %0A📂 *File:* \`backup$id.tar\` %0A⏰ *Time:* $(date +%H:%M:%S)"
    curl -s -X POST "https://api.telegram.org/bot$bot_api/sendMessage" -d chat_id="$chat_id" -d text="$message" -d parse_mode="Markdown" > /dev/null
    
    echo -e "\n${GREEN}${BOLD}──────────────────────────────────────────${NC}"
    echo -e "${GREEN}✅ BACKUP COMPLETED${NC}"
    echo -e "${CYAN}Archive: ${NC}backup$id.tar"
    echo -e "${GREEN}${BOLD}──────────────────────────────────────────${NC}"
else
    # Error Telegram Message
    message="❌ *Backup Failed!* %0A────────────────%0A💻 *Host:* Arch-Linux %0A⚠️ *Error:* Check folder permissions."
    curl -s -X POST "https://api.telegram.org/bot$bot_api/sendMessage" -d chat_id="$chat_id" -d text="$message" -d parse_mode="Markdown" > /dev/null
    
    echo -e "${RED}${BOLD}✘ ERROR: Backup failed. Check logs.${NC}"
fi
exit 0