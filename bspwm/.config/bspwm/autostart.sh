#!/bin/sh
# In the name of Allah, the most Gracious, the most Merciful.
#
#  ▓▓▓▓▓▓▓▓▓▓ 
# ░▓ Author ▓ Abdullah <https://abdullah.today> 
# ░▓▓▓▓▓▓▓▓▓▓ 
# ░░░░░░░░░░ 


# Xresources file
user_resources=$HOME/.Xresources
# custom keymaps
user_keymaps=$HOME/.Xmodmap
# custom fonts
user_fonts_dir=$HOME/.local/share/fonts
# Inactivity timeout
inactivity_timeout=180
# Time before exectuing lock 
notify_time=10

# For some java apps

#wmname LG3D &

run() {
  if ! pgrep $1 ;
  then
    $@&
  fi
}


if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x $f ] && . $f
    done
    unset f
fi

# Session name
export DESKTOP_SESSION=bspwm
# No tty
export XDG_SESSION_TYPE=x11

tab() {
  # Configure only laptop's screen if no external monitor is connected.
  xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --brightness 1.0 \
    --gamma 0.76:0.75:0.68 "$@"
}

tabular() {
  # Configure external monitor if exists
  tab
  xrandr --output HDMI-2 --mode 1280x1024 --pos 1920x0 "$@"
}

# Start sxhkd 

sxhkd &

# Load Xresources 

[ -f $user_resources ] && xrdb -merge "$user_resources"

# Load keymaps

[ -f $user_keymaps ] && xmodmap "$user_keymaps"

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

xset dpms $inactivity_timeout &
run xss-lock -- physlock -mp 'Say, "If the sea were ink for [writing] the words of my Lord, the sea would be exhausted before the words of my Lord were exhausted, even if We brought the like of it as a supplement."' &

# Start Notification daemon

run dunst -c "$HOME"/.config/dunst/dunstrc &

# Mute the mic

pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo true &

# Redshift for less eye strain

#redshift -c ~/.config/redshift/redshift.conf &

# Start tmux if not already running

[ -z $TMUX ] && tmux new-session -s $USER -d 

# Set brightness to 30 at boot

light -S 30

# Configure multihead.

if [ "$(xrandr -q | awk '/ connected / {print $1}' | wc -l)" -eq 1 ]; then
  tab --primary
else
  tabular
fi

# Start a scratchpad

#sleep 1
#urxvtc -T 'scratchpad' -geometry 65x20 & 
termite -t scratchpad &

# vim:ft=sh
