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

# Arg flags
$devDisk = "/dev/sda"
$keymap	 = "fr_CH-latin1"

function partitioning() {
	$disk = $1

	sed -e 's/\s*([\+0-9a-zA-Z]*\).*/\1/' << FDISK_CMDS | fdisk $disk
		g # Create new gpt partition
		n # Create new partition
		1 # Partition number
		  # Default - Start at disk start
		+


}
