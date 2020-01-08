#  ▓▓▓▓▓▓▓▓▓▓ 
# ░▓ Author ▓ Abdullah <https://abdullah.today/> 
# ░▓▓▓▓▓▓▓▓▓▓ 
# ░░░░░░░░░░ 


# Start X at login    
    

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec startx -- vt1 -keeptty &>/dev/null
  logout
elif [[ $(tty) = /dev/tty2 ]]; then
  tmux has-session -t $USER || tmux new-session -t $USER && tmux attach-session -t $USER && sudo loadkeys $HOME/.loadkeysrc
fi
