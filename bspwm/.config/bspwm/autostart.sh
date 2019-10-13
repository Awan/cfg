#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

$HOME/.config/polybar/launch.sh &
xmodmap $HOME/.Xmodmap &
#compton -b --config $HOME/.config/compton/compton.conf &
xrdb -load $HOME/.Xresources &
xset +fp $HOME/.local/share/fonts/ &
xset fp rehash &
urxvtd -q -o -f &


#!/bin/sh

# No mouse when idle.

unclutter -root -reset -idle 1 -noevents &

# if multihead available, enable it or disable if not.

#multihead="$(xrandr -q)"

#echo "$multihead" | grep "HDMI2 connected" >/dev/null 2>&1 && xrandr --output HDMI2 --auto --output HDMI2 --auto --above eDP1 &
#echo "$multihead" | grep "HDMI2 disconnected" >/dev/null 2>&1 && xrandr --output HDMI2 --off &

#[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
#[ -f ~/.Xresources ] && xrdb -load ~/.Xresources
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
    done
    unset f
fi

#xset +fp ~/.local/share/fonts 
#xset fp rehash 
#xrdb -load ~/.Xresources
#clipmenud &
#export LANG=en_US.UTF-8 
#export LC_ALL=en_US.UTF-8 
dunst -c $HOME/.config/dunst/dunstrc &
#urxvtd -q -o -f &
#compton --config ~/.config/compton/compton.conf -b &

xset dpms 180 &
xss-lock -- slock &
#slstatus &
~/.fehbg &
#xbacklight = 5 &
#pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo true &
#vpn &
#xbindkeys &
redshift -c ~/.config/redshift/redshift.conf &
# nm-applet &   # available from network-manager-gnome
#xrandr --output HDMI2 --auto --output HDMI2 --auto --left-of eDP1 &
#~/.config/polybar/launch.sh &
#xrandr --output eDP-1 --mode 1600x900 --panning 1920x1080 --scale 1.2x1.2

[ -z $TMUX ] && tmux new-session -s $USER -d 
