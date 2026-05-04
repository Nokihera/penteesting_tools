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
echo -e "${BLUE}${BOLD}┌────────────────────────────────────────┐${NC}"
echo -e "${BLUE}${BOLD}│      ⚙️  SYSTEMD SERVICE MONITOR       │${NC}"
echo -e "${BLUE}${BOLD}└────────────────────────────────────────┘${NC}"

# Logic: Failed service အရေအတွက်ကို စစ်ခြင်း
# wc -l ကိုသုံးခြင်းက logic ကိုမပြောင်းလဲစေဘဲ အရေအတွက်ကို ပိုတိကျစေပါတယ်
failed_ps=$(systemctl --failed | grep "loaded" | cut -d " " -f 1)

config_file="$HOME/.config/systemctl_monitor_config.txt"

if [[ -f "$config_file" ]]; then
    bot_api=$(cat "$config_file" | grep "bot_api" | cut -d ":" -f 2-)
    chat_id=$(cat "$config_file" | grep "chat_id" | cut -d ":" -f 2-)
else
    echo -e "${YELLOW}🛠️  INITIAL SETUP: CONFIGURING TELEGRAM${NC}"
    echo -en "${CYAN}➜ Insert Bot API Token: ${NC}"
    read -r bot_api
    echo -en "${CYAN}➜ Insert Chat ID: ${NC}"
    read -r chat_id
    echo "bot_api:$bot_api" > "$config_file"
    echo "chat_id:$chat_id" >> "$config_file"
    echo -e "${GREEN}✔ Configuration saved to $config_file${NC}"
fi

echo -e "\n${CYAN}🔍 Scanning system services...${NC}"

if (( failed_ps > 0 )); then
    echo -e "${RED}${BOLD}✖ ALERT: $failed_ps failed process(es) detected!${NC}"
    
    # Telegram Message (Markdown style)
    message="⚠️ *Systemd Alert* %0A────────────────%0A❌ *Status:* Failed Services Detected %0A🚨 *Count:* $failed_ps %0A💻 *Host:* Arch-Linux %0A%0A*Action Required:* Check \`systemctl --failed\`"
    curl -s -X POST "https://api.telegram.org/bot$bot_api/sendMessage" -d chat_id="$chat_id" -d text="$message" -d parse_mode="Markdown" > /dev/null
else 
    echo -e "${GREEN}✔ All systems nominal. No failed services.${NC}"
    
    # Telegram Message
    message="✅ *Systemd Report* %0A────────────────%0A🛡️ *Status:* All systems healthy %0A💻 *Host:* Arch-Linux"
    curl -s -X POST "https://api.telegram.org/bot$bot_api/sendMessage" -d chat_id="$chat_id" -d text="$message" -d parse_mode="Markdown" > /dev/null
fi

echo -e "${DIM}──────────────────────────────────────────${NC}"
exit 0