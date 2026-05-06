#!/usr/bin/env bash

set -euo pipefail

BIT=(
  # ------------------------------------------
  #  [Dependencies/ 32bit Libraries]
  # ------------------------------------------
  giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap 
  gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils 
  libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib

  openssl lib32-openssl libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite
  lib32-freetype2  # lib32-

  libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader 
  libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 lib32-libxml2 sdl2 lib32-sdl2 
  gst-plugins-base-libs lib32-gst-plugins-base-libs 
  cups samba dosbox

  usbutils bluez-ps3 joyutils 
)

DEPS=(
  # == [ Vulkan ]
  mesa mesa-utils lib32-mesa 
  vulkan-radeon lib32-vulkan-radeon
  vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools
  vdpauinfo libva-utils libvdpau-va-gl libva-mesa-driver 
  
  # == [ Wine ]
  # wine-tkg-staging-bin wine-mono wine-gecko
  dxvk-bin vkd3d 
  winetricks wine-gaming-dependencies

  # == [ Launchers ]
  lutris umu-launcher steam bottles
  gamemode gamescope mangohud
)


install_pkgs(){
  echo "▶ Installing Dependencies..."
  yay -S --needed --noconfirm "${DEPS[@]}"

  echo "▶ Installing WINE/VULKAN/LAUNCHERS packages..."
  yay -S --needed "${BIT[@]}"
}

install_pkgs
