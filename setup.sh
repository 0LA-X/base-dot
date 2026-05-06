#!/usr/bin/env bash
set -euo pipefail

trap 'echo "Error on line $LINENO"; exit 1' ERR


DOT_REPO="https://github.com/0LA-X/base-dot.git"
DOT_DIR="$HOME/base-dot"
SCR_DIR="$DOT_DIR/Scripts/_helpers"
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

  # ---- Terminal Apps ----
  kitty eza fastfetch chafa trash-cli

  # ---- Media ----
  ffmpeg ffmpegthumbnailer
  imagemagick mpv mpv-mpris
  playerctl portmidi
  sdl2_image sdl2_mixer sdl2_ttf

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
  adw-gtk-theme nwg-look pokego-bin

  # ---- Nautilus Addons ----
  nautilus-admin-gtk4
  nautilus-image-converter
  nautilus-share gvfs-mtp

  # ---- Apps ----
  bazarr breezy file-roller
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


# -----------------------------------------
# Pre-flight Checks
# -----------------------------------------
check_system() {
  if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman not found. This script is for Arch Linux only."
    exit 1
  fi

  if ! ping -c 1 archlinux.org >/dev/null 2>&1; then
    echo "No internet connection."
    exit 1
  fi
}


# -----------------------------------------
# System Update
# -----------------------------------------
system_update() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm git base base-devel
}


# -----------------------------------------
# Dotfiles
# -----------------------------------------
setup_dotfiles() {
  if [[ ! -d "$DOT_DIR" ]]; then
    git clone "$DOT_REPO" "$DOT_DIR"
  else
    git -C "$DOT_DIR" pull --ff-only
  fi
}


# -----------------------------------------
# yay (AUR helper)
# -----------------------------------------
install_yay(){
  git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
  cd "$YAY_DIR"
  makepkg -si --noconfirm
  cd "$HOME"
  rm -rf "$YAY_DIR"
}

ensure_yay() {
  if ! command -v yay >/dev/null 2>&1; then
    install_yay
  fi
}


# -----------------------------------------
# Package Installation
# -----------------------------------------
install_pkgs(){
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
  yay -S --needed --noconfirm "${AUR_PKGS[@]}"
}


# -----------------------------------------
# Dotfile Stow
# -----------------------------------------
stow_dots(){
  sudo pacman -S --needed --noconfirm stow

  mkdir -p "$HOME"/{.config/XX,.local/bin,.local/XY}
  
  cd "$DOT_DIR"
  stow -v Config Local zsh --target="$HOME"
}


# -----------------------------------------
# Helper Scripts
# -----------------------------------------
run_helper() {
  local script="$1"
  if [[ -f "$script" ]]; then
    bash "$script"
  fi
}

helper_scripts(){
  echo "[ + ] Setting up TMUX & TPM"
  run_helper "$SCR_DIR/tpm.sh"
  
  echo "[ + ] Setting up ZSH"
  run_helper "$SCR_DIR/setup_zsh.sh"

  echo "[ + ] Setting up Audio & Bluetooth"
  run_helper "$SCR_DIR/setup_audio.sh"

  echo "[ + ] Setting up Boot-themes"
  run_helper "$SCR_DIR/setup_boot_themes.sh"
}


# ------------
#   Main
# ------------
MAIN(){
  show_header
  check_system
  system_update
  setup_dotfiles
  ensure_yay
  install_pkgs
  stow_dots
  helper_scripts
}


MAIN
