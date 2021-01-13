![bspwm](https://user-images.githubusercontent.com/42554663/100934595-ca9d7e00-3510-11eb-8943-4061ea1040ea.png)
![dwm](https://user-images.githubusercontent.com/42554663/62346164-8827f380-b50e-11e9-8538-a25c46c51af9.png)
![lewany](https://user-images.githubusercontent.com/42554663/68199427-d8b45e80-ffdf-11e9-80d5-b8666ceff734.png)
![Yaseen](https://user-images.githubusercontent.com/42554663/67501758-3ff81780-f69e-11e9-8f68-dda0695eda3d.png)
![zsh](https://user-images.githubusercontent.com/42554663/81833793-93a65180-9559-11ea-9687-9b56224707e9.png)



```
  ▓▓▓▓▓▓▓▓▓▓
 ░▓ About  ▓ linux configuration files
 ░▓ Author ▓ Abdullah <abdullah@abdullah.today>
 ░▓ Code   ▓ https://gitlab.com/Abdullah/cfg.git
 ░▓ Mirror ▓ https://abdullah.today
 ░▓▓▓▓▓▓▓▓▓▓
 ░░░░░░░░░░

 bin        > some automation scripts and fonts
 git        > git config and aliases
 ranger     > file manager
 urxvt      > 256 color support for terminal and some external extensions
 vim        > text editor config
 zsh        > vanilla zsh setup with git, battery and mail count in prompt
 tmux       > terminal multiplexer
 bspwm      > Tiling Window Manager
 polybar    > A stylish colorful status bar with system tray support
 compton    > compositor
 feh        > image viewer (there are more programs included like pqiv and sxiv)
 ipython    > python interactive shell with vim like keys support
 dunst      > notification daemon
 sxhkd      > hotkeys daemon (xbindkeys also is there with configurations)
 mutt       > Mail user agent
 isync      > command line synchronization tool for local mailbox with remote
 notmuch    > thread based email index, search and tagging app
 mpv        > media player (mplayer also available)
 ```


# Installation
I manage my dotfiles with [gnu stow](http://www.gnu.org/software/stow/), a symlink farm manager. It's available in most linux distributions.

- `sudo apt install stow`
- `sudo dnf install stow`
- `sudo yum install stow`
- `sudo pacman install stow`
- `brew install stow`

or 

```bash
$ curl https://git.io/JILE5 | sh
```

or clone it [from source](https://savannah.gnu.org/git/?group=stow) and [build it](http://git.savannah.gnu.org/cgit/stow.git/tree/INSTALL.md) yourself.

Once stow is installed, just cd into this repository and create symlinks using stow like this:

- `cd ~`
- ` git clone https://gitlab.com/Abdullah/cfg.git`
- `cd cfg`
- `stow vim`

It will symlink vim. If you wanna use this configurations for root user, use `-t` argument,

- `stow -t /root vim`


**Note:** stow will only create a symlink if a config file doesn't already exist. You must delete/backup if there is a default config for a program. 


# Polybar

Polybar is a stylish status bar. You have to compile it from [source](https://github.com/polybar/polybar.git).

In [AUR](https://aur.archlinux.org), you can find a [PKGBUILD](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=polybar).

Here are the dependencies you must have to use polybar with customized stylish icons.

- [Font Awesome 4](https://aur.archlinux.org/ttf-font-awesome-4)



[![Stargazers over time](https://starchart.cc/Awan/cfg.svg)](https://starchart.cc/Awan/cfg)
