#!/bin/bash
# System Resource Monitor

OUTPUT="$HOME/SecureTerminalAPK/logs/system_monitor.log"

while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    MEM=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
    DISK=$(df -h / | awk 'NR==2{print $5}')
    
    echo "[$TIMESTAMP] CPU: $CPU% | MEM: $MEM | DISK: $DISK" >> "$OUTPUT"
    
    sleep 60
done
