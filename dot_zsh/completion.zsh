# load completions system
zmodload -i zsh/complist

# auto rehash commands
# http://www.zsh.org/mla/users/2011/msg00531.html
zstyle ':completion:*' rehash true

# vim keys in tab completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v '^?' backward-delete-char

# for all completions: menuselection
zstyle ':completion:*' menu select=1

# for all completions: grouping the output
zstyle ':completion:*' group-name ''

# for all completions: color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# for all completions: selected item
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;47

# completion of .. directories
#zstyle ':completion:*' special-dirs true

# fault tolerance
zstyle ':completion:*' completer _complete _correct _approximate
# (1 error on 3 characters)
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# case insensitivity
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ":completion:*" matcher-list 'm:{A-Zöäüa-zÖÄÜ}={a-zÖÄÜA-Zöäü}'


# for all completions: grouping / headline / ...
zstyle ':completion:*:messages' format $'\e[01;35m -- %d -- \e[00;00m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found -- \e[00;00m'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d -- \e[00;00m'
zstyle ':completion:*:corrections' format $'\e[01;33m -- %d -- \e[00;00m'

# statusline for many hits
zstyle ':completion:*:default' select-prompt $'\e[01;35m -- Match %M    %P -- \e[00;00m'

# for all completions: show comments when present
zstyle ':completion:*' verbose yes

# in menu selection strg+space to go to subdirectories
bindkey -M menuselect '^@' accept-and-infer-next-history

# case-insensitive -> partial-word (cs) -> substring completion:
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# caching of completion stuff
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE"

# ~dirs: reorder output sorting: named dirs over userdirs
zstyle ':completion::*:-tilde-:*:*' group-order named-directories users

# ssh: reorder output sorting: user over hosts
zstyle ':completion::*:ssh:*:*' tag-order "users hosts"

# kill: advanced kill completion
zstyle ':completion::*:kill:*:*' command 'ps xf -U $USER -o pid,%cpu,cmd'
zstyle ':completion::*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

# rm: advanced completion (e.g. bak files first)
zstyle ':completion::*:rm:*:*' file-patterns '*.o:object-files:object\ file *(~|.(old|bak|BAK)):backup-files:backup\ files *~*(~|.(o|old|bak|BAK)):all-files:all\ files'

# vi: advanced completion (e.g. tex and rc files first)
zstyle ':completion::*:vi:*:*' file-patterns 'Makefile|*(rc|log)|*.(php|tex|bib|sql|zsh|ini|sh|vim|rb|sh|js|tpl|csv|rdf|txt|phtml|tex|py|n3):vi-files:vim\ likes\ these\ files *~(Makefile|*(rc|log)|*.(log|rc|php|tex|bib|sql|zsh|ini|sh|vim|rb|sh|js|tpl|csv|rdf|txt|phtml|tex|py|n3)):all-files:other\ files'

zstyle ':completion:*' list-dirs-first true

zstyle :compinstall filename '~/.zshrc'

# compinit normally checks the completion function path against the
# .zcompdump cache on startup. That check can add noticeable startup
# latency, especially when fpath contains many completion functions.
#
# Rebuild the dump when it is more than 24 hours old. Otherwise use
# `compinit -C` to load the existing dump without performing the
# new-function check.
#
# This deliberately means that newly installed or changed completion
# functions may not be detected immediately. If a newly installed package
# provides a completion that you want to use right away, run `compinit`
# manually in the current shell. A normal `compinit` performs its usual
# completion-function check and updates the dump when necessary.
#
# The glob qualifier is evaluated through a normal array assignment.
# Using the qualifier directly inside `[[ ... ]]` does not perform
# filename generation, so it cannot be used there as the staleness test.
autoload -Uz compinit
() {
    local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    local -a stale=(${zcompdump}(N.mh+24))
    if (( $#stale )); then
        compinit -d "$zcompdump"
    else
        compinit -C -d "$zcompdump"
    fi
}

# Terraform completion

#if [ -f /usr/bin/terraform ]; then
#    autoload -U +X bashcompinit && bashcompinit
#    complete -o nospace -C /usr/bin/terraform terraform
#fi

# aws completion

if [ -f /usr/bin/aws_zsh_completer.sh ]; then
    source /usr/bin/aws_zsh_completer.sh
fi
