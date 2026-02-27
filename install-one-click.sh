#!/bin/bash

# SealSuite VPN Monitor - One-Click Installation Script
# This script installs and configures the SealSuite VPN auto-reconnect monitor

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$HOME/Library/Scripts/sealsuite-vpn-monitor"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.sealsuite.vpnmonitor.plist"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🦭 SealSuite VPN Monitor - One-Click Installation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Step 1: Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script only works on macOS"
    exit 1
fi

echo "✓ Platform check: macOS detected"
echo ""

# Step 2: Create directories
echo "📁 Creating directories..."
mkdir -p "$SCRIPTS_DIR"
mkdir -p "$HOME/Library/Logs"
mkdir -p "$LAUNCH_AGENTS_DIR"
echo "✓ Directories created"
echo ""

# Step 3: Copy scripts
echo "📋 Copying scripts..."
cp "$SCRIPT_DIR/check_and_reconnect_vpn.sh" "$SCRIPTS_DIR/"
cp "$SCRIPT_DIR/toggle_vpn.scpt" "$SCRIPTS_DIR/"
chmod +x "$SCRIPTS_DIR/check_and_reconnect_vpn.sh"
echo "✓ Scripts copied and made executable"
echo ""

# Step 4: Install cliclick if needed
echo "🔧 Checking for cliclick..."
if ! command -v cliclick &> /dev/null; then
    echo "   Installing cliclick via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install cliclick
        echo "✓ cliclick installed"
    else
        echo "⚠️  Homebrew not found. cliclick not installed (optional)."
    fi
else
    echo "✓ cliclick already installed"
fi
echo ""

# Step 5: Install LaunchAgent
echo "🚀 Installing LaunchAgent..."
cp "$SCRIPT_DIR/$PLIST_NAME" "$LAUNCH_AGENTS_DIR/$PLIST_NAME"
echo "✓ LaunchAgent installed"
echo ""

# Step 6: Stop existing LaunchAgent if running
echo "🔄 Checking for existing LaunchAgent..."
launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
echo "✓ Stopped existing LaunchAgent (if any)"
echo ""

# Step 7: Load LaunchAgent
echo "▶️  Loading LaunchAgent..."
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME"
echo "✓ LaunchAgent loaded and running"
echo ""

# Step 8: Verify installation
echo "🔍 Verifying installation..."
sleep 2

if launchctl list | grep -q "com.sealsuite.vpnmonitor"; then
    echo "✓ LaunchAgent is running"
else
    echo "⚠️  LaunchAgent may not be running properly"
fi
echo ""

# Step 9: Display status
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Status:"
echo "   • Monitor: Running"
echo "   • Check Interval: Every 60 seconds"
echo "   • Auto-start: Enabled on login"
echo ""
echo "📖 Next Steps:"
echo ""
echo "   1️⃣  Enable Full Disk Access (CRITICAL):"
echo "      • System Settings → Privacy & Security → Full Disk Access"
echo "      • Click 🔒 to unlock (enter password)"
echo "      • Click + button"
echo "      • Add: /bin/bash"
echo "      • Add: Terminal (or your terminal app)"
echo "      • Enable toggles ✅"
echo ""
echo "   2️⃣  Test the monitor:"
echo "      • Toggle VPN OFF in SealSuite"
echo "      • Wait up to 60 seconds"
echo "      • VPN should auto-toggle back ON"
echo ""
echo "📈 Monitor Logs:"
echo "   tail -f ~/Library/Logs/sealsuite-vpn-monitor.log"
echo ""
echo "🔧 Useful Commands:"
echo "   • Stop:      launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
echo "   • Start:     launchctl load ~/Library/LaunchAgents/$PLIST_NAME"
echo "   • Uninstall: $SCRIPT_DIR/uninstall.sh"
echo ""
echo "🦭 SealSuite VPN Monitor is now protecting your connection!"
echo ""
