# Cursor shape (block = normal/vicmd, underline = insert).
# Pure terminal escape sequences and zle state - no subprocess, updates
# only when the mode actually changes.
#
# This replaces the commented-out zle-keymap-select/zle-line-init block
# that used to live in options.zsh - delete that block from there once
# this file is in place, so there's only one copy.

function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]]; then
        echo -ne '\e[1 q'
    else
        echo -ne '\e[3 q'
    fi

    zle reset-prompt
}

zle -N zle-keymap-select

function zle-line-init {
    zle -K viins
    echo -ne '\e[3 q'
}

zle -N zle-line-init
