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
- ✅ **Smart Detection** - Uses curl to test internet connectivity (most reliable method)
- ✅ **Auto-Reconnect** - Automatically toggles VPN back ON when disconnected
- ✅ **Minimal Interruption** - Briefly activates window, clicks, returns focus
- ✅ **Background Service** - Runs via macOS LaunchAgent
- ✅ **Comprehensive Logging** - Track all monitoring activity
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
   - Detects VPN is OFF (google.com not accessible)
   - Briefly activates SealSuite window
   - Clicks the toggle
   - Returns focus to your previous app
   - Verifies connection restored

Check logs in real-time:
```bash
tail -f ~/Library/Logs/sealsuite-vpn-monitor.log
```

You should see:
```
[timestamp] VPN is OFF (8.8.8.8 is NOT reachable)
[timestamp] VPN is DISCONNECTED. Will attempt to reconnect...
[timestamp] Toggle clicked. Verifying connection...
[timestamp] ✅ VPN reconnected successfully!
```

---

## 📖 How It Works

```
┌─────────────────────────────────────────┐
│   LaunchAgent (runs every 60 seconds)   │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   Check Script (Bash)                   │
│   • Is SealSuite running?               │
│   • ping 8.8.8.8 (VPN blocks it)        │
└──────────────┬──────────────────────────┘
               │
               ▼ (if google.com NOT accessible = VPN OFF)
┌─────────────────────────────────────────┐
│   AppleScript (Smart Toggle)            │
│   • Activate SealSuite briefly          │
│   • Click VPN toggle at coordinates     │
│   • Return focus to previous app        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   Verify & Notify                       │
│   • Re-check with curl                  │
│   • Send success/failure notification   │
└─────────────────────────────────────────┘
```

### Detection Method

The script uses `ping 8.8.8.8` to detect VPN status:
- **VPN ON** → 8.8.8.8 (Google DNS) is reachable → No action needed
- **VPN OFF** → 8.8.8.8 blocked by VPN policy → Auto-reconnect triggered

**Why ping instead of curl?**
- ⚡ Faster (ICMP vs HTTP)
- 💾 Less resource usage
- 🎯 More reliable for network detection

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

```
sealsuite-vpn-monitor/
├── install-one-click.sh           # One-click installation script
├── check_and_reconnect_vpn.sh     # Main monitoring script (curl-based detection)
├── toggle_vpn_smart.scpt          # Smart toggle (activates, clicks, returns focus)
├── check_vpn_status.scpt          # VPN status checker (optional)
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

   Look for:
   - `VPN is OFF (8.8.8.8 is NOT reachable)` - Detection working ✅
   - `Toggle clicked. Verifying connection...` - Click triggered ✅
   - `⚠️ Toggle clicked but VPN still OFF` - Coordinates wrong ❌

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

3. **Manually test the toggle**
   ```bash
   osascript ~/Library/Scripts/sealsuite-vpn-monitor/toggle_vpn_smart.scpt
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
