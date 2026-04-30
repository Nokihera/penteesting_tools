#!/bin/bash

# --- UI Colors ---
G='\033[0;32m' # Green
C='\033[0;36m' # Cyan
Y='\033[1;33m' # Yellow
R='\033[0;31m' # Red
B='\033[1m'    # Bold
NC='\033[0m'   # No Color
trap 'echo -e "\n${R}Interrupted! Cleaning up...${NC}"; rm -f "$HOME/.mynotes/note.txt"; exit' SIGINT

old_notes=""

# Directory and File Check
if [[ ! -d "$HOME/.mynotes" ]]; then
    echo -e "${C}Creating directory...${NC}"
    mkdir "$HOME/.mynotes"
fi

if [[ ! -f "$HOME/.mynotes/note.txt" ]]; then
    touch "$HOME/.mynotes/note.txt"
fi

# --- Input UI ---
clear
echo -e "${C}${B}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
echo -e "${C}${B}┃           SECURE ENCRYPTED NOTES             ┃${NC}"
echo -e "${C}${B}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"

if [[ -f $HOME/.mynotes/.config.txt ]]; then
    gpg_id=$(cat $HOME/.mynotes/.config.txt)
else
    echo -e "\n${Y}${B}❯ Enter your GPG ID:${NC}"
    read gpg_id
    if [[ "$gpg_id" == "" ]]; then
        echo -e "${R}Error: GPG ID cannot be empty!${NC}"
        exit 1
    fi
    echo "$gpg_id" > $HOME/.mynotes/.config.txt
    echo -e "${G}[✓] GPG ID saved to .config.txt${NC}"
fi

echo -e "\n${Y}${B}❯ Write your note below:${NC}"
read note

echo -e "\n${Y}${B}❯ Enter your GPG secret key:${NC}"
read -s key
echo -e "${G}[✓] Key received.${NC}"

# --- Decrypting Logic ---
if [[ -f "$HOME/.mynotes/note.txt.gpg" ]]; then
    echo -e "\n${C}Decrypting existing data...${NC}"
    old_notes=$(gpg --batch --yes --passphrase "$key" --decrypt "$HOME/.mynotes/note.txt.gpg" 2>/dev/null)
    
    if [[ ! $? == 0 ]]; then
        echo -e "\n${R}${B}ERROR: The password is wrong!${NC}"
        rm "$HOME/.mynotes/note.txt"
        exit 1
    fi
fi

# --- Saving Logic ---
echo -e "${C}Encrypting and saving new entries...${NC}"

echo "$old_notes" > "$HOME/.mynotes/note.txt"
echo "$note" >> "$HOME/.mynotes/note.txt"

gpg --batch --yes --encrypt --recipient "$gpg_id" "$HOME/.mynotes/note.txt"
rm "$HOME/.mynotes/note.txt"

# --- Success UI ---
echo -e "\n${G}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${G}${B}       DONE! Your note is now secure.        ${NC}"
echo -e "${G}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
