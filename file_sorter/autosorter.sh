#!/bin/bash

# --- Color Definitions ---
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Configuration ---
dl_path="$HOME/Downloads"

# --- Header Section ---
echo -e "${CYAN}${BOLD}"
cat << "EOF"
 ___,___,_______,____
|  :::|///./||'||    \
|  :::|//.//|| || H)  |
|  :::|/.///|!!!|     |
|   _______________   |
|  |:::::::::::::::|  |
|  |_______________|  |
|  |_______________|  |
|  |_______________|  |
|  |_______________|  |
||_|    touchme    ||_|
|__|_______________|__|
EOF
echo -e "${NC}"

echo -e "${YELLOW}${BOLD}>> File sorting process is starting now...${NC}\n"

# --- Helper Function for Progress Bar ---
show_progress() {
    local duration=$1
    local label=$2
    echo -ne "${BLUE}[-] $label... ${NC}"
    sleep "$duration"
    echo -e "${GREEN}Done!${NC}"
}

# 1. Image Sorting
mv "$dl_path"/*.jpg "$dl_path"/*.png "$HOME/Pictures" 2>/dev/null
echo -ne "${GREEN}######                    (33%)${NC}\r"
sleep 0.1

# 2. Document & Video Sorting
mv "$dl_path"/*.pdf "$dl_path"/*.txt "$HOME/Documents" 2>/dev/null
mv "$dl_path"/*.mp4 "$HOME/Videos" 2>/dev/null
echo -ne "${GREEN}############              (66%)${NC}\r"
sleep 0.1

# 3. Music Sorting
mv "$dl_path"/*.mp3 "$dl_path"/*.flac "$HOME/Music" 2>/dev/null
echo -ne "${GREEN}#######################   (100%)${NC}\r"
echo -ne '\n'

# --- Summary Output ---
echo -e "\n${PURPLE}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  ✔ SUCCESS: File sorting completed!${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════${NC}"

# Display where files went (Visual feedback)
echo -e "${CYAN}📁 Images    -->  ~/Pictures"
echo -e "📄 Documents -->  ~/Documents"
echo -e "🎬 Videos    -->  ~/Videos"
echo -e "🎵 Music     -->  ~/Music${NC}"

# Notification
notify-send "SortMe" "Downloads folder is now clean!" --icon=folder-download