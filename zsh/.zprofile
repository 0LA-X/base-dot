#=====================================
#[ Start Graphical Session ]
#=====================================

#[ Auto start Hyprland on tty1 ]
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  mkdir -p ~/.cache
  exec start-hyprland > ~/.cache/hyprland.log 2>&1
fi


#[ with UWSM ]
# if uwsm check may-start; then
#   exec uwsm start hyprland.desktop
# fi
