# Jeremy's Arch Hyprland Workstation

Personal Arch Linux workstation configuration for a Lenovo ThinkPad P1 Gen 4.

This repository contains the configuration required to rebuild my daily-driver workstation after a reinstall, SSD failure, or migration to new hardware.

---

# Hardware

## Laptop

* Lenovo ThinkPad P1 Gen 4
* Intel UHD Graphics
* NVIDIA RTX A2000 Laptop GPU
* 48 GB RAM

## Peripherals

* Dell P2722H Monitor
* Logitech MX Master Mouse
* Lofree Flow Keyboard
* USB-C Dock

---

# Repository Contents

```text
.config/
├── hypr
├── waybar
├── kitty
├── rofi
├── dunst

sddm/
├── sddm.conf
└── silent-default.conf

scripts/
├── docked.sh
└── mobile.sh

system/

wallpapers/

pkglist.txt
aurlist.txt

README.md
NVIDIA.md
```

---

# Fresh Arch Install

## Update System

```bash
sudo pacman -Syu
```

---

## Install Git

```bash
sudo pacman -S git
```

---

## Clone Repository

```bash
git clone git@github.com:SpotMcCormick/dotfiles.git

cd dotfiles
```

---

# Install Packages

## Official Repository Packages

```bash
sudo pacman -S --needed - < pkglist.txt
```

## Install yay

```bash
sudo pacman -S --needed base-devel git

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si
```

## AUR Packages

```bash
cd ~/dotfiles

yay -S --needed - < aurlist.txt
```

---

# Restore Configuration Files

```bash
mkdir -p ~/.config
```

```bash
cp -r .config/hypr ~/.config/
cp -r .config/waybar ~/.config/
cp -r .config/kitty ~/.config/
cp -r .config/rofi ~/.config/
cp -r .config/dunst ~/.config/
```

---

# Restore Wallpaper

```bash
mkdir -p ~/Pictures/desktop_wallpaper
```

```bash
cp wallpapers/tux_tron.png \
~/Pictures/desktop_wallpaper/
```

---

# Restore SDDM Theme

Restore login manager configuration:

```bash
sudo cp sddm/sddm.conf /etc/sddm.conf
```

```bash
sudo cp sddm/silent-default.conf \
    /usr/share/sddm/themes/silent/configs/default.conf
```

---

# NVIDIA Configuration

Install drivers:

```bash
sudo pacman -S \
    nvidia-open \
    nvidia-utils \
    nvidia-settings
```

Verify:

```bash
nvidia-smi
```

---

# Disable Nouveau

Create:

```text
/etc/modprobe.d/blacklist-nouveau.conf
```

Contents:

```text
blacklist nouveau
options nouveau modeset=0
```

---

# Enable NVIDIA DRM

Create:

```text
/etc/modprobe.d/nvidia.conf
```

Contents:

```text
options nvidia_drm modeset=1
```

---

# mkinitcpio

Edit:

```text
/etc/mkinitcpio.conf
```

Required:

```text
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Rebuild:

```bash
sudo mkinitcpio -P
```

---

# Docked Mode

Disable laptop panel:

```bash
~/dotfiles/scripts/docked.sh
```

Or:

```bash
hyprctl keyword monitor "eDP-1,disable"
```

---

# Mobile Mode

Enable laptop panel:

```bash
~/dotfiles/scripts/mobile.sh
```

Or:

```bash
hyprctl keyword monitor "eDP-1,preferred,auto,1.6"
```

---

# Verify System

## NVIDIA

```bash
nvidia-smi
```

## Firmware

```bash
fwupdmgr get-devices
```

## Monitor Detection

```bash
hyprctl monitors
```

---

# Weekly Maintenance

Run:

```bash
sh ~/Documents/linux_commands/update_system_firmware.txt
```

This:

* Updates firmware
* Updates Arch packages
* Updates AUR packages
* Exports package inventories
* Copies configuration backups
* Copies SDDM configuration
* Pushes updates to GitHub

---

# Notes

* USB-C dock display output uses NVIDIA.
* Hyprland is the primary desktop environment.
* Waybar provides status bar configuration.
* Rofi provides application launcher.
* Kitty is the terminal emulator.
* SDDM uses the Silent theme.
* Package inventories are stored in pkglist.txt and aurlist.txt.
* Repository is intended as a full workstation recovery backup.
