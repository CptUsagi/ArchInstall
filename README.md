# ArchInstall

Install script for ArchLinux on VirtualBox

## VM Specs

- **30 Go of dynamicly allocated HDD**
- **Must have EFI enabled**
- Video memory : maxed out
- Graphic controler VMSVGA

### Optional
- RAM shouldn't matter, but I used 8 Go
- CPU shouldn't matter, but I used 8 Cores
- VT-X or AMD-V activated

### Notes
If you use VirtualBox v6.1.30+ > don't use 3D accelertion else you should be fine

---

## Install
1. Boot on Arch Linux iso
2. Type the following :
```
pacman -Sy git
```
to install git
3. Clone repository :
```
git clone https://github.com/CptUsagi/ArchInstall.git
```
4. Launch script :
```
~/ArchInstall/scripts/vboxInstall.sh
```
5. Wait until chrooted
6. Lauch the second script
```
./vboxChroot.sh
```
7. Wait until prompted to set password
8. Set password for ROOT
9. Set password for sudo user (by default the user is cptusagi, feel free to change it in the vboxInstall.sh file)
10. Wait until end and restart

---

## User and hostname
- The default user name is cptusagi
- The default hostname is cpt-arch

You can modify the scripts to adapt it to your liking, but for the current version I haven't made it dynamic nor did I make the disk partitions dynamic (maybe I'll implement it in a later version)
