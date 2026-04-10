# 🦭 SealSuite VPN Monitor

**Automatically monitor and reconnect your SealSuite VPN when it disconnects.**

![macOS](https://img.shields.io/badge/macOS-14%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Shell Script](https://img.shields.io/badge/shell-bash-yellow)

---

## 🚨 Problem Solved

SealSuite VPN sometimes disconnects automatically, requiring manual intervention to toggle it back on. This tool monitors the connection every 60 seconds and sends you a **non-intrusive notification** when disconnection is detected, so you can quickly reconnect without constantly checking.

---

## ✨ Features (v2.4 Pro)

- ✅ **Automatic Monitoring** - Checks VPN status every 60 seconds.
- ✅ **Smart Detection** - Dual-checks network connectivity and SealSuite UI state to prevent false alarms.
- ✅ **Robust Window Handling** - Automatically uses `reopen` to restore the SealSuite window even if it was manually closed (Fixes "Invalid Index" errors).
- ✅ **Dynamic Coordinates** - Automatically calculates the toggle button position based on the SealSuite window location. Works on any monitor!
- ✅ **UI State Verification** - Briefly brings the app to the front to read real-time connection status (Handles Electron rendering issues).
- ✅ **Minimal Interruption** - Saves and restores your active window focus in under 1 second.
- ✅ **Detailed Error Logging** - Captures and logs full AppleScript error messages for easier troubleshooting.
- ✅ **Background Service** - Runs via macOS LaunchAgent.
- ✅ **One-Click Install** - Simple installation script.

---

## 🚀 Quick Installation

### One-Click Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/buallen/sealsuite-vpn-monitor/main/install-one-click.sh | bash
```

Or clone and install:

```bash
git clone https://github.com/buallen/sealsuite-vpn-monitor.git
cd sealsuite-vpn-monitor
chmod +x install-one-click.sh
./install-one-click.sh
```

---

## 🔐 Important: Enable Permissions

**After installation, you MUST enable Accessibility permissions:**

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Click **🔒** to unlock (enter your password)
3. Click **+** button
4. Add: `/bin/bash`
5. Add: `osascript` (located at `/usr/bin/osascript`)
6. Add: **Terminal** (or your terminal app)
7. Enable all toggles ✅

**Without these permissions, auto-reconnect won't work!**

---

## 🧪 Testing

Test the monitor:

1. **Toggle VPN OFF** in SealSuite.
2. **Wait up to 60 seconds** (monitor checks every minute).
3. **Watch** as the script:
   - Detects network is unreachable.
   - Restores the SealSuite window (even if closed).
   - Confirms UI says "Off" or "00:00:00".
   - Calculates the button position and clicks it.
   - Restores your previous app focus.
   - Verifies connection restored.

Check logs in real-time:
```bash
tail -f ~/Library/Logs/sealsuite-vpn-monitor.log
```

---

## 📖 How It Works

```text
┌─────────────────────────────────────────┐
│   LaunchAgent (runs every 60 seconds)   │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   1. Network Check (Bash)               │
│   • Ping 223.5.5.5 (Physical online?)   │
│   • Curl google.com (VPN working?)      │
└──────────────┬──────────────────────────┘
               │
               ▼ (if google.com NOT accessible)
┌─────────────────────────────────────────┐
│   2. UI State Verification (Smart)      │
│   • Restore/Activate SealSuite window   │
│   • Read "Time connected" / Labels      │
│   • Restore previous app focus          │
└──────────────┬──────────────────────────┘
               │
               ▼ (if UI confirmed OFF)
┌─────────────────────────────────────────┐
│   3. Auto-Toggle (Dynamic)              │
│   • Ensure window exists (Retry reopen) │
│   • Get current window X, Y coordinates │
│   • Calculate relative button position  │
│   • Click VPN toggle                    │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   4. Verify & Notify                    │
│   • Wait 25s for tunnel to rebuild      │
│   • Send success notification           │
└─────────────────────────────────────────┘
```

### v2.4 Optimization

1. **Zero-Window Resilience**: Older versions failed if you closed the SealSuite window. v2.4 uses the `reopen` command to forcefully bring the UI back before interacting.
2. **Anti-Drift**: Uses AppleScript to query the SealSuite window's position and size. It then calculates the click target as a percentage of the window size. This means the script works even if you move the window to a secondary monitor.
3. **Absolute Paths**: All background dependencies (like `cliclick`) now use absolute paths to ensure they run correctly under the LaunchAgent's restricted environment.

---

## ⚙️ Configuration

### Change Check Interval

Edit the LaunchAgent configuration:

```bash
nano ~/Library/LaunchAgents/com.sealsuite.vpnmonitor.plist
```

Reload after changing:
```bash
launchctl unload ~/Library/LaunchAgents/com.sealsuite.vpnmonitor.plist
launchctl load ~/Library/LaunchAgents/com.sealsuite.vpnmonitor.plist
```

---

## 🔧 Management Commands

### Check Status
```bash
launchctl list | grep sealsuite
```

### View Logs
```bash
tail -f ~/Library/Logs/sealsuite-vpn-monitor.log
```

### Stop Monitor
```bash
launchctl unload ~/Library/LaunchAgents/com.sealsuite.vpnmonitor.plist
```

---

## 📂 Project Structure

```text
sealsuite-vpn-monitor/
├── check_and_reconnect_vpn.sh     # Main monitoring logic
├── check_vpn_status_smart.scpt    # Smart UI state checker (with focus restoration)
├── toggle_vpn_smart.scpt          # Dynamic coordinate clicker
├── com.sealsuite.vpnmonitor.plist # macOS LaunchAgent config
└── install-one-click.sh           # Setup script
```

---

## 🔒 Security & Privacy

- ✅ **Local Only** - Everything runs on your Mac.
- ✅ **Open Source** - Fully transparent code.
- ✅ **No Cloud** - No data is collected or sent.

---

## 🤝 Contributing

Contributions are welcome! MIT License - Feel free to use and modify!

---

**Made with ❤️ for the SealSuite community**
