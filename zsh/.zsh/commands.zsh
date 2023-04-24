#!/usr/bin/env zsh

# use doas instead of sudo

if type "doas" >&/dev/null; then
    zero="doas"
else
    zero="sudo"
fi

if [[ $commands[notmuch] ]]; then
  alias vimail="vim -c NotMuch"
fi

if [[ $commands[bat] ]]; then
  alias cat='PAGER=less bat -p'
fi

if [[ $commands[pydf] ]]; then
  alias df='pydf'
fi

if [[ $commands[pacman] ]]; then
  alias pacman="$zero pacman"
fi

if [[ $commands[apt] ]]; then
  alias apt="$zero apt"
fi


if [[ $commands[colorls] ]]; then
  alias ls='colorls --almost-all --git-status --group-directories-first'
else
  alias ls='ls --color=auto'
fi

if [[ $commands[todo.sh] ]]; then
  alias todo='todo.sh'
fi

if [[ $commands[cmus] ]]; then
  alias cms='cmus-remote'
fi

if [[ $commands[systemctl] ]]; then
 alias scdr='systemctl --user daemon-reload'
 alias scst='systemctl --user status'
 alias scrs='systemctl --user restart'
 alias scsr='systemctl --user start'
 alias scens='systemctl --user enable --now'
 alias scds='systemctl --user disable'
 alias scdsn='systemctl --user disable --now'
 alias sscdr="$zero systemctl daemon-reload"
 alias sscst="$zero systemctl status"
 alias sscrs="$zero systemctl restart"
 alias sscsr="$zero systemctl start"
 alias sscens="$zero systemctl enable --now"
 alias sscds="$zero systemctl disable"
 alias sscdsn="$zero systemctl disable --now"
fi
