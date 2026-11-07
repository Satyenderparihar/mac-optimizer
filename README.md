# ⚡ mac-optimizer — Autonomous macOS Performance & Keyboard Optimizer

Permanent background optimization engine designed for macOS (MacBook Pro, MacBook Air, Mac mini, iMac, Mac Studio). Eliminates keyboard lag, button freeze, unneeded junk caches, and runaway background processes.

---

## 🚀 1-Command Instant Setup (Run Anywhere)

Open your Mac Terminal and paste this single command:

```bash
curl -sSL https://raw.githubusercontent.com/Satyenderparihar/mac-optimizer/main/install.sh | bash
```

*(Or clone the repository and run `./install.sh`)*

Everything is configured, activated, and scheduled automatically in 1 second!

---

## 🛠️ What Does It Automate?

### 1. ⌨️ Instant & Responsive Keyboard
- **Key Repeat Speed**: `KeyRepeat = 2` (Ultra-fast responsive typing).
- **Initial Delay**: `InitialKeyRepeat = 15` (Instant key reaction when held).
- **Press & Hold Trap Disabled**: `ApplePressAndHoldEnabled = false` (Disables the accent character popup that causes keys to freeze or drop inputs).
- **Autocorrect Lag Disabled**: Prevents system freeze during fast typing or Hinglish/code input.

### 2. ⚡ UI & Window Latency Elimination
- Minimizes window resize animation delay (`0.001s`).
- Speeds up Dock and Mission Control transition animations (`0.12s` - `0.15s`).

### 3. 🧹 Automatic Junk Cache Purging
- **Homebrew Cache**: Automatically removes gigabytes of obsolete package downloads.
- **Telegram Media Cache**: Cleans corrupted media cache that can peg the CPU at 100%+.
- **Google Chrome Safe Cache**: Flushes temporary code caches (leaves history, logins, and bookmarks untouched).
- **Diagnostic Reports**: Removes old crash logs to free disk space.

### 4. 🧠 Memory & System Cache Refresh
- Flushes DNS & Directory Services cache (`dscacheutil -flushcache`).
- Rebuilds QuickLook preview cache (`qlmanage -r cache`).
- Purges inactive system RAM memory (`purge`).

---

## 🕒 Autonomous Schedule (Zero User Intervention)

Registered as a native macOS `LaunchAgent` (`com.satyanarayan.macoptimizer`):
1. **On Boot / Login**: Runs immediately whenever the Mac turns on.
2. **Every Morning at 8:00 AM**: Flushes cache and memory for a fresh workday.
3. **Every Afternoon at 2:00 PM**: Cleans intermediate app caches to maintain peak responsiveness.

---

## 📊 How to Check Logs & Health

Check the optimizer log anytime:
```bash
cat ~/.mac_optimizer/optimizer.log
```

Manually trigger an instant optimization anytime:
```bash
bash ~/.mac_optimizer/mac_cleaner.sh
```

---

## 🗑️ How to Uninstall
If you ever want to remove it:
```bash
curl -sSL https://raw.githubusercontent.com/Satyenderparihar/mac-optimizer/main/uninstall.sh | bash
```
*(Or run `./uninstall.sh` if cloned)*
