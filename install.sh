#!/usr/bin/env bash
# Clean install for Arch + Hyprland dotfiles.
# Run from the repo:   cd ~/dotfiles && bash install.sh
# Detects an NVIDIA GPU: NVIDIA setup runs only if one is found.

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES" || exit 1

# Set to yes to also install the USB-C dock drivers (displaylink, evdi-dkms)
INSTALL_DOCK_DRIVERS=no

STOW_PACKAGES="hypr kitty rofi waybar yazi nvim nwg-look nwg-displays harlequin"

step() { echo; echo "==> $1"; }

# ---------------------------------------------------------------
step "Updating system and installing base tools"
sudo pacman -Syu
sudo pacman -S --needed git base-devel stow flatpak pciutils

# ---------------------------------------------------------------
step "Checking for NVIDIA GPU"
if lspci | grep -qi nvidia; then
    HAS_NVIDIA=yes
else
    HAS_NVIDIA=no
fi
echo "NVIDIA GPU detected: $HAS_NVIDIA"

# ---------------------------------------------------------------
step "Installing pacman packages"
if [ "$HAS_NVIDIA" = yes ]; then
    sudo pacman -S --needed - < pkglist.txt
else
    # Skip any NVIDIA packages on machines without the GPU
    grep -vi nvidia pkglist.txt | sudo pacman -S --needed -
fi

# ---------------------------------------------------------------
step "Installing yay"
if ! command -v yay >/dev/null 2>&1; then
    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si)
fi

# ---------------------------------------------------------------
step "Installing AUR packages"
# *-debug entries are build leftovers, not real AUR packages, so they are skipped
if [ "$INSTALL_DOCK_DRIVERS" = yes ]; then
    grep -v -- '-debug$' aurlist.txt | yay -S --needed -
else
    grep -v -- '-debug$' aurlist.txt | grep -vE '^(displaylink|evdi)' | yay -S --needed -
fi

# ---------------------------------------------------------------
step "Installing flatpaks"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
xargs -a flatpaklist.txt flatpak install -y flathub
mkdir -p ~/.local/share/flatpak/overrides
cp flatpak/overrides/* ~/.local/share/flatpak/overrides/

# ---------------------------------------------------------------
step "Linking configs with stow"
# Fresh installs may have default configs that block stow, so back them up first
for pkg in $STOW_PACKAGES; do
    target="$HOME/.config/$pkg"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $target to $target.bak"
        mv "$target" "$target.bak"
    fi
done
stow -d "$DOTFILES" -t "$HOME" $STOW_PACKAGES

# ---------------------------------------------------------------
step "Installing helper scripts"
mkdir -p ~/.local/bin
cp scripts/docked.sh ~/.local/bin/docked
cp scripts/mobile.sh ~/.local/bin/mobile
cp scripts/db-ch scripts/db-pg ~/.local/bin/
chmod +x ~/.local/bin/docked ~/.local/bin/mobile ~/.local/bin/db-ch ~/.local/bin/db-pg

read -rp "Server IP for the database scripts (leave blank to skip): " SERVER_IP
if [ -n "$SERVER_IP" ]; then
    sed -i "s/SERVER_IP/$SERVER_IP/" ~/.local/bin/db-ch ~/.local/bin/db-pg
fi

# ---------------------------------------------------------------
step "Setting up SDDM login screen"
sudo cp sddm/sddm.conf /etc/sddm.conf
sudo cp sddm/silent-default.conf /usr/share/sddm/themes/silent/configs/default.conf
sudo cp /usr/share/backgrounds/archlinux/split.png /usr/share/sddm/themes/silent/backgrounds/
sudo systemctl enable sddm

# ---------------------------------------------------------------
if [ "$HAS_NVIDIA" = yes ]; then
    step "NVIDIA setup"
    # nvidia-open is for the default 'linux' kernel. Other kernels need nvidia-open-dkms.
    sudo pacman -S --needed nvidia-open nvidia-utils nvidia-settings

    printf 'blacklist nouveau\noptions nouveau modeset=0\n' | sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null
    printf 'options nvidia_drm modeset=1\n' | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

    sudo sed -i 's/^MODULES=(.*)/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
else
    step "No NVIDIA GPU found, skipping NVIDIA setup"
fi

# ---------------------------------------------------------------
echo
echo "Done. Reboot to finish:  reboot"
