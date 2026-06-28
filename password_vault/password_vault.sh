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
[3] Delete a password
[4] Edit a password
[5] Generate a password
[6] Github sync
[7] Exit
EOF
  read -r -p "Choose an option: " option
  case "$option" in
  1)
    if [[ ! -f $password_file ]]; then
      echo -e "\nYou don't have any saved password yet..."
      read -r -p "Press Enter to continue..."
      continue
    fi
    echo -e "\n[+] Decrypting your password file...\n"

    # Header ပြပြီး : ကို အခြေခံကာ Table Format ညှိပေးမယ့် column command သုံးထားတယ်
    (
      echo "SERVICE:USERNAME:PASSWORD"
      gpg -q -d "$password_file"
    ) | column -t -s ':'

    echo ""
    read -r -p "Press Enter to continue..."
    ;;

  2)
    read -r -p "Type Service/Website name: " service
    read -r -p "Type your username: " username
    read -s -r -p "Type your password: " password
    echo ""

    if [[ -f $password_file ]]; then
      if gpg -q -d "$password_file" >"$temp_password_file"; then
        echo "${service}:${username}:${password}" >>"$temp_password_file"
      else
        echo -e "[-] You've entered wrong passphrase..."
        read -r
        continue
      fi
    else
      echo "${service}:${username}:${password}" >"$temp_password_file"
    fi

    # --yes သုံးပြီး gpg အသစ်အောင်မြင်မှ အဟောင်းကို overwrite လုပ်မယ်
    if gpg --yes -o "$password_file" -c "$temp_password_file"; then
      shred -u -n 5 "$temp_password_file"
      echo -e "\n[+] Password has been successfully saved..."
    else
      echo -e "\n[-] Encryption failed..."
      if [[ -f $temp_password_file ]]; then shred -u -n 5 "$temp_password_file"; fi
    fi
    read -r
    ;;

  3) # DELETE FEATURE
    if [[ ! -f $password_file ]]; then
      echo -e "\nNo passwords saved yet..."
      read -r
      continue
    fi
    read -r -p "Enter the Service name to DELETE: " del_target

    if gpg -q -d "$password_file" >"$temp_password_file"; then
      if ! grep -q "^${del_target}:" "$temp_password_file"; then
        echo -e "\n[-] Service not found!"
        shred -u -n 5 "$temp_password_file"
        read -r
        continue
      fi

      grep -v "^${del_target}:" "$temp_password_file" >"${temp_password_file}.tmp"
      mv "${temp_password_file}.tmp" "$temp_password_file"

      if gpg --yes -o "$password_file" -c "$temp_password_file"; then
        echo -e "\n[+] Password deleted successfully!"
      fi
      shred -u -n 5 "$temp_password_file"
    else
      echo -e "[-] Wrong passphrase..."
    fi
    read -r
    ;;

  4) # EDIT FEATURE
    if [[ ! -f $password_file ]]; then
      echo -e "\nNo passwords saved yet..."
      read -r
      continue
    fi
    read -r -p "Enter the Service name to EDIT: " edit_target

    if gpg -q -d "$password_file" >"$temp_password_file"; then
      if ! grep -q "^${edit_target}:" "$temp_password_file"; then
        echo -e "\n[-] Service not found!"
        shred -u -n 5 "$temp_password_file"
        read -r
        continue
      fi

      echo -e "\nEnter NEW details for $edit_target:"
      read -r -p "New Username: " new_user
      read -s -r -p "New Password: " new_pass
      echo ""

      grep -v "^${edit_target}:" "$temp_password_file" >"${temp_password_file}.tmp"
      echo "${edit_target}:${new_user}:${new_pass}" >>"${temp_password_file}.tmp"
      mv "${temp_password_file}.tmp" "$temp_password_file"

      if gpg --yes -o "$password_file" -c "$temp_password_file"; then
        echo -e "\n[+] Password updated successfully!"
      fi
      shred -u -n 5 "$temp_password_file"
    else
      echo -e "[-] Wrong passphrase..."
    fi
    read -r
    ;;

  5)
    echo -e "\n[+] Generating your password..."
    pwgen -s 18 1
    read -r
    ;;

  6)
    if [[ -d "$working_dir/.git" ]]; then
      date=$(date +"%Y-%m-%d,%H:%M")
      echo -e "\n[+] Syncronizing your git repo..."
      cd "$working_dir"
      git pull origin main 2>/dev/null || git pull
      git add .
      git commit -m "Date: $date"
      git push origin main 2>/dev/null || git push
      echo -e "\n[+] Syncronizing complete..."
    else
      date=$(date +"%Y-%m-%d,%H:%M")
      read -r -p "Add your git repo URL: " git_repo
      echo -e "\n[+] Initiating your git..."
      cd "$working_dir"
      git init
      git add .
      git commit -m "Initial commit: $date"
      git remote add origin "$git_repo"
      git branch -M main
      git push -u origin main
      echo -e "\n[+] Syncronizing complete..."
    fi
    read -r
    ;;

  7)
    echo -e "\n[+] Goodbye..."
    exit 0
    ;;
  *)
    echo -e "\n[+] Invalid option..."
    read -r
    ;;
  esac
done
