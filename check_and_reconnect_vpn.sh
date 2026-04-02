#!/bin/bash

# SealSuite VPN Auto-Reconnect Monitor
# Core Goal: Automatically toggle ON the VPN connectivity button when SealSuite silently drops it.

LOG_FILE="$HOME/Library/Logs/sealsuite-vpn-monitor.log"
MAX_LOG_SIZE=1048576  # 1MB

if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
    mv "$LOG_FILE" "$LOG_FILE.old"
fi

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ==========================================
# 1. Physical Network Pre-check
# ==========================================
if ! ping -c 1 -W 2000 223.5.5.5 > /dev/null 2>&1; then
    exit 0
fi

# ==========================================
# 2. VPN Connectivity Check (Google as metric)
# ==========================================
check_google() {
    curl -s -I -m 5 -L https://www.google.com | grep -q "HTTP/.* 200\|HTTP/.* 30"
}

VPN_HEALTHY=true

if ! check_google; then
    log "Initial Google check failed. Waiting 20s for possible lag spike..."
    sleep 20
    
    if ! check_google; then
        log "Still dead after 20s. Waiting another 40s to confirm SealSuite dropped..."
        sleep 40
        
        if ! check_google; then
            log "Google unreachable for 60s+. Checking SealSuite UI state..."
            
            # Double check if the app says it's OFF
            UI_STATE=$(osascript "$HOME/Library/Scripts/sealsuite-vpn-monitor/check_vpn_status_smart.scpt" 2>/dev/null)
            log "SealSuite UI reports state: $UI_STATE"
            
            if [[ "$UI_STATE" == "off" ]] || [[ "$UI_STATE" == "app_not_running" ]]; then
                log "Conclusion: SealSuite VPN button is OFF. Proceeding with auto-toggle."
                VPN_HEALTHY=false
            else
                log "UI state is $UI_STATE. Avoiding false toggle."
                VPN_HEALTHY=true
            fi
        else
            log "Recovered during 40s wait."
            VPN_HEALTHY=true
        fi
    else
        log "Recovered during 20s wait."
        VPN_HEALTHY=true
    fi
fi

# ==========================================
# 3. Auto-Toggle Action
# ==========================================
if [ "$VPN_HEALTHY" = false ]; then
    
    if ! pgrep -x "SealSuite" > /dev/null; then
        log "SealSuite wasn't running. Starting it..."
        open -a "SealSuite"
        sleep 8
    fi

    log "Executing AppleScript to click the VPN toggle button..."
    osascript "$HOME/Library/Scripts/sealsuite-vpn-monitor/toggle_vpn_smart.scpt" 2>&1

    if [ $? -eq 0 ]; then
        log "Button clicked. Waiting 25s for tunnel to rebuild..."
        sleep 25
        
        if check_google; then
            log "✅ SUCCESS: Tunnel rebuilt. Google is reachable."
            osascript -e 'display notification "VPN silently toggled back ON!" with title "🦭 VPN Monitor" sound name "Tink"' 2>/dev/null
        else
            log "⚠️ WARNING: Clicked the button, waited 25s, but Google still unreachable."
        fi
    else
        log "ERROR: AppleScript failed to click the button."
    fi
fi
