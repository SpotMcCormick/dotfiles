# Dotfiles: Arch + Hyprland

Run these in order on a fresh Arch install.

## 1. Update and install the basics

Update the system:

```bash
sudo pacman -Syu
```

Install git (to download this repo), stow (to link configs), base-devel (needed to build AUR packages), flatpak, and pciutils (to check the GPU):

```bash
sudo pacman -S --needed git base-devel stow flatpak pciutils
```

## 2. Get the repo

Clone it into your home folder. It must end up at `~/dotfiles` or stow will link to the wrong place:

```bash
cd ~
git clone https://github.com/SpotMcCormick/dotfiles.git
cd dotfiles
```

## 3. Check for an NVIDIA GPU

```bash
lspci | grep -i nvidia
```

- It prints a line: do **4a**.
- It prints nothing: do **4b**.

Do only one of them, then continue with step 5.

## 4a. If you have an NVIDIA GPU

Install everything on the package list:

```bash
sudo pacman -S --needed - < pkglist.txt
```

Install the NVIDIA driver:

```bash
sudo pacman -S --needed nvidia-open nvidia-utils nvidia-settings
```

Disable the open-source nouveau driver and turn on the setting Hyprland needs:

```bash
sudo cp system/modprobe/*.conf /etc/modprobe.d/
```

Load the NVIDIA modules at boot. Open the file and set the `MODULES` line to `MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)`:

```bash
sudo nano /etc/mkinitcpio.conf
```

Rebuild the boot image:

```bash
sudo mkinitcpio -P
```

Now go to step 5.

## 4b. If you do NOT have an NVIDIA GPU

Install everything on the package list except the NVIDIA packages:

```bash
grep -viE "nvidia|cuda" pkglist.txt | sudo pacman -S --needed -
```

Now go to step 5.

## 5. Install AUR and Flatpak apps

Install yay, a helper for the AUR (community packages):

```bash
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
cd ~/dotfiles
```

Install everything from the AUR:

```bash
yay -S --needed - < aurlist.txt
```

Add the Flathub store, then install the Flatpak apps:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub $(cat flatpaklist.txt)
```

Restore the Flatpak permission tweaks:

```bash
mkdir -p ~/.local/share/flatpak/overrides
cp flatpak/overrides/* ~/.local/share/flatpak/overrides/
```

## 6. Link the configs

Remove any default configs the fresh install created. Stow won't link over them:

```bash
rm -rf ~/.config/{hypr,kitty,rofi,waybar,yazi,nvim,nwg-look,nwg-displays,harlequin,gtk-3.0,gtk-4.0,wlogout}
```

Stow creates symlinks in `~/.config` that point back into `~/dotfiles`, so edits in either place stay in sync:

```bash
stow hypr kitty rofi waybar yazi nvim nwg-look nwg-displays harlequin gtk wlogout
```

## 7. Install the scripts and database settings

Hyprland runs these scripts from `~/.local/bin`:

```bash
mkdir -p ~/.local/bin
cp scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*
```

Harlequin reads its database logins from environment variables. Put them all in one file that the `db-ch` and `db-pg` scripts load. Open it:

```bash
nano ~/.config/db.env
```

Paste this and fill in your own values:

```bash
export CLICKHOUSE_HOST=
export CLICKHOUSE_USER=
export CLICKHOUSE_PASSWORD=
export POSTGRES_HOST=
export POSTGRES_USER=
export POSTGRES_PASSWORD=
```

The file holds passwords, so make it readable only by you:

```bash
chmod 600 ~/.config/db.env
```

## 8. Login screen (SDDM)

Copy the SDDM settings and the theme config:

```bash
sudo cp sddm/sddm.conf /etc/sddm.conf
sudo cp sddm/silent-default.conf /usr/share/sddm/themes/silent/configs/default.conf
```

Copy the login background into the theme, then make SDDM start at boot:

```bash
sudo cp /usr/share/backgrounds/archlinux/split.png /usr/share/sddm/themes/silent/backgrounds/
sudo systemctl enable sddm
```

## 9. Home folders and terminal prompt

Create the standard folders:

```bash
mkdir -p ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos
```

Create your own folders. Screenshots (the Print key) go in Pictures, and screen recordings go in Videos:

```bash
mkdir -p ~/Pictures/Screenshots ~/Videos/Screenrecordings ~/dev-sandbox ~/tools
```

Set the terminal prompt: blue `[user@host folder]` and a purple `$`. Kitty adds its own shell integration codes by itself:

```bash
cat >> ~/.bashrc <<'EOF'
PS1='\[\e[38;5;75m\][\u@\h \W]\[\e[38;5;141m\]\$\[\e[0m\] '
EOF
```

Load it in the current terminal:

```bash
source ~/.bashrc
```

## 10. Reboot

```bash
reboot
```

## 11. After you log in

Set the dark theme, icons and font. Run these in a terminal inside Hyprland. They are stored in a database, not a file, so stow can't carry them:

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 11'
```

If Hyprland complains about `monitors.lua`, open `nwg-displays` and click Apply.

## If an IP address shows up in Thunar's sidebar

Thunar saves anything you open through `smb://` as a sidebar bookmark, and that bookmark contains the server's IP. Open the share through `~/SharedHome` instead. To remove an entry that already showed up, delete the bookmark line:

```bash
sed -i '/smb:\/\//d' ~/.config/gtk-3.0/bookmarks
```

If it is listed as a mounted network drive instead of a bookmark, unmount it (replace `SERVER_IP` with your server's address):

```bash
gio mount -u smb://SERVER_IP/sharedhome
```

The bookmarks file is listed in `.gitignore`, so it is never committed.
