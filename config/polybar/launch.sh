#!/bin/bash
# Try to reload first, if that fails, restart
if ! polybar-msg cmd restart 2>/dev/null; then
    # Fallback to kill and restart
    killall -q polybar
    while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
    
    if type "xrandr"; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload main &
      done
    else
      polybar --reload main &
    fi
fi
