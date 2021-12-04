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

genfstab -U /mnt >> /mnt/etc/fstab

##################################################
# CHROOT
##################################################

cat ./vboxChroot.sh >> /mnt/vboxChroot.sh
chmod +x /mnt/vboxChroot.sh

arch-chroot /mnt
