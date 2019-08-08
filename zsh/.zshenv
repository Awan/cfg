typeset -U path
path=(~/bin ~/.local/bin ~/.local/lib ~/.pyenv/bin /usr/sbin /sbin $path[@])
BROWSER=/usr/bin/google-chrome-stable
EDITOR=/usr/bin/vim
VISUAL=$EDITOR
TERMINAL=urxvtc
XDG_DATA_HOME=$HOME/.local/share
XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
