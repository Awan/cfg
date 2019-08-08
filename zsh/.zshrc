#!/usr/bin/env zsh

for f in  ~/.zsh/*(DN); do source $f; done

# GpG Agent with SSH support
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

precmd() {
 psvar[1]=$(mailsnow);
 battery_charge;
}

PS1="%{$fg[green]%}╭─%n@%m %{$reset_color%}%{$fg[yellow]%}in %~ %{$reset_color%}${git_branch} %1v
╰ %F{%5v}%6v%f%F{green}%7v%f %(?.%{$fg[blue]%}.%{$fg[red]%})%(!.#.❤) %{$reset_color%}"

