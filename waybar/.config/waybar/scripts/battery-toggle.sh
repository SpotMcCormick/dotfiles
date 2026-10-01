#!/bin/bash

CURRENT=$(powerprofilesctl get)

if [ "$CURRENT" = "performance" ]; then
    powerprofilesctl set power-saver
    notify-send "Power Profile" "Battery saver mode"
else
    powerprofilesctl set performance
    notify-send "Power Profile" "Performance mode"
fi	
