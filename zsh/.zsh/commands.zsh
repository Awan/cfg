#!/usr/bin/env zsh

if [[ $commands[notmuch] ]]; then
  alias vimail="vim -c NotMuch"
fi

if [[ $commands[vim] ]]; then
  alias v='vim'
  alias vi='vim'
fi

if [[ $commands[bat] ]]; then
  alias cat='PAGER=less bat -p'
fi

if [[ $commands[pydf] ]]; then
  alias df='pydf'
fi

if [[ $commands[pacman] ]]; then
  alias pacman='sudo pacman'
fi
