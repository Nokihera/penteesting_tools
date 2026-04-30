#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Configuration ---
video_path="/home/touchme/Videos/"

# --- ASCII Header ---
echo -e "${CYAN}${BOLD}"
cat << "EOF"
 ___________________
 | _______________ |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 |_________________|
      _[_______]_
 ___[___________]___
|          [_____] []|__
|          [_____] []|  \__
L___________________J     \ \___\/
 ___________________      /\
/###################\    (__)

EOF
echo -e "${NC}"

# --- Header ---
echo -e "${GREEN}${BOLD}***** MOVIE DOWNLOADER (WGET-RESUME) *****${NC}"

# --- Input Section ---
echo -e "\n${YELLOW}${BOLD}[Input Required]${NC}"
echo -ne "${CYAN}➜ Paste Movie URL: ${NC}"
read url
echo -ne "${CYAN}➜ Enter Video Name (without extension): ${NC}"
read name

# --- Validation ---
if [[ -z "$url" || -z "$name" ]]; then 
    echo -e "\n${RED}${BOLD}[!] Error: URL and Movie Name cannot be empty!${NC}"
    exit 1
fi

# --- Process Section ---
echo -e "\n${PURPLE}══════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  📥 Downloading: ${BOLD}$name.mp4${NC}"
echo -e "${YELLOW}  📂 Destination: ${BOLD}$video_path${NC}"
echo -e "${PURPLE}══════════════════════════════════════════════════${NC}\n"

# Run wget with Resume capability and a cleaner progress bar
wget -c "$url" -O "$video_path$name.mp4" --show-progress --progress=bar:force:noscroll

# --- Completion Section ---
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}✔ SUCCESS: Download finished successfully!${NC}"
    notify-send "Downloader" "Download finished: $name" --icon=video-x-generic
else
    echo -e "\n${RED}${BOLD}✘ ERROR: Download failed or interrupted!${NC}"
fi