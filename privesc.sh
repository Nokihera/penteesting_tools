#!/bin/bash

# --- ASCII Header ---
cat << "EOF"
         _nnnn_
        dGGGGMMb
       @p~qp~~qMb
       M|@||@) M|
       @,----.JM|
      JS^\__/  qKL
     dZP        qKRb
    dZP          qKKb
   fZP            SMMb
   HZM            MMMM
   FqM            MMMM
 __| ".         |\dS"qML
 |    `.       | `' \Zq
_)      \.___.,|      .'
\____   )MMMMMP|    .'
     `-'        `--' touchme
EOF

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Configuration & Variables ---
suid=$(find / -perm -u=s -type f 2>/dev/null | grep -v "/timeshift")
kernel=$(uname -a | cut -d " " -f 3 | cut -d "-" -f 1)
version=("5.9" "5.3" "4.13.9" "4.4.0" "4.8.0" "2.6.22" "3.13.1")
bins=("bash" "neofetch" "nano" "vim" "awk" "nmap" "perl" "pdb" "python" "pip" "pipx" "man" "systemctl" "tar" "time" "timedatectl" "vi" "wget" "zip")
found=0
kernel_exploit=0

# --- Helper Function for Headers ---
print_header() {
    echo -e "\n${CYAN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}${BOLD}  [+] $1 ${NC}"
    echo -e "${CYAN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
}

echo -e "${GREEN}${BOLD}***** LINUX PRIVILEGE ESCALATION CHECKER *****${NC}"

# 1. OS & Kernel Check
print_header "OS & KERNEL VERSION CHECK"
echo -e "${YELLOW}Kernel Info:${NC} $(uname -a)"
echo -ne "${YELLOW}Distro Info:${NC} "
grep "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"'

for v in "${version[@]}"; do
    if [[ $kernel == $v* ]]; then
        echo -e "\n${RED}${BOLD}[!!!] POTENTIAL KERNEL EXPLOIT FOUND: $v ${NC}"
        echo -e "${YELLOW}👉 Check Exploit-DB for: Linux Kernel $v${NC}"
        kernel_exploit=1
    fi
done

if [[ $kernel_exploit == 0 ]]; then
    echo -e "\n${GREEN}✓ No immediate kernel exploit found in your checklist.${NC}"
fi

# 2. SUID Check
print_header "DANGEROUS SUID BINARIES"
echo -e "${CYAN}Searching for SUID files...${NC}"

for bin in "${bins[@]}"; do
    if echo "$suid" | grep -q "$bin"; then
        echo -e "${RED}${BOLD}[!!!] VULNERABLE BINARY FOUND: $bin ${NC}"
        echo -e "${YELLOW}👉 Check GTFOBins: https://gtfobins.github.io/gtfobins/$bin/#suid${NC}"
        found=1
    fi
done
find / -perm -u=s -type f 2>/dev/null | grep -v "/timeshift" | column
if [[ $found == 0 ]]; then
    echo -e "${GREEN}✓ Nothing suspicious found from your binary checklist.${NC}"
fi

# 3. Capabilities Check
print_header "CAPABILITIES CHECK"
caps=$(getcap -r / 2>/dev/null)
if [ -z "$caps" ]; then
    echo -e "${YELLOW}No special capabilities found.${NC}"
else
    echo -e "$caps"
fi

# 4. Environment & Path Check
print_header "PATH & PYTHON ENVIRONMENT"
echo -e "${YELLOW}PATH:${NC} $PATH"
echo -e "\n${YELLOW}Python3 Path:${NC}"
python3 -c 'import sys; print("\n".join(sys.path))' | sed 's/^/  /'

# 5. Cronjobs & Users
print_header "CRONJOBS & SYSTEM USERS"
echo -e "${YELLOW}Contents of /etc/crontab:${NC}"
cat /etc/crontab | grep -v "^#" 

echo -e "\n${YELLOW}Users with Bash Shell:${NC}"
grep "/bin/bash" /etc/passwd | cut -d: -f1 | sed 's/^/  - /'

# 6. Sudo Privileges
print_header "SUDO PRIVILEGES"
echo -e "${CYAN}Running 'sudo -l' to check passwordless commands...${NC}"
sudo -l

# 7. Writable Directories & Files
echo -e "\n${YELLOW}${BOLD}Do you want to check writable directories/files?${NC}"
echo -e "${RED}Warning: This may produce a large output.${NC}"
echo -e "${CYAN}Press [Enter] to continue or [Ctrl+C] to exit.${NC}"
read 

print_header "WRITABLE DIRECTORIES"
find / -writable -type d 2>/dev/null | grep -vE "(/proc|/sys|/dev)" | sed 's/^/  [D] /'

print_header "WRITABLE FILES"
find / -writable -type f 2>/dev/null | grep -vE "(/proc|/sys|/dev)" | sed 's/^/  [F] /'

echo -e "\n${GREEN}${BOLD}═════ SCAN COMPLETED ═════${NC}\n"