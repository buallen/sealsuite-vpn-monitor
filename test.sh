#!/bin/bash

# SealSuite VPN Monitor - Test Script
# This script tests the VPN monitor without installing the LaunchAgent

SCRIPT_DIR="$HOME/Documents/GitHub/sealsuite-vpn-monitor"

echo "🧪 Testing SealSuite VPN Monitor..."
echo ""

echo "1️⃣ Checking if SealSuite is running..."
if pgrep -x "SealSuite" > /dev/null; then
    echo "   ✅ SealSuite is running"
else
    echo "   ❌ SealSuite is NOT running"
    echo "   Starting SealSuite..."
    open -a "SealSuite"
    sleep 3
fi

echo ""
echo "2️⃣ Checking VPN connection status..."

# Check for utun interfaces
if ifconfig | grep -A 3 "utun" | grep -q "inet"; then
    echo "   ✅ VPN appears to be connected (utun interface detected)"
else
    echo "   ❌ VPN appears to be disconnected"
fi

# Check scutil
if scutil --nc list | grep -q "Connected"; then
    echo "   ✅ VPN confirmed connected (scutil)"
else
    echo "   ⚠️  No VPN connection found via scutil"
fi

echo ""
echo "3️⃣ Running the monitor script once..."
bash "$SCRIPT_DIR/check_and_reconnect_vpn.sh"

echo ""
echo "4️⃣ Checking logs..."
if [ -f "$HOME/Library/Logs/sealsuite-vpn-monitor.log" ]; then
    echo "   Latest log entries:"
    tail -n 5 "$HOME/Library/Logs/sealsuite-vpn-monitor.log"
else
    echo "   ⚠️  No log file found yet"
fi

echo ""
echo "✅ Test complete!"
echo ""
echo "💡 To monitor in real-time:"
echo "   tail -f $HOME/Library/Logs/sealsuite-vpn-monitor.log"
echo ""
