#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrdb -load $HOME/.Xresources &
run polybar -r default &
xmodmap $HOME/.Xmodmap &
run picom -b --config $HOME/.config/picom/picom.conf &

# Restore the last wallpaper

$HOME/.fehbg &

# Set cursor shape

xsetroot -cursor_name ul_angle &

#xcompmgr -c -f D 5 &

# Add fonts directories

xset +fp $HOME/.local/share/fonts/ &
xset fp rehash &

# Start urxvt in daemon mode

run urxvtd -q -o -f &

# No mouse when idle

run unclutter --ignore-scrolling --fork --timeout 1 &

# DPMS and lock screen

xset dpms 180 &
run xss-lock -- betterlockscreen -l dim &

# Start Notification daemon

run dunst -c $HOME/.config/dunst/dunstrc &

# Start wireless connection notifications upon (connected/disconnected)

for IF in /var/run/wpa_supplicant/* ; do
  IF="${IF##*/}"
    if [[ -d "/sys/class/net/${IF}/phy80211" ]] ; then
      wpa_cli -p /var/run/wpa_supplicant -i "${IF}" -a "${HOME}/.local/bin/wpa_notify" &
    fi
done

# Mute the mic

pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo true &

# Redshift for less eye strain

#redshift -c ~/.config/redshift/redshift.conf &

# Start tmux if not already running

[ -z $TMUX ] && tmux new-session -s $USER -d 

# if multihead available, enable it or disable if not.

#multihead="$(xrandr -q)"

#echo "$multihead" | grep "HDMI2 connected" >/dev/null 2>&1 && xrandr --output HDMI2 --auto --output HDMI2 --auto --above eDP1 &
#echo "$multihead" | grep "HDMI2 disconnected" >/dev/null 2>&1 && xrandr --output HDMI2 --off &

#xrandr --output HDMI2 --auto --output HDMI2 --auto --left-of eDP1 &
#xrandr --output eDP-1 --mode 1600x900 --panning 1920x1080 --scale 1.2x1.2

# Start a scratchpad

sleep 1
urxvtc -T 'scratchpad' -geometry 65x20 & 
