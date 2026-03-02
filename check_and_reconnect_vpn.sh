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
# Method: Ping google.com - if it fails, VPN is OFF (faster than curl)
VPN_CONNECTED=false

# Ping google.com with 2 second timeout (1 packet)
if ping -c 1 -W 2000 8.8.8.8 > /dev/null 2>&1; then
    VPN_CONNECTED=true
    log "VPN is ON (8.8.8.8 is reachable)"
else
    VPN_CONNECTED=false
    log "VPN is OFF (8.8.8.8 is NOT reachable)"
fi

# If VPN is not connected, auto-reconnect
if [ "$VPN_CONNECTED" = false ]; then
    log "VPN is DISCONNECTED. Will attempt to reconnect..."

    # IMPORTANT: Only click the toggle if it's currently in OFF state
    # Clicking when it's ON would turn it OFF!

    # Run the smart toggle script that:
    # 1. Activates SealSuite briefly
    # 2. Clicks the toggle
    # 3. Returns focus to previous app
    osascript "$HOME/Library/Scripts/sealsuite-vpn-monitor/toggle_vpn_smart.scpt" 2>&1

    if [ $? -eq 0 ]; then
        log "Toggle clicked. Verifying connection..."

        # Wait for connection to establish
        sleep 5

        # Re-check if VPN is now connected
        if netstat -rn | grep -E "^10\." | grep -v "^10\.0\.0\." | grep -q "utun" || netstat -rn | grep -E "^172\.(1[6-9]|2[0-9]|3[01])\." | grep -q "utun"; then
            log "✅ VPN reconnected successfully!"
            osascript -e 'display notification "VPN reconnected successfully!" with title "🦭 VPN Monitor" sound name "Tink"' 2>/dev/null
        else
            log "⚠️ Toggle clicked but VPN still OFF - coordinates may be wrong"
            osascript -e 'display notification "VPN toggle clicked but still OFF. Please check manually." with title "🦭 VPN Monitor" sound name "Glass"' 2>/dev/null
        fi
    else
        log "ERROR: Failed to execute toggle script"
        osascript -e 'display notification "Auto-reconnect failed. Please reconnect manually." with title "🦭 VPN Monitor Error" sound name "Basso"' 2>/dev/null
    fi
else
    log "VPN is connected. No action needed."
fi
