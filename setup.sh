#!/usr/bin/env bash

set -euo pipefail


DOT_DIR="$HOME/base-dot/"
SCR_DIR="$HOME/base-dot/Scripts/_helpers"
YAY_DIR="/tmp/yay"


# -----------------------------------------
# Pacman Packages
# -----------------------------------------
PACMAN_PKGS=(
  # ---- Core Dev Tools ----
  cmake clang lld llvm
  gcc gdb meson ninja
  nodejs-lts-iron npm
  python python-pip python-uv python-virtualenv 
  uv rustup lldb
  git stow tree-sitter-cli pkgfile

  # ---- Utilities ----
  btop nvtop curl wget
  duf dysk impala 
  fd ripgrep ncdu fzf jq pv 
  man-db rsync tldr 
  tmux nvim uwsm zoxide

  # ---- File Archiving ----
  7zip cdrtools squashfs-tools
  unarchiver unzip unrar

  # ---- System Tools ----
  acpi acpid brightnessctl
  cifs-utils cpu-x cpupower tuned-ppd
  ddcutil geoclue gammastep polkit-gnome
  samba xdg-user-dirs ufw 
  udisks2 udiskie usbutils 

  # ---- Terminal Apps ---- ghostty
  kitty eza fastfetch chafa trash-cli

  # ---- Media ----
  ffmpeg ffmpegthumbnailer
  imagemagick mpv mpv-mpris
  playerctl portmidi
  sdl2_image sdl2_mixer sdl2_ttf

  # ---- AMD Drivers ----
  # amd-ucode libva-utils libva-mesa-driver 
  # libvdpau-va-gl mesa mesa-utils
  # sof-firmware vdpauinfo
  # vulkan-icd-loader vulkan-radeon

  # ---- Hyprland Ecosystem ----
  hyprland hypridle hyprlock
  hyprpolkitagent xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  firefox
  

  # ---- File Managers ----
  nautilus yazi

  # ---- Fonts ----
  noto-fonts-emoji
  ttf-cascadia-code-nerd
  ttf-nerd-fonts-symbols
)

# -----------------------------------------
# AUR Packages
# -----------------------------------------
AUR_PKGS=(
  # ---- Themes & Appearance ----
  adw-gtk-theme nwg-look pokego-git
  # bibata-cursor-theme-bin  papirus-icon-theme

  # ---- Nautilus Addons ----
  nautilus-admin-gtk4
  nautilus-image-converter
  nautilus-share gvfs-mtp

  # ---- Apps ----
  bazarr breezy file-roller
  # flaresolverr suwayomi-server-bin
)



show_header() {
    cat << "EOF"

     ██╗ ██╗███╗   ██╗██╗  ██╗
     ██║███║████╗  ██║╚██╗██╔╝
     ██║╚██║██╔██╗ ██║ ╚███╔╝ 
██   ██║ ██║██║╚██╗██║ ██╔██╗ 
╚█████╔╝ ██║██║ ╚████║██╔╝ ██╗
 ╚════╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝

EOF
}

if ! command -v pacman >/dev/null 2>&1; then
  echo "❌ pacman not found. This script is for Arch Linux only."
  exit 1
fi

sudo pacman -Sy --needed --noconfirm git base base-devel

install_yay(){
  echo "[ + ] Installing yay"
  sudo pacman -Sy --needed git base-devel
  git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
  cd "$YAY_DIR"
  makepkg -si --noconfirm
  cd ~
  rm -rf "$YAY_DIR"
}

ensure_yay() {
  if ! command -v yay &> /dev/null; then
    echo "{ ! } yay not found. Installing..."
    install_yay
  else
    echo -e "{ - } yay is already installed.."
  fi
}

install_pkgs(){
  echo "▶ Installing pacman packages..."
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

  echo "▶ Installing AUR packages..."
  yay -S --needed --noconfirm "${AUR_PKGS[@]}"

  echo "✔ All packages installed successfully."
}

stow_dots(){
  if ! command -v stow &> /dev/null; then
    echo "{ + } Installing stow..."
    yay -S --noconfirm stow
  else
    echo "{ - } Stow already installed..."
  fi

  cd "$HOME"
  mkdir -p ./{.config/XX,.local/bin,.local/XY}
  
  echo "{ ! } Stowing dotfiles..."
  cd $DOT_DIR
  stow -v Config Local zsh 
}

helper_scripts(){
  echo "[ + ] Setting up ZSH"
  $SCR_DIR/setup_zsh.sh
  
  echo "[ + ] Setting up Audio & Bluetooth"
  $SCR_DIR/setup_audio.sh
  
  echo "[ + ] Setting up TMUX & TPM"
  $SCR_DIR/tpm.sh

  echo "[ + ] Setting up Boot-themes"
  $SCR_DIR/setup_boot_themes.sh
}


MAIN(){
show_header
ensure_yay
install_pkgs
stow_dots
helper_scripts
}


MAIN
