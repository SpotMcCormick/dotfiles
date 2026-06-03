# NVIDIA Setup Notes

ThinkPad P1 Gen 4 has Intel + NVIDIA graphics.

- Internal laptop screen: Intel GPU
- USB-C / dock external display: NVIDIA GPU

## Packages

Install:

    sudo pacman -S nvidia-open nvidia-utils nvidia-settings

Remove old Nouveau userspace packages if present:

    sudo pacman -Rns xf86-video-nouveau vulkan-nouveau

## Required files

/etc/modprobe.d/blacklist-nouveau.conf

    blacklist nouveau
    options nouveau modeset=0

/etc/modprobe.d/nvidia.conf

    options nvidia_drm modeset=1

/etc/mkinitcpio.conf must include:

    MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

After changes:

    sudo mkinitcpio -P
    sudo reboot

## Verify

    lsmod | grep -E 'nouveau|nvidia'
    nvidia-smi

Expected result:

- NVIDIA modules loaded
- Nouveau not loaded

## Dock commands

Docked, Dell only:

    hyprctl keyword monitor "eDP-1,disable"

Mobile, laptop only:

    hyprctl keyword monitor "eDP-1,preferred,auto,1.6"
