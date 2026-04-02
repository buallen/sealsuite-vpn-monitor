# 🦭 SealSuite VPN Monitor

**Automatically monitor and reconnect your SealSuite VPN when it disconnects.**

![macOS](https://img.shields.io/badge/macOS-14%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Shell Script](https://img.shields.io/badge/shell-bash-yellow)

---

## 🚨 Problem Solved

SealSuite VPN sometimes disconnects automatically, requiring manual intervention to toggle it back on. This tool monitors the connection every 60 seconds and sends you a **non-intrusive notification** when disconnection is detected, so you can quickly reconnect without constantly checking.

---

## ✨ Features

- ✅ **Automatic Monitoring** - Checks VPN status every 60 seconds
- ✅ **Smart Detection (v2.0)** - Dual-checks network connectivity and SealSuite UI state to prevent false alarms
- ✅ **Auto-Reconnect** - Automatically toggles VPN back ON when disconnected
- ✅ **Minimal Interruption** - Briefly activates window, clicks, returns focus
- ✅ **Background Service** - Runs via macOS LaunchAgent
- ✅ **Comprehensive Logging** - Track all monitoring activity
- ✅ **ClashX Friendly** - Smartly bypasses local proxies during health checks to prevent false positives
- ✅ **One-Click Install** - Simple installation script
- ✅ **Auto-Start** - Runs automatically on login

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

### 🤝 Using with ClashX?

If you are using **ClashX** or other proxies alongside SealSuite, check the [ClashX Coexistence Guide](CLASHX_COEXISTENCE.md) for optimization tips.

### Optional: For Better Click Accuracy

If auto-reconnect isn't working, calibrate the toggle coordinates:

```bash
cd ~/Documents/GitHub/sealsuite-vpn-monitor
./find_toggle_position.sh
```

This tool will help you find the exact position of the VPN toggle.

---

## 🧪 Testing

Test the monitor:

1. **Toggle VPN OFF** in SealSuite
2. **Wait up to 60 seconds** (monitor checks every minute)
3. **Watch** as the script:
   - Detects network is unreachable
   - Confirms SealSuite UI says "Off" or "00:00:00"
   - Briefly activates SealSuite window
   - Clicks the toggle
   - Returns focus to your previous app
   - Verifies connection restored

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
│   2. UI State Verification (AppleScript)│
│   • Read SealSuite window text          │
│   • Verify "Time connected" or "Off"    │
└──────────────┬──────────────────────────┘
               │
               ▼ (if UI confirmed OFF)
┌─────────────────────────────────────────┐
│   3. Auto-Toggle (AppleScript)          │
│   • Activate SealSuite briefly          │
│   • Click VPN toggle at coordinates     │
│   • Return focus to previous app        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   4. Verify & Notify                    │
│   • Wait 25s for tunnel to rebuild      │
│   • Re-check with curl                  │
│   • Send success notification           │
└─────────────────────────────────────────┘
```

### v2.0 Detection Optimization

To prevent false clicks during network lag, the script now:
1. Waits up to 60 seconds (with multiple retries) if Google is unreachable.
2. Specifically queries the SealSuite UI for the `Time connected` value and `VPN Connectivity` state.
3. Only triggers a click if both the network is down **AND** the UI explicitly shows the VPN is disconnected.

---

## ⚙️ Configuration

### Change Check Interval

Edit the LaunchAgent configuration:

```bash
nano ~/Library/LaunchAgents/com.sealsuite.vpnmonitor.plist
```

Change this line:
```xml
<key>StartInterval</key>
<integer>60</integer>  <!-- Seconds between checks -->
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
# Real-time logs
tail -f ~/Library/Logs/sealsuite-vpn-monitor.log

# All logs
cat ~/Library/Logs/sealsuite-vpn-monitor.log

# Error logs
cat ~/Library/Logs/sealsuite-vpn-monitor-stderr.log
```

### Stop Monitor

```bash
launchctl unload ~/Library/LaunchAgents/com.sealsuite.vpnmonitor.plist
```

### Start Monitor

```bash
launchctl load ~/Library/LaunchAgents/com.sealsuite.vpnmonitor.plist
```

### Uninstall

```bash
./uninstall.sh
```

---

## 📂 Project Structure

```text
sealsuite-vpn-monitor/
├── install-one-click.sh           # One-click installation script
├── check_and_reconnect_vpn.sh     # Main monitoring script (curl-based detection)
├── toggle_vpn_smart.scpt          # Smart toggle (activates, clicks, returns focus)
├── check_vpn_status.scpt          # VPN status checker (Reads UI state)
├── find_toggle_position.sh        # Coordinate calibration tool
├── com.sealsuite.vpnmonitor.plist # LaunchAgent configuration
├── uninstall.sh                   # Uninstallation script
├── test.sh                        # Testing script
├── LICENSE                        # MIT License
└── README.md                      # This file
```

---

## 🐛 Troubleshooting

### VPN Not Reconnecting

1. **Check accessibility permissions** (most common issue)
   - System Settings → Privacy & Security → Accessibility
   - Ensure `/bin/bash`, `osascript`, and Terminal are enabled ✅

2. **Check logs**
   ```bash
   tail -f ~/Library/Logs/sealsuite-vpn-monitor.log
   ```

3. **Verify LaunchAgent is running**
   ```bash
   launchctl list | grep sealsuite
   ```

### Toggle Click Not Working

If the script detects correctly but doesn't reconnect:

1. **Calibrate toggle coordinates**
   ```bash
   cd ~/Documents/GitHub/sealsuite-vpn-monitor
   ./find_toggle_position.sh
   ```

2. **Update the coordinates** in `toggle_vpn_smart.scpt`:
   ```applescript
   do shell script "cliclick c:YOUR_X,YOUR_Y"
   ```

---

## 📊 Logs Location

- **Main Log**: `~/Library/Logs/sealsuite-vpn-monitor.log`
- **Stdout**: `~/Library/Logs/sealsuite-vpn-monitor-stdout.log`
- **Stderr**: `~/Library/Logs/sealsuite-vpn-monitor-stderr.log`

---

## 🔒 Security & Privacy

- ✅ **Local Only** - Everything runs on your Mac
- ✅ **No Cloud** - No data sent anywhere
- ✅ **Open Source** - Fully transparent code
- ✅ **No Network Access** - Doesn't connect to external servers

---

## 💻 System Requirements

- **OS**: macOS 14+ (Sonoma or later)
- **App**: SealSuite VPN client installed
- **Permissions**: Full Disk Access, Accessibility

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests

---

## 📝 License

MIT License - Feel free to use and modify!

---

## 🙏 Acknowledgments

- Built for SealSuite VPN users
- Inspired by the need for reliable VPN connections

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/buallen/sealsuite-vpn-monitor/issues)
- **Discussions**: [GitHub Discussions](https://github.com/buallen/sealsuite-vpn-monitor/discussions)

---

## ⭐ Star This Repo

If this tool helped you, please give it a star! ⭐

---

**Made with ❤️ for the SealSuite community**
