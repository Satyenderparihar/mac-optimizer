#!/bin/bash
# ==============================================================================
# Autonomous macOS Performance & Keyboard Optimizer - Uninstaller
# ==============================================================================

PLIST_NAME="com.satyanarayan.macoptimizer.plist"
TARGET_PLIST="$HOME/Library/LaunchAgents/$PLIST_NAME"
TARGET_DIR="$HOME/.mac_optimizer"

echo "Uninstalling Mac Optimizer..."

# Unload from launchctl
launchctl unload "$TARGET_PLIST" 2>/dev/null || true

# Remove launchd plist and optimizer directory
rm -f "$TARGET_PLIST"
rm -rf "$TARGET_DIR"

echo "✅ Mac Optimizer has been completely uninstalled."
