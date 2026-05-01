#!/bin/bash

# --- Color Definitions ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- UI Header ---
clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${CYAN}${BOLD}       📦 SYSTEM BACKUP MANAGER v1.0      ${NC}"
echo -e "${BLUE}==========================================${NC}"

id=$(date +%Y%m%d_%H%M)

if [[ ! -d "$HOME/.backups" ]]; then
    echo -e "${YELLOW}[*] Creating backup directory...${NC}"
    mkdir "$HOME/.backups"
fi

if [[ -f "$HOME/.backups/.config.txt" ]]; then
    backup_dir=$(cat "$HOME/.backups/.config.txt")
else
    echo -e "${YELLOW}${BOLD}[?] You need to enter your intended backup dir${NC}"
    echo -en "${CYAN}Path: ${NC}"
    read -r backup_dir
    if [[ -d "$backup_dir" ]]; then
        echo "$backup_dir" > "$HOME/.backups/.config.txt"
        echo -e "${GREEN}[✓] Configuration saved!${NC}"
    else
        echo -e "${RED}[!] Error: You need to enter correct path to your backup directory${NC}"
        exit 1
    fi
fi

# --- Execution Phase ---
echo -e "\n${BLUE}[*] Starting backup process...${NC}"
echo -e "${CYAN}Target: ${NC}$backup_dir"

if tar -cvf "$HOME/.backups/backup$id.tar" "$backup_dir" 2>/dev/null ; then
    echo -e "${YELLOW}[*] Cleaning up old backup files...${NC}"
    find "$HOME/.backups/" -name "backup*" ! -name "backup$id.tar" -delete
    
    echo -e "\n${GREEN}${BOLD}──────────────────────────────────────────${NC}"
    echo -e "${GREEN}[✓] Backing up process is finished!${NC}"
    echo -e "${CYAN}Saved as: ${NC}backup$id.tar"
    echo -e "${GREEN}${BOLD}──────────────────────────────────────────${NC}"
else
    echo -e "${RED}[!] Error: Backup failed. Please check permissions.${NC}"
fi