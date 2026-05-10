#!/bin/bash

# --- Color Codes ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}          ARCH LINUX CONFIGURATION (PART 2)           ${NC}"
echo -e "${CYAN}======================================================${NC}"

# Timezone
read -r -p "Country (e.g., Asia): " country
read -r -p "City (e.g., Yangon): " city
if [[ -f "/usr/share/zoneinfo/$country/$city" ]]; then
    ln -sf "/usr/share/zoneinfo/$country/$city" /etc/localtime
    hwclock --systohc
else
    echo "Invalid Timezone. Skipping..."
fi

# Locale
echo -e "${YELLOW}[*] Configuring Locale...${NC}"
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Hostname
read -r -p "Enter Hostname: " hname
echo "$hname" > /etc/hostname

# Network
echo -e "${YELLOW}[*] Enabling NetworkManager...${NC}"
systemctl enable NetworkManager

# Root Password
echo -e "${CYAN}Set Root Password:${NC}"
passwd

# Bootloader
echo -e "${YELLOW}Choose BIOS Type: (1) UEFI (2) MBR${NC}"
read -r biostype
if [[ "$biostype" == "1" ]]; then
    pacman -S grub efibootmgr --noconfirm
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
else
    pacman -S grub --noconfirm
    read -r -p "Enter Disk (e.g., /dev/sda): " dpath
    grub-install --target=i386-pc "$dpath"
fi
grub-mkconfig -o /boot/grub/grub.cfg

# User Account
read -r -p "Add user account? (y/n): " add_user
if [[ "$add_user" == "y" ]]; then
    read -r -p "Username: " username
    useradd -m -G wheel "$username"
    echo -e "${CYAN}Set password for $username:${NC}"
    passwd "$username"
    echo -e "${YELLOW}Note: Install 'sudo' and edit /etc/sudoers to give admin rights.${NC}"
fi

echo -e "${GREEN}INSTALLATION COMPLETE! Type 'exit', 'umount -R /mnt' and 'reboot'.${NC}"
rm /root/install_2.sh
exit 0
