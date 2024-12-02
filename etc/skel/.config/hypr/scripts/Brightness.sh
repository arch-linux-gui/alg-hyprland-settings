#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for Monitor backlights (if supported) using brightnessctl

iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000

# Get brightness
get_backlight() {
    echo $(pkexec brillo -G | awk '{print int($1+0.5)}')
}

# Get icons
get_icon() {
    current=$(get_backlight)
    if   [ "$current" -le "20" ]; then
        icon="$iDIR/brightness-20.png"
    elif [ "$current" -le "40" ]; then
        icon="$iDIR/brightness-40.png"
    elif [ "$current" -le "60" ]; then
        icon="$iDIR/brightness-60.png"
    elif [ "$current" -le "80" ]; then
        icon="$iDIR/brightness-80.png"
    else
        icon="$iDIR/brightness-100.png"
    fi
}

# Notify
notify_user() {
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$icon" "Brightness : $current%"
}

# Change brightness
change_backlight() {
    pkexec brillo -q "$1" && get_icon && notify_user
}

# Execute accordingly
case "$1" in
    "--get")
        get_backlight
        ;;
    "--inc")
        change_backlight "-A 5"
        ;;
    "--dec")
        change_backlight "-U 5"
        ;;
    *)
        get_backlight
        ;;
esac
