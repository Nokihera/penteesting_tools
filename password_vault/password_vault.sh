#!/bin/bash
trap 'echo -e "\nUSER INTERRUPTED! EXITING..."; exit 1' SIGINT
working_dir="$HOME/.password_vault"
password_file="$working_dir/password_file.gpg"
temp_password_file="$working_dir/password.txt"
mkdir -p "$working_dir"

while true; do
  clear
  cat <<EOF
[+] PASSWORD VAULT [+]

[1] View password list 
[2] Insert new password 
[3] Generate a password 
[4] Exit 
EOF
  read -r -p "Choose an option: " option
  case "$option" in
  1)
    if [[ ! -f $password_file ]]; then
      echo -e "\nYou don't have any saved password yet..."
      read -r
      continue
    fi
    echo -e "\n[+]Decrypting your password file..."
    gpg -d "$password_file"
    read -r
    ;;
  2)
    read -r -p "Type your username: " username
    read -r -p "Type your password: " password
    if [[ -f $password_file ]]; then
      if gpg -d "$password_file" >"$temp_password_file"; then
        echo "Username: $username, Password: $password" >>"$temp_password_file"
        rm "$password_file"
      else
        echo -e "[+]You've entered wrong passphrase..."
        read -r
        continue
      fi
    else
      echo "Username: $username, Password: $password" >"$temp_password_file"
    fi
    if gpg -o "$password_file" -c "$temp_password_file"; then
      rm "$temp_password_file"
      echo -e "\n[+]Password has been successfully saved..."
    else
      echo -e "\n[-]Encryption failed..."
    fi
    read -r
    ;;
  3)
    echo -e "\n[+]Generating your password..."
    pwgen -s 18 1
    read -r
    ;;
  4)
    echo -e "\n[+]Goodbye..."
    exit 0
    ;;
  *)
    echo -e "\n[+]Invalid option..."
    read -r
    ;;
  esac
done
