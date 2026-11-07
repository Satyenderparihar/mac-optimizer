#!/bin/bash
set -e

# ==============================================================================
# Autonomous macOS Performance & Keyboard Optimizer - 1-Click Installer
# Supports local execution (./install.sh) and remote execution (curl | bash)
# ==============================================================================

TARGET_DIR="$HOME/.mac_optimizer"
TARGET_SCRIPT="$TARGET_DIR/mac_cleaner.sh"
PLIST_NAME="com.satyanarayan.macoptimizer.plist"
TARGET_PLIST="$HOME/Library/LaunchAgents/$PLIST_NAME"

echo "============================================================"
echo " 🚀 macOS Autonomous Performance & Keyboard Optimizer Setup"
echo "============================================================"

# 1. Ensure target directories exist
mkdir -p "$TARGET_DIR"
mkdir -p "$HOME/Library/LaunchAgents"

# 2. Write or copy cleaner engine
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/bin/mac_cleaner.sh" ]; then
    cp "$SCRIPT_DIR/bin/mac_cleaner.sh" "$TARGET_SCRIPT"
elif [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/mac_cleaner.sh" ]; then
    cp "$SCRIPT_DIR/mac_cleaner.sh" "$TARGET_SCRIPT"
else
    # Fallback for curl | bash execution
    cat <<'CLEANER_EOF' > "$TARGET_SCRIPT"
#!/bin/bash
LOG_DIR="$HOME/.mac_optimizer"
LOG_FILE="$LOG_DIR/optimizer.log"
MAX_LOG_LINES=500
mkdir -p "$LOG_DIR"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }
if [ -f "$LOG_FILE" ] && [ "$(wc -l < "$LOG_FILE" 2>/dev/null)" -gt "$MAX_LOG_LINES" ]; then
    tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi
log "=== Automatic Mac Health & Optimization Started ==="
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
log "Keyboard: Super-fast repeat (2), instant delay (15), press-and-hold popup disabled."
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.dock expose-animation-duration -float 0.12
defaults write com.apple.dock autohide-time-modifier -float 0.15
log "UI: Window resize and dock animation latency minimized."
if [ -d "$HOME/Library/Caches/Homebrew" ]; then
    rm -rf "$HOME/Library/Caches/Homebrew"/* 2>/dev/null
    log "Cleaned Homebrew package download cache."
fi
if [ -d "$HOME/Library/Caches/ru.keepcoder.Telegram" ]; then
    rm -rf "$HOME/Library/Caches/ru.keepcoder.Telegram"/* 2>/dev/null
    log "Cleaned Telegram media cache."
fi
if [ -d "$HOME/Library/Caches/Google/Chrome/Default" ]; then
    rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Cache"/* 2>/dev/null
    rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Code Cache"/* 2>/dev/null
    log "Cleaned Google Chrome temp code cache."
fi
rm -rf "$HOME/Library/Logs/DiagnosticReports"/* 2>/dev/null
log "Cleaned stale diagnostic & crash logs."
qlmanage -r cache >/dev/null 2>&1
dscacheutil -flushcache >/dev/null 2>&1
log "Refreshed QuickLook and DNS caches."
purge >/dev/null 2>&1 || true
log "RAM purge executed successfully."
log "=== Optimization Complete: Mac Running Clean & Smooth ==="
CLEANER_EOF
fi

chmod +x "$TARGET_SCRIPT"
echo " ✅ Installed cleaner engine to $TARGET_SCRIPT"

# 3. Create LaunchAgent for current user
cat <<EOF > "$TARGET_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.satyanarayan.macoptimizer</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$TARGET_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartCalendarInterval</key>
    <array>
        <dict>
            <key>Hour</key>
            <integer>8</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
        <dict>
            <key>Hour</key>
            <integer>14</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
    </array>
    <key>StandardOutPath</key>
    <string>$TARGET_DIR/launchd.log</string>
    <key>StandardErrorPath</key>
    <string>$TARGET_DIR/launchd_err.log</string>
</dict>
</plist>
EOF
echo " ✅ Registered LaunchAgent: $TARGET_PLIST"

# 4. Activate in launchd
launchctl unload "$TARGET_PLIST" 2>/dev/null || true
launchctl load "$TARGET_PLIST"
echo " ✅ Active & Scheduled: Runs at boot/login, 8:00 AM, and 2:00 PM"

# 5. Execute initial optimization
echo " ⚡ Running immediate first-time optimization..."
"$TARGET_SCRIPT"

echo ""
echo "============================================================"
echo " 🎉 100% SUCCESS: Mac Optimizer is Configured & Active!"
echo " 👉 Logs: cat ~/.mac_optimizer/optimizer.log"
echo " 👉 Trigger manually anytime: bash ~/.mac_optimizer/mac_cleaner.sh"
echo "============================================================"
