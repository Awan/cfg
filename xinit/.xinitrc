#!/bin/sh

coded_by='

In the name of Allah, the most Gracious, the most Merciful.

 ▓▓▓▓▓▓▓▓▓▓
░▓ Author ▓ Abdullah <https://abdullah.today>
░▓▓▓▓▓▓▓▓▓▓
░░░░░░░░░░

░█▀▀░▀█▀░█▀█░█▀▄░▀█▀░█░█
░▀▀█░░█░░█▀█░█▀▄░░█░░▄▀▄
░▀▀▀░░▀░░▀░▀░▀░▀░░▀░░▀░▀
'


[ -f ~/.xprofile ] && . ~/.xprofile
exec bspwm >/tmp/bspwm-"$USER".log 2>&1
