#!/bin/bash

# Tool to find the exact position of the VPN toggle
# This will help calibrate the auto-click coordinates

echo "🎯 VPN Toggle Position Finder"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Instructions:"
echo "1. Open SealSuite window"
echo "2. Hover your mouse over the CENTER of the VPN toggle"
echo "3. Press ENTER in this terminal"
echo ""
read -p "Press ENTER when mouse is over the toggle..."

# Get current mouse position
MOUSE_POS=$(cliclick p)
echo ""
echo "Mouse position: $MOUSE_POS"

# Extract X and Y
X=$(echo $MOUSE_POS | cut -d',' -f1)
Y=$(echo $MOUSE_POS | cut -d',' -f2)

echo ""
echo "Coordinates found:"
echo "  X: $X"
echo "  Y: $Y"
echo ""

# Get SealSuite window position
WIN_INFO=$(osascript -e 'tell application "System Events" to tell process "SealSuite" to get {position of window 1, size of window 1}')
echo "Window info: $WIN_INFO"

# Save to config
cat > ~/Library/Scripts/sealsuite-vpn-monitor/toggle_coordinates.conf << EOF
# VPN Toggle Coordinates
# Auto-generated on $(date)
TOGGLE_X=$X
TOGGLE_Y=$Y
WINDOW_INFO=$WIN_INFO
EOF

echo ""
echo "✅ Coordinates saved to:"
echo "   ~/Library/Scripts/sealsuite-vpn-monitor/toggle_coordinates.conf"
echo ""
echo "🧪 Testing click at ($X, $Y)..."
sleep 2
cliclick c:$X,$Y

echo ""
echo "Did the toggle work? (y/n)"
read -p "> " RESPONSE

if [[ "$RESPONSE" =~ ^[Yy]$ ]]; then
    echo "✅ Great! Coordinates are correct and saved."
    echo ""
    echo "Next: Update the toggle_vpn.scpt to use these coordinates"
else
    echo "❌ Click didn't work. Please try again."
    echo "   Make sure you hover precisely over the toggle center."
fi
