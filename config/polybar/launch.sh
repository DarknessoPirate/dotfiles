#!/bin/bash
# Try to reload first, if that fails, restart
if ! polybar-msg cmd restart 2>/dev/null; then
    # Fallback to kill and restart
    killall -q polybar
    while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
    
    if type "xrandr"; then
        # Get primary monitor (or specify your preferred one)
        PRIMARY_MONITOR=$(xrandr --query | grep "primary" | cut -d" " -f1)
        
        # If no primary is set, use the first connected monitor
        if [ -z "$PRIMARY_MONITOR" ]; then
            PRIMARY_MONITOR=$(xrandr --query | grep " connected" | head -n1 | cut -d" " -f1)
        fi
        
        # Launch bar with tray on primary monitor first
        MONITOR=$PRIMARY_MONITOR polybar --reload main &
        sleep 0.5  # Small delay to ensure this bar gets the tray
        
        # Launch bars on other monitors
        for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
            if [ "$m" != "$PRIMARY_MONITOR" ]; then
                MONITOR=$m polybar --reload main &
            fi
        done
    else
        polybar --reload main &
    fi
fi
