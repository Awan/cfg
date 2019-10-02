#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

$HOME/.config/polybar/launch.sh &
xmodmap $HOME/.Xmodmap &
compton -b --config $HOME/.config/compton/compton.conf &
xrdb -load $HOME/.Xresources &
xset +fp $HOME/.local/share/fonts/ &
xset +fp rehash &
urxvtd -q -o -f &
