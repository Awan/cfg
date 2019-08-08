![foo](https://user-images.githubusercontent.com/42554663/62346164-8827f380-b50e-11e9-8538-a25c46c51af9.png)


```
  ▓▓▓▓▓▓▓▓▓▓
 ░▓ About  ▓ linux configuration files
 ░▓ Author ▓ Abdullah <abdullah@abdullah.today>
 ░▓ Code   ▓ https://gitlab.com/Abdullah/cfg.git
 ░▓ Mirror ▓ https://abdullah.today
 ░▓▓▓▓▓▓▓▓▓▓
 ░░░░░░░░░░

 bin        > some automation scripts
 git        > git config and aliases
 ranger     > file manager
 urxvt      > 256 color support for terminal and some external extensions
 vim        > text editor config
 zsh        > vanilla zsh setup with git, battery and mail count in prompt
 tmux       > terminal multiplexer
 ```

# Automatic Install

`sh -c "$(curl -fsSL https://gitlab.com/Abdullah/cfg/snippets/1844751/raw)"`

or

`sh -c "$(wget https://gitlab.com/Abdullah/cfg/snippets/1844751/raw)"`


# Manual Installation
I manage my dotfiles with [gnu stow](http://www.gnu.org/software/stow/), a symlink farm manager. It's available in most linux distributions.

- `sudo apt install stow`
- `sudo dnf install stow`
- `sudo yum install stow`
- `sudo pacman install stow`
- `brew install stow`

or clone it [from source](https://savannah.gnu.org/git/?group=stow) and [build it](http://git.savannah.gnu.org/cgit/stow.git/tree/INSTALL.md) yourself.

Once stow is installed, just cd into this repository and create symlinks using stow like this,

- `cd ~`
- ` git clone https://gitlab.com/Abdullah/cfg.git`
- `cd cfg`
- `stow vim`

It will symlink vim. If you wanna use this configurations for root user, use `-t` argument,

- `stow -t /root vim`

**Note:** stow will only create a symlink if a config file doesn't already exist. You must delete/backup if there is a default config for a program. 
