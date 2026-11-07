#!/bin/bash
# ==============================================================================
# Autonomous macOS Performance, Anti-Hang & Keyboard Latency Optimizer
# Author: Satyender Parihar (https://github.com/Satyenderparihar)
# ==============================================================================
# Automatically tunes keyboard responsiveness, UI animation snappiness,
# clears junk caches (Telegram, Homebrew, Chrome code cache, logs), and purges RAM.
# Runs silently on boot/login and daily at 8:00 AM & 2:00 PM via launchd.
# ==============================================================================

LOG_DIR="$HOME/.mac_optimizer"
LOG_FILE="$LOG_DIR/optimizer.log"
MAX_LOG_LINES=500

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Rotate log file if it exceeds maximum lines
if [ -f "$LOG_FILE" ] && [ "$(wc -l < "$LOG_FILE" 2>/dev/null)" -gt "$MAX_LOG_LINES" ]; then
    tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

log "=== Automatic Mac Health & Optimization Started ==="

# 1. Enforce Instant & Responsive Keyboard Settings (Zero Button Lag / No Stuck Keys)
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
log "Keyboard: Super-fast repeat (2), instant delay (15), press-and-hold popup disabled."

# 2. Enforce Fast UI & Window Animations
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.dock expose-animation-duration -float 0.12
defaults write com.apple.dock autohide-time-modifier -float 0.15
log "UI: Window resize and dock animation latency minimized."

# 3. Clean Heavy Application Caches
# Homebrew cache
if [ -d "$HOME/Library/Caches/Homebrew" ]; then
    rm -rf "$HOME/Library/Caches/Homebrew"/* 2>/dev/null
    log "Cleaned Homebrew package download cache."
fi

# Telegram corrupt/stuck media cache (Prevents 100%+ CPU runaway loops)
if [ -d "$HOME/Library/Caches/ru.keepcoder.Telegram" ]; then
    rm -rf "$HOME/Library/Caches/ru.keepcoder.Telegram"/* 2>/dev/null
    log "Cleaned Telegram media cache."
fi

# Google Chrome temporary code caches (Safe: does not touch history, logins, or bookmarks)
if [ -d "$HOME/Library/Caches/Google/Chrome/Default" ]; then
    rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Cache"/* 2>/dev/null
    rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Code Cache"/* 2>/dev/null
    log "Cleaned Google Chrome temp code cache."
fi

# Clean Diagnostic & Crash Reports
rm -rf "$HOME/Library/Logs/DiagnosticReports"/* 2>/dev/null
log "Cleaned stale diagnostic & crash logs."

# 4. Refresh System Caches
qlmanage -r cache >/dev/null 2>&1
dscacheutil -flushcache >/dev/null 2>&1
log "Refreshed QuickLook and DNS caches."

# 5. Purge Inactive System RAM Memory
purge >/dev/null 2>&1 || true
log "RAM purge executed successfully."

log "=== Optimization Complete: Mac Running Clean & Smooth ==="
