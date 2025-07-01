#!/bin/bash

# Generate system information for rofi
get_system_info() {
    echo "🖥️  CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs | cut -c1-40)"
    echo "⚡ Cores: $(nproc) | Load: $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')"
    echo "🧠 $(free | grep '^Mem:' | awk '{printf "Memory: %.1f%% used", $3/$2*100}')"
    echo "💾 $(df -h / | tail -1 | awk '{printf "Disk: %s used (%s)", $3, $5}')"
    echo "⏰ Uptime: $(uptime -p)"
    echo "📊 Open htop"
    echo "📈 Open System Monitor"
}

# Show rofi menu
selection=$(get_system_info | rofi -dmenu -i -p "System Info" \
    -theme ~/dotfiles/config/rofi/themes/style-1.rasi 
)
# Handle selection
case "$selection" in
    *"Open htop"*) alacritty -e htop & ;;
    *"Open System Monitor"*) gnome-system-monitor 2>/dev/null ;;
esac
