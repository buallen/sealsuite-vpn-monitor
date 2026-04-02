# 🤝 SealSuite & ClashX Coexistence Guide

When running both **SealSuite** (for company VPN) and **ClashX** (for international web access), conflicts can occur. This monitor has been optimized to handle this specific environment.

## 🛠 What We Did

### 1. Smart Detection (Bypassing ClashX)
The monitor uses `curl --noproxy "*"` to check connectivity. This ensures that:
- We are testing the **direct tunnel** created by SealSuite.
- We don't get a "false positive" (thinking VPN is on just because ClashX is reachable).

### 2. Dual-Metric Verification
We check both:
- **Internal Health**: Checking an internal company domain (e.g., `storehubhq.com`) which ClashX typically ignores.
- **External Health**: Checking `google.com` which confirms if the international tunnel provided by SealSuite is active.

### 3. Automated Conflict Resolution
If the script detects that network settings are being fought over:
- It can briefly toggle ClashX to **Direct Mode** or **Direct Proxy** during the SealSuite reconnection phase to ensure the VPN handshake completes without interference.

## ⚙️ Recommended ClashX Configuration

To ensure the best experience, add your company domains to the **Bypass** list in ClashX:

1. Open ClashX Settings.
2. Go to **Bypass / Skip List**.
3. Add: `*.storehub.com`, `*.storehubhq.com`.

## 🔄 Monitor Logic for ClashX Users

```bash
# How the script handles the check:
curl -s -I --noproxy "*" -m 3 https://auth.storehubhq.com
# If this fails -> SealSuite is disconnected, regardless of ClashX state.
```
