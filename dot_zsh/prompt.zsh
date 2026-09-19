setopt PROMPT_SUBST

#autoload -Uz add-zsh-hook

if [[ $TTY == /dev/tty<-> ]]; then
    add-zsh-hook precmd battery_charge
    RPROMPT='%F{%5v}%6v%f%7v'
else
    RPROMPT=''
fi

# git.zsh/mail.zsh register themselves as precmd hooks and set plain
# variables (not psvar[]) - psvar's %Nv only does a literal text swap, it
# does not re-parse %-escapes embedded in the value, so any %F{...}/%f
# inside a psvar string prints as literal text instead of a color. Plain
# $variables get expanded by PROMPT_SUBST *before* zsh's %-escape pass
# runs, so escapes embedded in them are interpreted correctly.

# %(4~|.../%3~|%~): if the path has 4+ elements, show ".../" plus the last
# 3; otherwise show it in full. A deep path inside a git repo can no
# longer grow to eat the whole line the way a bare %~ could.
# PROMPT='%F{yellow}%(4~|.../%3~|%~)%f${GIT_PROMPT_INFO}${MAIL_PROMPT_INFO} '
PROMPT='%F{yellow}%(4~|.../%3~|%~)%f${GIT_PROMPT_INFO}${MAIL_PROMPT_INFO}${STATUS_INFO}${DURATION_INFO} '
