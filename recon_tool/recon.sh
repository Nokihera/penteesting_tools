#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' 
BOLD='\033[1m'

# --- Helper Functions ---
print_status() { echo -e "\n${BLUE}[${CYAN}*${BLUE}] ${BOLD}$1${NC}"; }
print_success() { echo -e "${GREEN}[${BOLD}✓${NC}${GREEN}] $1${NC}"; }
print_error() { echo -e "${RED}[${BOLD}!${NC}${RED}] $1${NC}"; }

# --- Banner Phase ---
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
               ...                              
              ;::::;                            
            ;::::; :;                           
          ;:::::'   :;                          
         ;:::::;     ;.                         
        ,:::::'       ;           OOO\          
        ::::::;       ;          OOOOO\         
        ;:::::;       ;         OOOOOOOO        
       ,;::::::;     ;'         / OOOOOOO       
     ;:::::::::`. ,,,;.        /  / DOOOOOO     
   .';:::::::::::::::::;,     /  /     DOOOO    
  ,::::::;::::::;;;;::::;,   /  /          DOOO  
 ;`::::::`'::::::;;;::::: ,#/  /            DOOO 
 :`:::::::`;::::::;;::: ;::#  /             DOOO
 ::`:::::::`;:::::::: ;::::# /               DOO
 `:`:::::::`;:::::: ;::::::#/                DOO
  :::`:::::::`;; ;:::::::::##                OO 
  ::::`:::::::`;::::::::;:::#                OO 
  `:::::`::::::::::::;'`:;::#                O  
   `:::::`::::::::;' /  / `:#                   
    ::::::`:::::;'  /  /   `#                   
EOF
echo -e "${CYAN}        [+] TOUCHME RECON TOOL v1.4 (Fixed Logic)${NC}"
echo -e "${BLUE}────────────────────────────────────────────────${NC}"

# --- Input Phase ---
mkdir -p ~/outputfiles/
echo -en "${YELLOW}${BOLD}[?] Enter target machine (IP/Domain): ${NC}"
read -r target
echo -en "${YELLOW}${BOLD}[?] Enter output file name: ${NC}"
read -r output

output_path="$HOME/outputfiles/$output"
detailed_output="${output_path}_detailed.txt"

# --- Step 1: Fast Scan & Port Extraction ---
print_status "Step 1: Discovering Open Ports on $target (Fast Scan)..."

# Grepable output ကို အသုံးပြု၍ port များကို ရှာဖွေခြင်း
sudo nmap -p- --min-rate 5000 "$target" -oG /tmp/nmap_tmp

# Regex logic ဖြင့် port နံပါတ်များကိုသာ သန့်စင်စွာ ဆွဲထုတ်ခြင်း
ports=$(grep "Ports:" /tmp/nmap_tmp | awk -F'Ports: ' '{print $2}' | grep -oP '\d+(?=/open/tcp)' | tr '\n' ',' | sed 's/,$//')

if [ -z "$ports" ]; then
    print_error "No open ports found. Terminating scan."
    exit 1
fi

print_success "Open ports detected: ${PURPLE}${BOLD}$ports${NC}"

# --- Step 2: Detailed Scan ---
print_status "Step 2: Performing Deep Service Enumeration (-A)..."
echo -e "${YELLOW}Running: nmap -A -p $ports $target${NC}"
sudo nmap -A -p "$ports" "$target" -T4 -oN "$detailed_output"
print_success "Detailed scan saved to: $detailed_output"

# --- Step 3: Web Port Detection & Gobuster ---
print_status "Step 3: Analyzing results for Web Services..."

# Regex သုံး၍ port lines များကိုသာ တိကျစွာ ခွဲထုတ်ခြင်း (http သို့မဟုတ် ssl/http)
web_ports=$(grep -E "^[0-9]+/tcp.*open.*http" "$detailed_output" | cut -d'/' -f1 | sort -u)

if [ ! -z "$web_ports" ]; then
    echo -e "${PURPLE}${BOLD}────────────────────────────────────────────────${NC}"
    print_success "Web services found on port(s): ${GREEN}$(echo "$web_ports" | tr '\n' ' ')${NC}"
    
    echo -en "${YELLOW}${BOLD}[?] Enter path to your Wordlist: ${NC}"
    read -r wordlist_path

    if [ ! -f "$wordlist_path" ]; then
        print_error "Wordlist file not found! Skipping Gobuster."
    else
        for port in $web_ports; do
            print_status "Launching Gobuster on port $port..."
            gobuster_output="${output_path}_gobuster_port_${port}.txt"

            # Protocol (http/https) ကို သေချာစွာ စစ်ဆေးခြင်း
            protocol="http"
            if grep -E "^$port/tcp.*open.*ssl/http" "$detailed_output" > /dev/null; then
                protocol="https"
            fi

            gobuster dir -u "$protocol://$target:$port" -w "$wordlist_path" -o "$gobuster_output" -t 30 -k
            print_success "Port $port brute-force completed. Results: $gobuster_output"
        done
    fi
else
    echo -e "${YELLOW}[*] No HTTP/HTTPS services identified. Skipping Gobuster.${NC}"
fi

echo -e "\n${BLUE}────────────────────────────────────────────────${NC}"
echo -e "${GREEN}${BOLD}[*] ALL PROCESSES COMPLETE. HAPPY HUNTING!${NC}"
echo -e "${BLUE}────────────────────────────────────────────────${NC}"