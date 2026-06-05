#!/usr/bin/env bash
sleep 5
hyprctl keyword monitor "eDP-1,2560x1600@60,0x0,1.6"
sleep 1
hyprctl dispatch focusmonitor eDP-1
notify-send "Mobile Mode" "Laptop display enabled"
