#!/usr/bin/env bash

set -e  

# Audio and Bluetooth setup script
echo "=== Audio & Bluetooth Setup Script ==="

# Ensure yay is installed
if ! command -v yay &> /dev/null; then
    echo "Error: 'yay' is not installed. Please install it first."
    exit 1
fi


echo "[1/5] Installing audio and Bluetooth packages..."
# bluez 

yay -S --noconfirm \
  pipewire pipewire-audio pipewire-pulse pipewire-alsa \
  wireplumber pipewire-jack \
  sof-firmware gst-plugin-pipewire\
  bluez-utils bluetooth-autoconnect \
  blueman pavucontrol


echo "[2/5] Enabling Bluetooth service..."
sudo systemctl enable --now bluetooth.service

echo "[3/5] Enabling Bluetooth autoconnect (if available)..."
if systemctl list-unit-files | grep -q bluetooth-autoconnect.service; then
    sudo systemctl enable --now bluetooth-autoconnect.service
else
    echo "Note: bluetooth-autoconnect.service not found. Skipping..."
fi

echo "[4/5] Adding user '$USER' to 'audio' and 'input' groups..."
sudo usermod -aG audio,input "$USER"

echo "[5/5] PipeWire and WirePlumber services will be started automatically via socket activation."

echo -e " Audio and Bluetooth setup complete!"
echo " Please reboot your system to ensure all changes take effect."
echo " You can use 'pavucontrol' to manage audio settings after reboot."
