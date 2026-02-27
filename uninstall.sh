#!/bin/bash

# SealSuite VPN Monitor - Uninstallation Script

PLIST_NAME="com.sealsuite.vpnmonitor.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

echo "🗑️  Uninstalling SealSuite VPN Auto-Reconnect Monitor..."

# Unload LaunchAgent
if [ -f "$LAUNCH_AGENTS_DIR/$PLIST_NAME" ]; then
    echo "Unloading LaunchAgent..."
    launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
    rm "$LAUNCH_AGENTS_DIR/$PLIST_NAME"
    echo "✅ LaunchAgent removed"
else
    echo "⚠️  LaunchAgent not found, skipping"
fi

echo ""
echo "✅ Uninstallation complete!"
echo ""
echo "Note: Log files and scripts in $HOME/Documents/GitHub/sealsuite-vpn-monitor"
echo "have been preserved. You can manually delete them if desired."
echo ""
