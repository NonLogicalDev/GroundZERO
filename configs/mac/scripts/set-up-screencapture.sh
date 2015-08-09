#!/bin/sh

SCREENSHOT_FOLDER="${HOME}/Pictures/Screenshots"

# Make sure the folder exists
mkdir -p $SCREENSHOT_FOLDER

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$SCREENSHOT_FOLDER"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
