#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
suid=$(find / -perm -u=s -type f 2>/dev/null | grep -v "/timeshift")
kernel=$(uname -a | cut -d " " -f 3 | cut -d "-" -f 1)
version=("5.9" "5.3" "4.13.9" "4.4.0" "4.8.0" "2.6.22" "3.13.1")
found=0
bins=("bash" "neofetch" "nano" "vim" "awk" "nmap" "perl" "pdb" "python" "pip" "pipx" "man" "systemctl" "tar" "time" "timedatectl" "vi" "wget" "zip")
echo -e "$GREEN ***** PRIVESC SCRIPT ***** $NC"
echo -e "$GREEN OS VERSION CHECK $NC"
uname -a 
cat /etc/os-release
for v in "${version[@]}"; do
    if [[ $kernel == $v* ]]; then
        echo -e "$RED Kernel Exploit Found: $v $NC"
        echo "--> Check Exploit-db for this version!"
    fi
done
echo -e "$GREEN DANGEROUS SUID FILES $NC"
find / -perm -u=s -type f 2>/dev/null | grep -v "timeshift"
for bin in "${bins[@]}"; do
    if [[ "$suid" == *"$bin"* ]]; then
        echo -e "${RED}[!!!] Dangerous SUID found: $bin ${NC}"
        echo "--> Check GTFOBins for $bin exploitation!"
        found=1
    fi
done
if [[ $found == 0 ]]; then
	echo -e "$GREEN Nothing suspicious found from checklist! $NC"
fi
echo -e "$GREEN CAPABILITIES CHECK $NC"
getcap -r / 2>/dev/null
echo -e "$GREEN PATH VARIABLE CHECK $NC"
echo $PATH
echo -e "$GREEN PYTHON PATH CHECK $NC"
python3 -c 'import sys; print("\n".join(sys.path))'
echo -e "$GREEN CRONJOB CHECK $NC"
cat /etc/crontab
echo -e "$GREEN ALL USER CHECK $NC"
cat /etc/passwd
echo -e "$GREEN USER WITH BASH SHELL $NC"
cat /etc/passwd | grep "/bin/bash"
echo -e "$RED BINARIES THAT YOU CAN RUN WITHOUT PASSWORD $NC" 
sudo -l
echo -e "$GREEN Do you want to check wrtable directories?"
echo -e "This could mess up your terminal!"
echo -e "Press [Enter] to continue! $NC"
read 
echo -e "$GREEN WRITABLE DIRECTORIES $NC"
find / -writable -type d 2>/dev/null | grep -v "proc" | grep -v "sys" | grep -v "dev"
echo -e "$GREEN Do you want to check wrtable files?"
echo -e "This could mess up your terminal!"
echo -e "Press [Enter] to continue! $NC"
read
echo -e "$GREEN WRITABLE FILES $NC"
find / -writable -type f 2>/dev/null | grep -v "proc" | grep -v "sys" | grep -v "dev"

