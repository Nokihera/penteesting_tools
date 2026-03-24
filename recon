#!/bin/bash
# --- Banner Phase ---
clear
echo -e "\e[1;32m"
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
 ;`::::::`'::::::;;;::::: ,#/  /           DOOO 
 :`:::::::`;::::::;;::: ;::#  /            DOOO
 ::`:::::::`;:::::::: ;::::# /              DOO
 `:`:::::::`;:::::: ;::::::#/                DOO
  :::`:::::::`;; ;:::::::::##                OO 
  ::::`:::::::`;::::::::;:::#                OO 
  `:::::`::::::::::::;'`:;::#                O  
   `:::::`::::::::;' /  / `:#                   
    ::::::`:::::;'  /  /   `#                   
EOF
echo -e "\e[0m"
echo "           [+] TOUCHME RECON TOOL v1.1"
echo "------------------------------------------------"

# --- Logic Phase ---
mkdir -p ~/outputfiles/
read -p "Enter your target machine: " target
read -p "Enter your output file name: " output
output_path="$HOME/outputfiles/$output"

# Step 1: Fast Scan
echo "[+] Step 1: Scanning $target for all ports (Fast Scan)..."
sudo nmap -p- --min-rate 5000 $target -oN "$output_path"

# Step 2: Extract Ports
ports=$(grep "open" "$output_path" | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
if [ -z "$ports" ]; then
    echo "[!] No open ports found. Exiting."
    exit 1
fi
echo "[+] Open ports found: $ports"

# Step 3: Detailed Scan
echo "[+] Step 2: Running Detailed Scan (-A) on ports: $ports"
detailed_output="${output_path}_detailed.txt"
sudo nmap -A -p "$ports" "$target" -T4 -oN "$detailed_output"

# Step 4: Intelligent Web Port Detection
web_ports=$(grep -E "^[0-9]+/tcp.*open.*(http|ssl/http)" "$detailed_output" | cut -d'/' -f1 | sort -u)

if [ ! -z "$web_ports" ]; then
    echo "------------------------------------------------"
    echo "[!] Web services detected on ports: $(echo $web_ports | tr '\n' ' ')"
    read -p "Enter your wordlist path: " wordlist_path

    if [ ! -f "$wordlist_path" ]; then
        echo "[!] Error: Wordlist file not found! Skipping Gobuster."
    else
        for port in $web_ports; do
            echo -e "\n[+] Starting Gobuster on port $port..."
            gobuster_output="${output_path}_gobuster_port_${port}.txt"

            protocol="http"
            [ "$port" == "443" ] && protocol="https"

            gobuster dir -u "$protocol://$target:$port" -w "$wordlist_path" -o "$gobuster_output" -t 30 -k
        done
    fi
else
    echo "[*] No Web Services found. Skipping Gobuster."
fi

echo "------------------------------------------------"
echo "[*] All processes finished! Happy Hunting!"
