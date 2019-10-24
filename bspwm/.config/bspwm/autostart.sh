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

$HOME/.config/polybar/launch.sh &
xmodmap $HOME/.Xmodmap &
compton -b --config $HOME/.config/compton/compton.conf &
xsetroot -cursor_name left_ptr &
#xcompmgr -c -f D 5 &
xrdb -load $HOME/.Xresources &
xset +fp $HOME/.local/share/fonts/ &
xset fp rehash &
urxvtd -q -o -f &
unclutter -root -reset -idle 1 -noevents &
xset dpms 180 &
xss-lock -- slock &
dunst -c $HOME/.config/dunst/dunstrc &
~/.fehbg &
xbacklight = 5 &
pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo true &
#redshift -c ~/.config/redshift/redshift.conf &
[ -z $TMUX ] && tmux new-session -s $USER -d 

# if multihead available, enable it or disable if not.

#multihead="$(xrandr -q)"

#echo "$multihead" | grep "HDMI2 connected" >/dev/null 2>&1 && xrandr --output HDMI2 --auto --output HDMI2 --auto --above eDP1 &
#echo "$multihead" | grep "HDMI2 disconnected" >/dev/null 2>&1 && xrandr --output HDMI2 --off &

#[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
#[ -f ~/.Xresources ] && xrdb -load ~/.Xresources

#urxvtd -q -o -f &
#compton --config ~/.config/compton/compton.conf -b &

#slstatus &
#vpn &
#xbindkeys &
# nm-applet &   # available from network-manager-gnome
#xrandr --output HDMI2 --auto --output HDMI2 --auto --left-of eDP1 &
#~/.config/polybar/launch.sh &
#xrandr --output eDP-1 --mode 1600x900 --panning 1920x1080 --scale 1.2x1.2

