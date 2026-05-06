#!/usr/bin/env bash

set -e

TMUX_CONF="$HOME/.config/tmux/tmux.conf"
TPM_DIR="$HOME/.local/share/tmux/plugins/tpm"

# Install TPM (Tmux Plugin Manager)
install_tpm() {
  if [[ ! -d "$TPM_DIR" ]]; then
    echo -e "[ + ] Installing TPM into $TPM_DIR..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  else
    echo -e "TPM already installed at $TPM_DIR."
  fi
}

install_plug() {
  echo -e "[ + ] Installing TPM plugins..."
  "$TPM_DIR/bin/install_plugins"
}

# -- Check if tmux.conf exists & source it.
config_tmux(){
  if [[ -f "$TMUX_CONF" ]]; then
    echo -e "[ ! ] Detected tmux.conf at $TMUX_CONF"
    
    # Install TPM BEFORE sourcing config
    install_tpm
    
    # Source the config
    tmux source "$TMUX_CONF"
    echo -e "[ ! ] Sourced tmux config ....."
    
    # Install plugins AFTER sourcing
    install_plug
  else
    echo -e "[ ? ] No tmux.conf found in ~/.config/tmux ."
  fi
}


config_tmux
