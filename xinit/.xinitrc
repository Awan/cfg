#!/bin/sh

[ -f ~/.xprofile ] && . ~/.xprofile
exec dwm 2>/tmp/dwm.log
