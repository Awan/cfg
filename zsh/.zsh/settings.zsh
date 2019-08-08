# self explicit
setopt auto_remove_slash
# resolve symlinks
setopt chase_links
# correct commands spellings
setopt correct
# complex pattern globbing
setopt extended_glob
# include dotfiles in globbing
setopt glob_dots
# no bell on error
unsetopt beep
# no lower prio for background jobs
unsetopt bg_nice
# must use >| to truncate existing files
unsetopt clobber
# no bell on error in history
unsetopt hist_beep
# no hup signal at shell exit
unsetopt hup
# do not exit on end-of-file
unsetopt ignore_eof
# no bell on ambiguous completion
unsetopt list_beep
# ask for confirmation for `rm *' or `rm path/*'
unsetopt rm_star_silent
