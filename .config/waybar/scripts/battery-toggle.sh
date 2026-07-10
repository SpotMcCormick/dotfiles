#!/bin/bash

BAT="BAT0"

END=$(cat /sys/class/power_supply/$BAT/charge_control_end_threshold)

if [ "$END" = "100" ]; then
    echo 75 | sudo tee /sys/class/power_supply/$BAT/charge_control_start_threshold
    echo 80 | sudo tee /sys/class/power_supply/$BAT/charge_control_end_threshold
    notify-send "Battery Mode" "Power saver: 80%"
else
    echo 90 | sudo tee /sys/class/power_supply/$BAT/charge_control_start_threshold
    echo 100 | sudo tee /sys/class/power_supply/$BAT/charge_control_end_threshold
    notify-send "Battery Mode" "Performance: 100%"
fi
	
