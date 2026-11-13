-- Any monitor, any machine: native resolution, Hyprland picks the scale
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

-- Mirror the laptop panel onto the Dell when it's plugged in
hl.monitor({
    output = "desc:Dell Inc. DELL P2722H 2SM8DJ3",
    mode = "preferred",
    position = "auto",
    scale = 1.0,
    mirror = "eDP-1",
})
