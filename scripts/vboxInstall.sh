#!/bin/bash
#############################################################################################
# Title : vboxInstall.sh
# --------------------
# Description : Install script for Arch Linux
# -------------------------------------------------------------------------------------------
# Argument definition :
#	- 
#############################################################################################
# Author :	CptUsagi
# Date :	04.12.2021
# -------------------------
# Version :	1.0
#  - Script creation & initial commit : 04.12.2021  - 15:44 
#############################################################################################

##################################################
# Variables set for virtual box VM
##################################################

host="cpt-arch"
basicUser="cptusagi"

keymap="fr_CH-latin1"
country="Switzerland"
timezone="Europe/Zurich"
locale="fr_CH.UTF-8 UTF-8"

# Disk & disk dump file
devDisk="/dev/sda"
dump="./vboxDisk.dump"

# Partition numbers
efiPart="1"
swapPart="2"
extPart="3"

# Path to mirrorlist
pathMirrorlist="/etc/pacman.d/mirrorlist"

# Kernel selection -> Uncomment only one
#kernel="linux-hardened"
#kernel="linux-zen linux-zen-headers"
kernel="linux"

##################################################
# Prep
##################################################

# To be sure to use the correct keymap
loadkeys $keymap

timedatctl set-ntp true

# Disk partitioning
cat $dump | sfdisk $devDisk

mkfs.fat -F32 "$devDisk$efiPart"
mkswap "$devDisk$swapPart"
mkfs.ext4 "$devDisk$extPart"

mount "$devDisk$extPart" /mnt
swapon "$devDisk$swapPart"

# Mirrorlist
reflector -c $country -f 12 -l 10 -n 12 --save $pathMirrorlist

# Installing kernel
pacstrap /mnt base $kernel linux-firmware

genfstap -U /mnt >> /mnt/etc/fstab

##################################################
# CHROOT
##################################################

arch-chroot /mnt

echo "KEYMAP=$keymap" >> /etc/vconsole.conf
ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime

hwclock --systohc

sed -i "s/#$locale/$locale/" /etc/locale.gen
locale-gen

echo $host > /etc/hostname

echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo "127.0.1.1	$host.localdomain $host" >> /etc/hosts

useradd -m $basicUser
usermod -aG wheel,audio,video,storage,optical $basicUser

echo "Define ROOT password :"
passwd

echo "Define $basicUser password:"
passwd $basicUser

# Packages
pacman -Syy
pacman -S grub efibootmgr dosfstools os-prober mtools vim sudo git wget base-devel networkmanager

# Sudo privilege for the basic user
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo "Defaults editor=/usr/bin/vim" >> /etc/sudoers

# Setup grub
mkdir /boot/EFI
mount "/dev/$devDisk$efiPart" /boot/EFI
grub-install --target=x86_64-efi --bootloader id-grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

# Finalise
exit
umount -l /mnt
shutdown now
