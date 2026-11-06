# Dotfiles: Arch + Hyprland

Clean-install guide for a new Arch machine. Run the steps in order.

## 1. Base setup

```bash
sudo pacman -Syu
sudo pacman -S --needed git base-devel stow flatpak
```

Clone the repo into your home folder, so it ends up at `~/dotfiles`. It has to be there, because stow links relative to the parent folder:

```bash
cd ~
git clone https://github.com/SpotMcCormick/dotfiles.git
cd ~/dotfiles
```

## 2. Install packages

```bash
sudo pacman -S --needed - < pkglist.txt
```

If the new machine has no NVIDIA GPU, delete the `nvidia*` lines from `pkglist.txt` first.

Install yay, then the AUR packages:

```bash
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si
cd ~/dotfiles
yay -S --needed - < aurlist.txt
```

`displaylink` and `evdi-dkms` are only for the USB-C dock. Skip them if you don't need it.

Flatpaks:

```bash
flatpak install flathub $(cat flatpaklist.txt)
mkdir -p ~/.local/share/flatpak/overrides
cp flatpak/overrides/* ~/.local/share/flatpak/overrides/
```

## 3. Link configs with stow

Fresh installs may already have default configs that block stow. Remove them first:

```bash
rm -rf ~/.config/kitty ~/.config/rofi ~/.config/waybar ~/.config/yazi ~/.config/nvim ~/.config/hypr
```

Then:

```bash
cd ~/dotfiles
stow hypr kitty rofi waybar yazi nvim nwg-look nwg-displays harlequin
```

Hyprland expects `monitors.lua` and `workspaces.lua`, which `nwg-displays` generates. If Hyprland complains they are missing, open `nwg-displays` and click Apply.

## 4. Scripts

Hyprland calls these from `~/.local/bin`:

```bash
mkdir -p ~/.local/bin
cp scripts/docked.sh ~/.local/bin/docked
cp scripts/mobile.sh ~/.local/bin/mobile
chmod +x ~/.local/bin/docked ~/.local/bin/mobile
```

They disable and enable the laptop screen (`eDP-1`). Check the monitor name with `hyprctl monitors` on a new machine and edit the scripts if it differs.

## 5. Login screen (SDDM)

```bash
sudo cp sddm/sddm.conf /etc/sddm.conf
sudo cp sddm/silent-default.conf /usr/share/sddm/themes/silent/configs/default.conf
sudo systemctl enable sddm
```

## 6. Reboot

```bash
reboot
```

## Optional: SharedHome network drive

Create the credentials file (root only):

```bash
sudo mkdir -p /etc/samba
sudo nano /etc/samba/credentials     # username=... / password=... / domain=WORKGROUP
sudo chmod 600 /etc/samba/credentials
mkdir ~/SharedHome
```

Add this line to `/etc/fstab`, replacing `SERVER_IP` with the server's address (your Tailscale IP):

```
//SERVER_IP/sharedhome  /home/spotmccormick/SharedHome  cifs  credentials=/etc/samba/credentials,uid=1000,gid=1000,iocharset=utf8,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.requires=tailscaled.service  0  0
```

Needs `cifs-utils` and Tailscale. Start it with:

```bash
sudo systemctl daemon-reload
sudo systemctl start home-spotmccormick-SharedHome.automount
```
