# Jeremy's Arch Hyprland Dotfiles

Personal Arch Linux workstation configuration.

## Included

* Hyprland
* Waybar
* Kitty
* Rofi
* Hyprlock
* Hyprpaper
* Silent SDDM Theme
* JetBrains Mono Nerd Font
* Tux Tron Wallpaper
* Package Lists

## Restore After Fresh Install

Clone repository:

```bash
git clone git@github.com:SpotMcCormick/dotfiles.git
cd dotfiles
```

Install packages:

```bash
sudo pacman -S --needed - < pkglist.txt
yay -S --needed - < aurlist.txt
```

Restore configuration files:

```bash
mkdir -p ~/.config

cp -r .config/hypr ~/.config/
cp -r .config/waybar ~/.config/
cp -r .config/kitty ~/.config/
cp -r .config/rofi ~/.config/
```

Restore wallpaper:

```bash
mkdir -p ~/Pictures/desktop_wallpaper

cp wallpapers/tux_tron.png \
~/Pictures/desktop_wallpaper/
```

Restore Silent SDDM configuration:

```bash
sudo cp sddm/default.conf \
/usr/share/sddm/themes/silent/configs/

sudo cp sddm/metadata.desktop \
/usr/share/sddm/themes/silent/
```

Reload Hyprland:

```bash
hyprctl reload
```

## Keybindings

| Key           | Action           |
| ------------- | ---------------- |
| Super + T     | Kitty            |
| Super + B     | Brave            |
| Super + C     | VS Code / Cursor |
| Super + M     | Spotify          |
| Super + F     | Thunar           |
| Super + Q     | Close Window     |
| Super + S     | Power Menu       |
| Super + Space | Rofi             |
| Super + L     | Hyprlock         |

## Notes

* Dell monitor configured through HDMI.
* Silent SDDM uses JetBrains Mono Nerd Font.
* Wallpaper: Tux Tron.
* Hyprlock and SDDM are styled to match.
* Package lists are stored for rebuilding the workstation.
# dotfiles
