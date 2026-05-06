#!/usr/bin/env bash

set -e

DOT_DIR="$HOME/base-dot"

echo "  Starting Zsh + Plugin setup on ..."

# Check yay installation
if ! command -v yay &> /dev/null; then
    echo "  'yay' is not installed. Please install yay first."
    exit 1
fi

# Check and install Zsh if needed
if ! command -v zsh &> /dev/null; then
    echo "  Zsh not found. Installing Zsh..."
    sudo pacman -S --noconfirm zsh
fi

# Set Zsh as default shell if not already
CURRENT_SHELL="$(basename "$SHELL")"
if [[ "$CURRENT_SHELL" != "zsh" ]]; then
    echo "  Setting Zsh as the default shell for user: $USER"
    chsh -s "$(command -v zsh)"
else
    echo "  Zsh is already the default shell."
fi

echo "  All components installed! Restart your terminal to apply changes."
