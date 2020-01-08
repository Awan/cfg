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
$HOME/.fehbg &
xsetroot -cursor_name ul_angle &
#xcompmgr -c -f D 5 &
xset +fp $HOME/.local/share/fonts/ &
xset fp rehash &
run urxvtd -q -o -f &
run unclutter --ignore-scrolling --fork --timeout 1 &
xset dpms 180 &
run xss-lock -- betterlockscreen -l dim &
run dunst -c $HOME/.config/dunst/dunstrc &
pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo true &
#redshift -c ~/.config/redshift/redshift.conf &
[ -z $TMUX ] && tmux new-session -s $USER -d 

# if multihead available, enable it or disable if not.

#multihead="$(xrandr -q)"

#echo "$multihead" | grep "HDMI2 connected" >/dev/null 2>&1 && xrandr --output HDMI2 --auto --output HDMI2 --auto --above eDP1 &
#echo "$multihead" | grep "HDMI2 disconnected" >/dev/null 2>&1 && xrandr --output HDMI2 --off &

#xrandr --output HDMI2 --auto --output HDMI2 --auto --left-of eDP1 &
#xrandr --output eDP-1 --mode 1600x900 --panning 1920x1080 --scale 1.2x1.2
sleep 2
urxvtc -T 'scratchpad' -geometry 65x20 &
