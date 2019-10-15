#!/usr/bin/env zsh

#fortune -a | cowsay

for f in  ~/.zsh/*(DN); do source $f; done


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

precmd() {
 psvar[1]=$(mailsnow);
 battery_charge;
}

PS1="%{$fg[green]%}╭─%n@%m %{$reset_color%}%{$fg[yellow]%}in %~ %{$reset_color%}${git_branch} %1v
╰ %F{%5v}%6v%f%F{green}%7v%f %(?.%{$fg[blue]%}.%{$fg[red]%})%(!.#.❤) %{$reset_color%}"

