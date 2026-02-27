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

# Check VPN connection status by looking for VPN interfaces
# SealSuite typically creates utun interfaces when connected
VPN_CONNECTED=false

# Method 1: Check for utun interfaces with SealSuite patterns
if ifconfig | grep -A 3 "utun" | grep -q "inet"; then
    VPN_CONNECTED=true
    log "VPN appears to be connected (utun interface found)"
fi

# Method 2: Check scutil for VPN status (backup method)
if scutil --nc list | grep -q "Connected"; then
    VPN_CONNECTED=true
    log "VPN appears to be connected (scutil confirms)"
fi

# If VPN is not connected, trigger the toggle via AppleScript
if [ "$VPN_CONNECTED" = false ]; then
    log "VPN is DISCONNECTED. Attempting to reconnect..."

    # Run the AppleScript to click the VPN toggle
    osascript "$HOME/Documents/GitHub/sealsuite-vpn-monitor/toggle_vpn.scpt"

    if [ $? -eq 0 ]; then
        log "Successfully triggered VPN reconnect"
    else
        log "ERROR: Failed to trigger VPN reconnect via AppleScript"
    fi
else
    log "VPN is connected. No action needed."
fi
