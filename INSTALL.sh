#!/bin/sh

# Directories to backup
BACKUP_DIRS="$HOME/.config/alacritty
$HOME/.config/awesome
$HOME/.config/bspwm
$HOME/.config/cagebreak
$HOME/.config/cava
$HOME/.config/cmus
$HOME/.config/colorls
$HOME/.config/dunst
$HOME/.config/elinks
$HOME/.config/feh
$HOME/.config/git
$HOME/.config/leafpad
$HOME/.config/mpd
$HOME/.config/msmtp
$HOME/.config/mutt
$HOME/.config/ncmpc
$HOME/.config/ncmpcpp
$HOME/.config/neofetch
$HOME/.config/notmuch
$HOME/.config/stalonetray
$HOME/.config/steck
$HOME/.config/sway
$HOME/.config/sx
$HOME/.config/sxhkd
$HOME/.config/sxiv
$HOME/.config/systemd
$HOME/.config/terminator
$HOME/.config/termite
$HOME/.config/tig
$HOME/.config/tmux
$HOME/.config/htop"

# Check if stow is already installed
if [ "$(command -v stow)" ]; then
  echo "stow is already installed"
else
  # Check which package manager to use based on distribution
  if [ -x "$(command -v apt-get)" ]; then
    # Debian-based system
    sudo apt-get update && sudo apt-get install -y stow
  elif [ -x "$(command -v pacman)" ]; then
    # Archlinux-based system
    sudo pacman -Syu --noconfirm && sudo pacman -S --noconfirm stow
  elif [ -x "$(command -v yum)" ]; then
    # Redhat-based system
    sudo yum update && sudo yum install -y stow
  else
    echo "Unable to determine package manager for this distribution"
    exit 1
  fi
  echo "stow has been installed successfully"
fi

# Check if the script is being run inside the specified Git repository
if [ "$(git config --get remote.origin.url)" != "git@github.com:Awan/cfg.git" ]; then
  echo "This script must be run inside the https://github.com/Awan/cfg.git repository"
  exit 1
else
  echo "The script is being run inside the https://github.com/Awan/cfg.git repository"
fi

# Check if backup directories exist, and if so, prompt user to backup before continuing
for dir in $BACKUP_DIRS; do
  if [ -d "$dir" ]; then
    echo "Directory $dir already exists"
    read -p "Do you want to back up the existing directory? (y/n) " choice
    case "$choice" in
      y|Y|yes|YES ) echo "Backing up directory $dir..."
                     mv "$dir" "$dir.bkp"
                     echo "Directory $dir has been backed up to $dir.bkp";;
      n|N|no|NO ) echo "Skipping backup of directory $dir";;
      * ) echo "Invalid input, skipping backup of directory $dir";;
    esac
  fi
done

exit 0

