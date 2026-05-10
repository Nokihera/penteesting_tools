#!/bin/bash

# --- Color Codes ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

trap 'echo -e "\n${RED}USER INTERRUPTED....${NC}"; exit 1' SIGINT

if [[ "$USER" != "root" ]]; then
    echo -e "${RED}Error: You need to run this script as root!${NC}"
    exit 1
fi

clear
echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}          ARCH LINUX INSTALLATION (PART 1)            ${NC}"
echo -e "${CYAN}======================================================${NC}"

# --- Network Selection ---
cat << EOF
Please choose your network connection:
  (1) Wireless (Wi-Fi)
  (2) Wired (Ethernet)
EOF
echo -ne "${YELLOW}Select Option [1-2]: ${NC}"
read -r option

if [[ "$option" == "1" ]]; then
    clear
    echo -e "${BLUE}[*] Wi-Fi Configuration...${NC}"
    rfkill unblock wlan
    iwctl device list
    echo -ne "${YELLOW}Type your device name (e.g., wlan0): ${NC}"
    read -r device_name
    iwctl station "$device_name" scan
    sleep 2
    iwctl station "$device_name" get-networks
    echo -ne "${YELLOW}SSID: ${NC}"; read -r ssid
    echo -ne "${YELLOW}Password: ${NC}"; read -r -s password
    echo ""
    iwctl --passphrase "$password" station "$device_name" connect "$ssid"
elif [[ "$option" == "2" ]]; then
    echo -e "${BLUE}[*] Checking Ethernet...${NC}"
fi

# Check connection
if ! ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo -e "${RED}No Internet connection!${NC}"; exit 1
fi

# --- Boot Mode ---
if [[ -d /sys/firmware/efi/ ]]; then
    bootmode="UEFI"
else
    bootmode="LEGACY"
fi
echo -e "${GREEN}Detected Boot Mode: $bootmode${NC}"

# --- Partitioning ---
timedatectl set-ntp true
clear
fdisk -l | grep "Disk /dev/"
echo -ne "${YELLOW}Drive to partition (e.g., sda): ${NC}"
read -r disk_name
[[ "$disk_name" != /dev/* ]] && disk_path="/dev/$disk_name" || disk_path="$disk_name"

fdisk "$disk_path"

# --- Formatting ---
clear
echo -e "${CYAN}--- FORMATTING ---${NC}"
fdisk -l "$disk_path"
echo -ne "${YELLOW}ROOT partition (e.g., sda3): ${NC}"; read -r root_p
[[ "$root_p" != /dev/* ]] && root_path="/dev/$root_p" || root_path="$root_p"
mkfs.ext4 "$root_path"

echo -ne "${YELLOW}SWAP partition (e.g., sda2, leave empty if none): ${NC}"; read -r swap_p
if [[ -n "$swap_p" ]]; then
    [[ "$swap_p" != /dev/* ]] && swap_path="/dev/$swap_p" || swap_path="$swap_p"
    mkswap "$swap_path"; swapon "$swap_path"
fi

if [[ "$bootmode" == "UEFI" ]]; then
    echo -ne "${YELLOW}EFI partition (e.g., sda1): ${NC}"; read -r efi_p
    [[ "$efi_p" != /dev/* ]] && efi_path="/dev/$efi_p" || efi_path="$efi_p"
    mkfs.fat -F 32 "$efi_path"
fi

# --- Mounting ---
mount "$root_path" /mnt
if [[ "$bootmode" == "UEFI" ]]; then
    mount --mkdir "$efi_path" /mnt/boot
fi

# --- Base Install ---
echo -e "${BLUE}[*] Installing Base Packages...${NC}"
# တစ်ခါတည်း networkmanager နဲ့ vim ထည့်ထားမယ်
pacstrap -K /mnt base linux linux-firmware base-devel networkmanager vim --noconfirm

genfstab -U /mnt >> /mnt/etc/fstab

# --- Transition to Part 2 ---
if [[ -f "./install_2.sh" ]]; then
    cp ./install_2.sh /mnt/root/install_2.sh
    chmod +x /mnt/root/install_2.sh
    echo -e "${GREEN}Part 1 Done. Entering Chroot...${NC}"
    arch-chroot /mnt /root/install_2.sh
else
    echo -e "${RED}Error: install_2.sh not found in current directory!${NC}"
fi