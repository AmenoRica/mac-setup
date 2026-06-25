#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults..."

# Show hidden files in Finder.
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Use list view in Finder by default.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Avoid creating .DS_Store files on network and USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Speed up key repeat.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

killall Finder >/dev/null 2>&1 || true

echo "macOS defaults applied. Some changes may require logout or reboot."

