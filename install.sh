#!/bin/bash

# SealSuite VPN Monitor - Installation Script

set -e

SCRIPT_DIR="$HOME/Documents/GitHub/sealsuite-vpn-monitor"
PLIST_NAME="com.sealsuite.vpnmonitor.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

echo "🔧 Installing SealSuite VPN Auto-Reconnect Monitor..."
echo ""

# Step 1: Make scripts executable
echo "1️⃣ Making scripts executable..."
chmod +x "$SCRIPT_DIR/check_and_reconnect_vpn.sh"

# Step 2: Create logs directory
echo "2️⃣ Creating logs directory..."
mkdir -p "$HOME/Library/Logs"

# Step 3: Install cliclick if not present (for mouse clicking as fallback)
echo "3️⃣ Checking for cliclick (optional helper tool)..."
if ! command -v cliclick &> /dev/null; then
    echo "   cliclick not found. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install cliclick
    else
        echo "   ⚠️  Homebrew not found. cliclick not installed (optional)."
    fi
else
    echo "   ✅ cliclick is already installed"
fi

# Step 4: Copy LaunchAgent plist
echo "4️⃣ Installing LaunchAgent..."
mkdir -p "$LAUNCH_AGENTS_DIR"
cp "$SCRIPT_DIR/$PLIST_NAME" "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Step 5: Load the LaunchAgent
echo "5️⃣ Loading LaunchAgent..."
launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Important: Enable Accessibility Permissions"
echo "   1. Open System Settings > Privacy & Security > Accessibility"
echo "   2. Click the '+' button"
echo "   3. Add: /bin/bash"
echo "   4. Add: Terminal (or your terminal app)"
echo "   5. Enable the toggles for these apps"
echo ""
echo "📊 Monitor logs:"
echo "   tail -f $HOME/Library/Logs/sealsuite-vpn-monitor.log"
echo ""
echo "🔄 To uninstall:"
echo "   ./uninstall.sh"
echo ""
echo "🧪 To test manually:"
echo "   ./test.sh"
echo ""
