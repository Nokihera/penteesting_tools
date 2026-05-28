#!/bin/bash
trap 'echo -e "\n\e[1;31m[!] USER INTERRUPTED! EXITING....\e[0m"; exit 1' SIGINT
headerinfo=()
datainfo=()

# UI အတွက် အရောင်ကုဒ်များ သတ်မှတ်ခြင်း
BLUE='\e[1;34m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
CYAN='\e[1;36m'
NC='\e[0m' # Color ပြန်ဖျက်ရန်

while true; do
    clear # အကြိမ်တိုင်း menu အဟောင်းတွေကို ရှင်းပစ်ရန်
    cat << "EOF"
  ______   __    __  _______   _______          ______   __        ______  
 /      \ |  \  |  \|       \ |       \        /      \ |  \      |      \ 
|  $$$$$$\| $$  | $$| $$$$$$$\| $$$$$$$\      |  $$$$$$\| $$       \$$$$$$ 
| $$   \$$| $$  | $$| $$__| $$| $$__/ $$      | $$   \$$| $$        | $$   
| $$      | $$  | $$| $$    $$| $$    $$      | $$      | $$        | $$   
| $$   __ | $$  | $$| $$$$$$$\| $$$$$$$       | $$   __ | $$        | $$   
| $$__/  \| $$__/ $$| $$  | $$| $$            | $$__/  \| $$_____  _| $$_  
 \$$    $$ \$$    $$| $$  | $$| $$             \$$    $$| $$     \|   $$ \ 
  \$$$$$$   \$$$$$$  \$$   \$$ \$$              \$$$$$$  \$$$$$$$$ \$$$$$$ 
EOF

    # လက်ရှိ Target URL ပြသပေးမည့် Status Bar
    echo -e "${BLUE}=====================================================================${NC}"
    if [[ -z "$target" ]]; then
        echo -e "${YELLOW}[*] STATUS:${NC} Target URL -> ${RED}NOT SET (Choose option 3)${NC}"
    else
        echo -e "${YELLOW}[*] STATUS:${NC} Target URL -> ${GREEN}$target${NC}"
    fi
    echo -e "${BLUE}=====================================================================${NC}"

    # Request Options ပြသခြင်း
    echo -e "${CYAN}(1)${NC} GET METHOD"
    echo -e "${CYAN}(2)${NC} POST METHOD"
    echo -e "${CYAN}(3)${NC} EDIT TARGET URL"
    echo -e "${CYAN}(4)${NC} EDIT HEADER INFO"
    echo -e "${CYAN}(5)${NC} EDIT DATA INFO"
    echo -e "${CYAN}(6)${NC} EXIT"
    echo ""
    
    read -r -p "CHOOSE AN OPTION: " option
    echo -e "${BLUE}--------------------------------------------------------------------=${NC}"

    if [[ "$option" == "1" ]]; then
        if [[ -z "$target" ]]; then
            echo -e "${RED}[!] TARGET IP MUST BE FILLED TO CONTINUE..${NC}"
            echo -e "\nPress Enter to return to menu..." && read
            continue
        fi
        echo -e "${GREEN}[+] FETCHING YOUR $target...${NC}"
        curl "${headerinfo[@]}" "$target" -v
        echo -e "\nPress Enter to return to menu..." && read
        
    elif [[ "$option" == "2" ]]; then
        if [[ -z "$target" ]]; then
            echo -e "${RED}[!] TARGET IP MUST BE FILLED TO CONTINUE..${NC}"
            echo -e "\nPress Enter to return to menu..." && read
            continue
        fi
        echo -e "${GREEN}[+] FETCHING YOUR $target...${NC}"
        curl -X POST "${headerinfo[@]}" "${datainfo[@]}"  "$target" -v
        echo -e "\nPress Enter to return to menu..." && read
        
    elif [[ "$option" == "3" ]]; then
        read -r -p "TYPE YOUR TARGET URL: " target
        if [[ -z "$target" ]]; then
            echo -e "${RED}[!] TARGET IP CAN NOT BE EMPTY!${NC}"
            echo -e "\nPress Enter to return to menu..." && read
            continue
        fi
        continue
        
    elif [[ "$option" == "4"  ]]; then
        headerinfo=()
        echo -e "${YELLOW}[*] Enter headers (Key: Value). Press ENTER on an empty line to finish.${NC}"
        while true; do
            read -r -p "INSERT HEADER INFO: " headline
            if [[ -z "$headline" ]]; then
                break
            fi
            headerinfo+=("-H" "$headline")
        done
        
    elif [[ "$option" == "5" ]]; then
        read -r -p "INSERT DATA INFO: " data
        if [[ -n "$data" ]]; then
            datainfo=("-d" "$data")
            echo -e "${GREEN}[+] Data payload configured successfully.${NC}"
        else
            datainfo=()
            echo -e "${YELLOW}[*] Data payload cleared.${NC}"
        fi    
        echo -e "\nPress Enter to return to menu..." && read
        continue
        
    elif [[ "$option" == "6" ]]; then
        echo -e "${GREEN}GOODBYE!${NC}"
        exit 0
        
    else
        echo -e "${RED}[!] INVALID OPTION!${NC}"
        echo -e "\nPress Enter to return to menu..." && read
        continue
    fi
done
