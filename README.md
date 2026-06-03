# Jeremy's Arch Hyprland Dotfiles

Personal Arch Linux workstation configuration for a Lenovo ThinkPad P1 Gen 4.

## Hardware

* Lenovo ThinkPad P1 Gen 4
* Intel UHD Graphics
* NVIDIA RTX A2000 Mobile
* Dell P2722H Monitor
* Logitech MX Master Mouse
* Lofree Flow Keyboard

## Included Configuration

* Hyprland
* Waybar
* Kitty
* Rofi
* Hyprlock
* Hyprpaper
* Thunderbolt / Docked Display Support
* NVIDIA Open Driver Configuration
* Silent SDDM Theme
* JetBrains Mono Nerd Font
* Tux Tron Wallpaper
* Package Lists

---

## Repository Structure

```text
.config/
├── hypr
├── waybar
├── kitty
├── rofi

system/
├── mkinitcpio
├── modprobe

scripts/
├── docked.sh
├── mobile.sh

wallpapers/

pkglist.txt
aurlist.txt
NVIDIA.md
```

---

## Restore After Fresh Install

### Clone Repository

```bash
git clone git@github.com:SpotMcCormick/dotfiles.git
cd dotfiles
```

### Install Official Packages

```bash
sudo pacman -Syu

sudo pacman -S --needed - < pkglist.txt
```

### Install AUR Packages

```bash
yay -S --needed - < aurlist.txt
```

---

## Restore Configuration Files

```bash
mkdir -p ~/.config

cp -r .config/hypr ~/.config/
cp -r .config/waybar ~/.config/
cp -r .config/kitty ~/.config/
cp -r .config/rofi ~/.config/
```

---

## Restore Wallpaper

```bash
mkdir -p ~/Pictures/desktop_wallpaper

cp wallpapers/tux_tron.png \
~/Pictures/desktop_wallpaper/
```

---

## NVIDIA / Dock Configuration

### Hardware Layout

Internal laptop display:

```text
eDP-1 → Intel GPU
```

External dock display:

```text
DP-* → NVIDIA GPU
```

### Required Packages

```bash
sudo pacman -S nvidia-open nvidia-utils nvidia-settings
```

### Disable Nouveau

File:

```text
/etc/modprobe.d/blacklist-nouveau.conf
```

Contents:

```text
blacklist nouveau
options nouveau modeset=0
```

### Enable NVIDIA DRM

File:

```text
/etc/modprobe.d/nvidia.conf
```

Contents:

```text
options nvidia_drm modeset=1
```

### mkinitcpio

File:

```text
/etc/mkinitcpio.conf
```

Required:

```text
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Rebuild initramfs:

```bash
sudo mkinitcpio -P
```

Reboot:

```bash
sudo reboot
```

### Verify

```bash
nvidia-smi
```

```bash
lsmod | grep -E 'nouveau|nvidia'
```

Expected:

* NVIDIA modules loaded
* Nouveau not loaded

---

## Display Modes

### Docked Mode

Dell monitor only:

```bash
~/dotfiles/scripts/docked.sh
```

or

```bash
hyprctl keyword monitor "eDP-1,disable"
```

### Mobile Mode

Laptop display only:

```bash
~/dotfiles/scripts/mobile.sh
```

or

```bash
hyprctl keyword monitor "eDP-1,preferred,auto,1.6"
```

### Rofi Launchers

Available from:

```text
Super + Space
```

Launch:

* Docked Mode
* Mobile Mode

---

## Silent SDDM Theme

Restore configuration:

```bash
sudo cp sddm/default.conf \
/usr/share/sddm/themes/silent/configs/

sudo cp sddm/metadata.desktop \
/usr/share/sddm/themes/silent/
```

---

## Reload Hyprland

```bash
hyprctl reload
```

---

## Keybindings

| Key           | Action           |
| ------------- | ---------------- |
| Super + T     | Kitty            |
| Super + B     | Brave            |
| Super + C     | VS Code / Cursor |
| Super + E     | Thunderbird      |
| Super + F     | Thunar           |
| Super + L     | Hyprlock         |
| Super + M     | Spotify          |
| Super + Q     | Close Window     |
| Super + S     | Power Menu       |
| Super + Space | Rofi             |

---

## Notes

* USB-C dock display output requires NVIDIA drivers.
* NVIDIA Open Kernel Modules are used.
* Mobile and Docked monitor profiles are available through Rofi launchers.
* JetBrains Mono Nerd Font is used throughout the system.
* Package lists are stored for rebuilding the workstation.
