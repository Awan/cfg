#!/usr/bin/env zsh

#fortune -a | cowsay

for f in  ~/.zsh/*(DN); do source $f; done


# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
