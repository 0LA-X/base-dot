#!/usr/bin/env bash

set -e

# Spotify + Spicetify Installer for Arch Linux
echo "  Starting Spotify + Spicetify setup..."

#-----------------------------
# Install Spotify
#-----------------------------
if ! pacman -Qi spotify &>/dev/null; then
  echo " [ + ] Installing Spotify..."
  yay -S --noconfirm spotify
else 
  echo " { ! } Spotify already installed, skipping..."
fi

#-----------------------------
# Install Spicetify + Marketplace
#-----------------------------
if ! pacman -Qi spicetify-cli spicetify-marketplace-bin &>/dev/null; then
  echo " [ + ] Installing Spicetify..."
  yay -S --noconfirm --needed spicetify-cli spicetify-marketplace-bin

  echo " [ + ] Setting Spicetify permissions..."
  sudo chmod a+wr /opt/spotify
  sudo chmod a+wr /opt/spotify/Apps -R

  echo " [ + ] Initializing Spicetify..."
  spicetify backup apply
else 
  echo " { ! } Spicetify already installed, skipping..."
fi

#-----------------------------
# Configure Spicetify
#-----------------------------
echo " [ + ] Applying Spicetify config..."
# spicetify config current_theme caelestia color_scheme caelestia custom_apps marketplace 2>/dev/null || true
spicetify apply

#-----------------------------
# Patch Spotify launch flags
#-----------------------------
CONFIG_FILE="$HOME/.config/spicetify/config-xpui.ini"
FLAGS="--enable-features=UseOzonePlatform | --ozone-platform=wayland | --ozone-platform-hint=auto"

echo " [ + ] Patching Spotify launch flags..."
if grep -q "^spotify_launch_flags" "$CONFIG_FILE"; then
  # use @ as sed delimiter since | exists in $FLAGS
  sed -i "s@^spotify_launch_flags.*@spotify_launch_flags   = $FLAGS@" "$CONFIG_FILE"
else
  echo "spotify_launch_flags   = $FLAGS" >> "$CONFIG_FILE"
fi

echo " { + } Done!"
