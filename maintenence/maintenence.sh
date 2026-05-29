#!/bin/bash
trap 'echo -e "\n\e[1;31mUSER INTERRUPTED! EXITING..\e[0m"; exit 1' SIGINT

# UI Colors (ANSI Escape Sequences)
CYAN='\e[1;36m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m' # No Color (Reset)
dependencies=("pacman-contrib" "reflector")


prompt="${YELLOW}PRESS [ENTER] TO GO BACK TO MAIN MENU....${NC}"

if [[ "$USER" != "root" ]]; then
    echo -e "${RED}YOU NEED TO RUN THIS SCRIPT AS ROOT!${NC}"
    exit 1
fi
if ! pacman -Qi pacman-contrib &> /dev/null; then
    echo -e "${YELLOW}INSTALLING DEPENDENCIES (pacman-contrib)...${NC}"
    pacman -S --noconfirm pacman-contrib
fi

if ! pacman -Qi reflector &> /dev/null; then
    echo -e "${YELLOW}INSTALLING DEPENDENCIES (reflector)...${NC}"
    pacman -S --noconfirm reflector
fi

while true; do
    clear # UX Improvement: ရိုက်လိုက်တိုင်း Menu ကို အသစ်အတိုင်း သန့်ရှင်းပေးခြင်း
    echo -e "${CYAN}===============================================${NC}"
    echo -e "${CYAN}        **** ARCH MAINTENANCE SCRIPT **** ${NC}"
    echo -e "${CYAN}===============================================${NC}"
    echo -e ""
    echo -e " ${GREEN}[1]${NC} UPDATE MIRROR LIST"
    echo -e " ${GREEN}[2]${NC} UPDATE YOUR SYSTEM"
    echo -e " ${GREEN}[3]${NC} CHECK DISK FREE SPACE"
    echo -e " ${GREEN}[4]${NC} CHECK FAILED SERVICES"
    echo -e " ${GREEN}[5]${NC} CLEANUP PACMAN CACHE"
    echo -e " ${GREEN}[6]${NC} CHECK SYSTEM LOG"
    echo -e " ${GREEN}[7]${NC} IMPROVE YOUR SSD PERFORMANCE"
    echo -e " ${RED}[8] EXIT${NC}"
    echo -e ""
    echo -e "${CYAN}===============================================${NC}"
    
    read -r -p " CHOOSE AN OPTION: " option
    echo -e ""

    if [[ "$option" == "1" ]]; then
        echo -e "${YELLOW}>> UPDATING YOUR MIRROR LIST...${NC}"
        echo "-----------------------------------------------"
        reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
        echo -e "\n$prompt"
        read -r
        continue
    elif [[ "$option" == "2" ]]; then
        echo -e "${YELLOW}>> UPDATING YOUR SYSTEM...${NC}"
        echo "-----------------------------------------------"
        pacman -Syu
        echo -e "\n$prompt"
        read -r
        continue
    elif [[ "$option" == "3" ]]; then
        echo -e "${YELLOW}>> CHECKING YOUR DISK FREE SPACE...${NC}"
        echo "-----------------------------------------------"
        df / -h
        echo -e "\n$prompt"
        read -r
        continue
    elif [[ "$option" == "4" ]]; then
        echo -e "${YELLOW}>> CHECKING YOUR FAILED SERVICES...${NC}"
        echo "-----------------------------------------------"
        systemctl --failed
        echo -e "\n$prompt"
        read -r
        continue
    elif [[ "$option" == "5" ]]; then
        echo -e "${YELLOW}>> CLEANING UP YOUR PACMAN CACHE...${NC}"
        echo "-----------------------------------------------"
        paccache -r
        echo -e "\n$prompt"
        read -r
        continue
    elif [[ "$option" == "6" ]]; then
        echo -e "${YELLOW}>> CHECKING YOUR SYSTEM LOG...${NC}"
        echo "-----------------------------------------------"
        journalctl -p 3 -xb
        echo -e "\n$prompt"
        read -r
        continue
    elif [[ "$option" == "7" ]]; then
        echo -e "${YELLOW}>> IMPROVING YOUR SSD HEALTH...${NC}"
        echo "-----------------------------------------------"
        fstrim -av
        echo -e "\n$prompt"
        read -r
        continue
    elif [[ "$option" == "8" ]]; then
        echo -e "${RED}GOODBYE...${NC}"
        exit 0
    else
        echo -e "${RED}INVALID OPTION!${NC}"
        sleep 1
        continue
    fi
done
