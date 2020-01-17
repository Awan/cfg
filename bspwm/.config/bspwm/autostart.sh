#!/usr/bin/env bash
# In the name of Allah, the most Gracious, the most Merciful.
#
#  ▓▓▓▓▓▓▓▓▓▓ 
# ░▓ Author ▓ Abdullah <https://abdullah.today> 
# ░▓▓▓▓▓▓▓▓▓▓ 
# ░░░░░░░░░░ 


user_resources=$HOME/.Xresources
user_keymaps=$HOME/.Xmodmap
user_fonts_dir=$HOME/.local/share/fonts
locker="$(which physlock)"
lock_message="'Aur tum apny Rab ki kon kon c nematon ko jhutlawo gy?'"
inactivity_time=1
notify_delay=10
notify_message="'locking the screen in ${notify_delay} seconds...'"

function run {
  if ! pgrep "$1" ;
  then
    "$@"&
  fi
}


if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
    done
    unset f
fi

function multibar {
  # check how many monitors are connected and start polybar on all of them.
  pkill polybar
  while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
  xrandr -q | awk '/ connected / {print $1}' | while read -r monitor _; do
  polybar -r "$monitor" & 
done
}

function tab {
  # Configure only laptop's screen if no external monitor is connected.
  xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --brightness 1.0 \
    --gamma 0.76:0.75:0.68 "$@"
  }

function tabular {
  # Configure external monitor if exists
  tab
  xrandr --output HDMI-2 --mode 1280x1024 --pos 1920x0 "$@"
}

# Start sxhkd 

sxhkd &

# Load Xresources 

[[ -f $user_resources ]] && xrdb -merge "$user_resources"

# Load keymaps

[[ -f $user_keymaps ]] && xmodmap "$user_keymaps"

# Run compositor

run picom -b --config "$HOME"/.config/picom/picom.conf &

# Restore the last wallpaper

"$HOME"/.fehbg &

# Set cursor shape

xsetroot -cursor_name ul_angle &

#xcompmgr -c -f D 5 &

# Add fonts directories

xset +fp "$user_fonts_dir" && xset fp rehash 

# Start urxvt in daemon mode

run urxvtd -q -o -f &

# No mouse when idle

run unclutter --ignore-scrolling --fork --timeout 1 &

# DPMS and lock screen

xset dpms 180 &
xautolock -detectsleep -time "$inactivity_time" -locker "'${locker} -mp \
  $lock_message'" -notify "$notify_delay" -notifier "notify-send -u critical \
  -t 1000 -a xautolock xautolock '${notify_message}'" &

# Start Notification daemon

run dunst -c "$HOME"/.config/dunst/dunstrc &

# Mute the mic

pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo true &

# Redshift for less eye strain

#redshift -c ~/.config/redshift/redshift.conf &

# Start tmux if not already running

[ -z "$TMUX" ] && tmux new-session -s "$USER" -d 

# Set brightness to 30 at boot

light -S 30

# Configure multihead.

if [ "$(xrandr -q | awk '/ connected / {print $1}' | wc -l)" -eq 1 ]; then
  tab --primary
else
  tabular
fi

# Start polybar on all monitors connected

multibar 

# Start a scratchpad

sleep 1
urxvtc -T 'scratchpad' -geometry 65x20 & 
