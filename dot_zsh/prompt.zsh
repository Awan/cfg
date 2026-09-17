setopt PROMPT_SUBST

autoload -Uz add-zsh-hook

if [[ $TTY == /dev/tty<-> ]]; then
    add-zsh-hook precmd battery_charge
    RPROMPT='%F{%5v}%6v%f%7v'
else
    RPROMPT=''
fi

PROMPT='%F{yellow}%~%f$(git_prompt_info) $(mailsnow) '
