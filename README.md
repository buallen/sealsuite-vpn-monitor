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
- ✅ **Smart Detection** - Accurately detects VPN state by checking corporate routes
- ✅ **Non-Intrusive Notifications** - Alerts you without interrupting your work
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

**After installation, you MUST enable Full Disk Access:**

1. Open **System Settings** → **Privacy & Security** → **Full Disk Access**
2. Click **🔒** to unlock (enter your password)
3. Click **+** button
4. Add: `/bin/bash`
5. Add: **Terminal** (or your terminal app)
6. Enable the toggles ✅

**Without these permissions, auto-reconnect won't work!**

---

## 🧪 Testing

Test the monitor:

1. **Toggle VPN OFF** in SealSuite
2. **Wait up to 60 seconds**
3. **Watch** as VPN automatically toggles back ON

Check logs:
```bash
tail -f ~/Library/Logs/sealsuite-vpn-monitor.log
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
│   • Is VPN connected?                   │
└──────────────┬──────────────────────────┘
               │
               ▼ (if VPN is OFF)
┌─────────────────────────────────────────┐
│   AppleScript (GUI Automation)          │
│   • Click VPN toggle in SealSuite       │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   Logging (all actions tracked)         │
└─────────────────────────────────────────┘
```

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
├── check_and_reconnect_vpn.sh     # Main monitoring script
├── toggle_vpn.scpt                # AppleScript for GUI automation
├── com.sealsuite.vpnmonitor.plist # LaunchAgent configuration
├── uninstall.sh                   # Uninstallation script
├── test.sh                        # Testing script
└── README.md                      # This file
```

---

## 🐛 Troubleshooting

### VPN Not Reconnecting

1. **Check accessibility permissions** (most common issue)
   - System Settings → Privacy & Security → Full Disk Access
   - Ensure `/bin/bash` and Terminal are enabled

2. **Check logs**
   ```bash
   tail -f ~/Library/Logs/sealsuite-vpn-monitor.log
   ```

3. **Verify LaunchAgent is running**
   ```bash
   launchctl list | grep sealsuite
   ```

### AppleScript Errors

If the AppleScript can't find the toggle button, you may need to adjust the UI automation logic in `toggle_vpn.scpt`.

Use **Accessibility Inspector** (in Xcode) to inspect SealSuite's UI hierarchy.

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
