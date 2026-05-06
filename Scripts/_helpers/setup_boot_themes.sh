#!/usr/bin/env bash

set -euo pipefail  # safer bash defaults

# === CONFIGURATION ===
PLYMOUTH_THEME_NAME="rings"
PLYMOUTH_THEME_DIR="$HOME/4.0/Patches/plymouth-themes"
PLYMOUTH_THEME_ARCHIVE="$PLYMOUTH_THEME_DIR/$PLYMOUTH_THEME_NAME.tar.xz"
PLYMOUTH_THEME_DEST="/usr/share/plymouth/themes/"

GRUB_THEME_NAME="Sekiro_theme"
GRUB_THEME_SRC="$HOME/4.0/Patches/grub-themes/$GRUB_THEME_NAME"
GRUB_THEME_DEST="/boot/grub/themes/$GRUB_THEME_NAME"

GRUB_CFG="/etc/default/grub"
GRUB_CFG_BAK="/etc/default/grub.bak"
MKINITCPIO_CONF="/etc/mkinitcpio.conf"
MKINITCPIO_CONF_BAK="/etc/mkinitcpio.conf.bak"

echo "=== Boot Theme Installer ==="

# 1. Install Plymouth
echo "[1/6] Installing plymouth..."
if ! pacman -Qi plymouth &>/dev/null; then
    sudo pacman -S --noconfirm plymouth
else
    echo "plymouth is already installed."
fi

# 1b. Extract Plymouth theme archive
echo "[1b] Extracting Plymouth theme..."
if [[ -f "$PLYMOUTH_THEME_ARCHIVE" ]]; then
    sudo mkdir -p "$PLYMOUTH_THEME_DEST/$PLYMOUTH_THEME_NAME"
    pv "$PLYMOUTH_THEME_ARCHIVE" | sudo tar -xJf - -C "$PLYMOUTH_THEME_DEST/$PLYMOUTH_THEME_NAME"
    echo "[ ✓ ] $PLYMOUTH_THEME_NAME extraction complete!"
else
    echo "[ ✗ ] Archive not found: $PLYMOUTH_THEME_ARCHIVE"
    exit 1
fi

# 2. Set Plymouth theme
echo "[2/6] Setting Plymouth theme: $PLYMOUTH_THEME_NAME"
if [[ -d "$PLYMOUTH_THEME_DEST/$PLYMOUTH_THEME_NAME" ]]; then
    sudo plymouth-set-default-theme -R "$PLYMOUTH_THEME_NAME"
else
    echo "Error: Plymouth theme not extracted properly."
    exit 1
fi

# 2b. Ensure plymouth hook in initramfs
echo "[2b] Ensuring Plymouth hook is in initramfs..."
sudo cp "$MKINITCPIO_CONF" "$MKINITCPIO_CONF_BAK"

if ! grep -q "plymouth" "$MKINITCPIO_CONF"; then
    # Insert 'plymouth' right after 'base udev'
    sudo sed -i 's/\(HOOKS=.*base udev\)/\1 plymouth/' "$MKINITCPIO_CONF"
fi

echo "Rebuilding initramfs..."
sudo mkinitcpio -P

# 3. Install GRUB theme
echo "[3/6] Installing GRUB theme: $GRUB_THEME_NAME"
if [[ -d "$GRUB_THEME_SRC" ]]; then
    sudo mkdir -p "$GRUB_THEME_DEST"
    sudo cp -r "$GRUB_THEME_SRC/"* "$GRUB_THEME_DEST/"
    echo "[ ✓ ] GRUB theme copied."
else
    echo "[ ✗ ] GRUB theme not found at $GRUB_THEME_SRC"
    exit 1
fi

# 4. Update GRUB to use theme + plymouth params
echo "[4/6] Updating GRUB configuration..."

# Backup grub config
sudo cp "$GRUB_CFG" "$GRUB_CFG_BAK"

# Add or update GRUB_THEME
if grep -q "^GRUB_THEME=" "$GRUB_CFG"; then
    sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$GRUB_THEME_DEST/theme.txt\"|" "$GRUB_CFG"
else
    echo "GRUB_THEME=\"$GRUB_THEME_DEST/theme.txt\"" | sudo tee -a "$GRUB_CFG" >/dev/null
fi

# Ensure quiet splash kernel params
if grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=' "$GRUB_CFG"; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& quiet splash/' "$GRUB_CFG"
else
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' | sudo tee -a "$GRUB_CFG" >/dev/null
fi

# 5. Regenerate GRUB config
echo "[5/6] Regenerating GRUB config..."
if [[ -d /boot/efi ]]; then
    # UEFI system
    sudo grub-mkconfig -o /boot/efi/EFI/*/grub/grub.cfg 2>/dev/null || sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    # BIOS system
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# 6. Finish
echo "[6/6] Done!"
echo "{+} Boot themes installed and configured successfully."
echo "{+} Please reboot to see the changes."
