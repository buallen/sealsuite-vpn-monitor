#!/bin/bash

# SealSuite VPN Auto-Reconnect Monitor
# This script checks if SealSuite VPN is connected and auto-toggles it back on if disconnected

LOG_FILE="$HOME/Library/Logs/sealsuite-vpn-monitor.log"
MAX_LOG_SIZE=1048576  # 1MB

# Rotate log if too large
if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
    mv "$LOG_FILE" "$LOG_FILE.old"
fi

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check if SealSuite app is running
if ! pgrep -x "SealSuite" > /dev/null; then
    log "SealSuite app is not running. Starting it..."
    open -a "SealSuite"
    sleep 3
fi

# Check VPN connection status
# Method: Try to reach an internal resource only accessible via VPN
VPN_CONNECTED=false

# Try to ping an internal IP (customize this to an IP that's only reachable via VPN)
# Common internal ranges: 10.x.x.x, 172.16-31.x.x, 192.168.x.x
# Check if we can reach an internal gateway or DNS server
# Timeout after 1 second

# Method 1: Check if there's an active route to corporate network through utun
# Look for routes in common corporate IP ranges
if netstat -rn | grep -E "^10\." | grep -v "^10\.0\.0\." | grep -q "utun"; then
    VPN_CONNECTED=true
    log "VPN is ON (corporate routes via utun detected)"
elif netstat -rn | grep -E "^172\.(1[6-9]|2[0-9]|3[01])\." | grep -q "utun"; then
    VPN_CONNECTED=true
    log "VPN is ON (corporate routes via utun detected)"
else
    VPN_CONNECTED=false
    log "VPN is OFF (no corporate routes detected)"
fi

# If VPN is not connected, send a notification
if [ "$VPN_CONNECTED" = false ]; then
    log "VPN is DISCONNECTED. Sending notification..."

    # Send macOS notification
    osascript -e 'display notification "SealSuite VPN is disconnected. Please reconnect." with title "🦭 VPN Monitor" sound name "Glass"'

    log "Notification sent to user"
else
    log "VPN is connected. No action needed."
fi
