#!/usr/bin/env bash
# In the name of Allah, the most Gracious, the most Merciful.
#
#  ▓▓▓▓▓▓▓▓▓▓ 
# ░▓ Author ▓ Abdullah <https://abdullah.today> 
# ░▓▓▓▓▓▓▓▓▓▓ 
# ░░░░░░░░░░ 

# A part of my xss-lock setup

notify_delay=10
icon_path=$HOME/.local/share/icons/drops/xautolock.png
notify_message="locking the screen in ${notify_delay} seconds..."


notify_me() {
  notify-send -u critical \
    -t 900 -i "$icon_path" \
    "$notify_message"
  }


trap 'exit 0' TERM INT
trap "kill %%; wait" EXIT
notify_me
pkill -USR1 -x dunst
sleep 2147483647 &
wait
