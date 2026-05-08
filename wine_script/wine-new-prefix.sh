#!/bin/bash

# အရောင်သတ်မှတ်ချက်များ (UX ပိုကောင်းစေရန်)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Base directory စစ်ဆေးခြင်း
if [[ ! -d "$HOME/prefix" ]]; then
    mkdir "$HOME/prefix"
fi

# Interrupt handling
trap 'echo -e "\n${RED}Process interrupted by user.${NC}"; exit 1' SIGINT

clear
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}       WINE PREFIX MANAGER v1.0          ${NC}"
echo -e "${CYAN}==========================================${NC}"

cat << EOF
Choose an option:

(1) Install components in an EXISTING prefix
(2) Create a NEW prefix

EOF

read -r option

if [[ "$option" == "1" ]]; then
    echo -e "${YELLOW}--- Current Prefixes ---${NC}"
    if [ "$(ls -A "$HOME/prefix")" ]; then
        ls -1 "$HOME/prefix" | sed 's/^/  • /'
    else
        echo "  (No prefixes found)"
    fi
    echo -e "${YELLOW}------------------------${NC}"
fi

echo -en "\nType prefix name: "
read -r prefix_name
prefix_path="$HOME/prefix/$prefix_name"

# Validation
if [[ -z "$prefix_name" ]]; then
    echo -e "${RED}Error: Prefix name cannot be empty.${NC}"
    exit 1
fi

if [[ "$option" == "1" ]]; then
    if [[ ! -d "$prefix_path" ]]; then
        echo -e "${RED}Error: Directory '$prefix_name' not found.${NC}"
        exit 1
    else
        echo -e "\n${GREEN}Target:${NC} $prefix_path"
        echo -e "${YELLOW}Press [ENTER] to launch Winetricks...${NC}"
        read -r
        WINEPREFIX="$prefix_path" winetricks
    fi

elif [[ "$option" == "2" ]]; then
    if [[ -d "$prefix_path" ]]; then
        echo -e "${RED}Error: Prefix '$prefix_name' already exists.${NC}"
        exit 1
    else
        echo -e "\n${GREEN}Initializing new prefix:${NC} $prefix_name"
        if WINEPREFIX="$prefix_path" winecfg ; then
            echo -e "${YELLOW}Initial setup complete. Press [ENTER] for Winetricks...${NC}"
            read -r
            WINEPREFIX="$prefix_path" winetricks
        else 
            echo -e "${RED}Error: Wine configuration failed.${NC}"
            exit 1
        fi
    fi
else
    echo -e "${RED}Invalid selection.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Done!${NC}"
exit 0