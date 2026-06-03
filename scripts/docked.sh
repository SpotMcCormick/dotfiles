#!/usr/bin/env bash

external=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -n1)

if [ -z "$external" ]; then
  notify-send "Docked Mode" "No external monitor found"
  exit 1
fi

hyprctl keyword monitor "$external,preferred,auto,1"
sleep 1
hyprctl keyword monitor "eDP-1,disable"

notify-send "Docked Mode" "Using $external"
