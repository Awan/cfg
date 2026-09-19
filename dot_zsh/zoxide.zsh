# `z <partial-dir-name>` jumps to your most-used matching directory
# instead of typing full `cd` paths.
#
# `zoxide init zsh` prints a real, sizeable shell script - running that
# subprocess and re-sourcing its output fresh on every single shell start
# is wasteful. This caches the generated script once and only
# regenerates it when zoxide's own version changes (its init output only
# ever changes when the binary does), same principle as the compinit fix.

if (( ! $+commands[zoxide] )); then
    return
fi

typeset -g ZOXIDE_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
typeset -g ZOXIDE_INIT_CACHE="$ZOXIDE_CACHE_DIR/zoxide-init.zsh"
typeset -g ZOXIDE_VERSION_CACHE="$ZOXIDE_CACHE_DIR/zoxide-version"

if [[ ! -f $ZOXIDE_INIT_CACHE ]] ||
   [[ "$(zoxide --version 2>/dev/null)" != "$(cat "$ZOXIDE_VERSION_CACHE" 2>/dev/null)" ]]; then
    mkdir -p "$ZOXIDE_CACHE_DIR"
    zoxide init zsh > "$ZOXIDE_INIT_CACHE" 2>/dev/null
    zoxide --version > "$ZOXIDE_VERSION_CACHE" 2>/dev/null
fi

source "$ZOXIDE_INIT_CACHE"
