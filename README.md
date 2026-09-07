![bspwm](https://user-images.githubusercontent.com/42554663/100934595-ca9d7e00-3510-11eb-8943-4061ea1040ea.png)
![dwm](https://user-images.githubusercontent.com/42554663/62346164-8827f380-b50e-11e9-8538-a25c46c51af9.png)
![lewany](https://user-images.githubusercontent.com/42554663/68199427-d8b45e80-ffdf-11e9-80d5-b8666ceff734.png)
![Yaseen](https://user-images.githubusercontent.com/42554663/67501758-3ff81780-f69e-11e9-8f68-dda0695eda3d.png)
![zsh](https://user-images.githubusercontent.com/42554663/81833793-93a65180-9559-11ea-9687-9b56224707e9.png)
![mypanel](https://user-images.githubusercontent.com/42554663/177259504-4afb0440-a7f5-4b0c-bc98-f95a51ff7303.png)
![mypanel](https://github.com/user-attachments/assets/3b64cf0d-e8c3-4ac3-95ac-76002116855b)

```
  ▓▓▓▓▓▓▓▓▓▓
 ░▓ About  ▓ linux configuration files
 ░▓ Author ▓ Abdullah Khabir <abdullah@abdullah.support>
 ░▓ Code   ▓ https://gitlab.com/Abdullah/cfg.git
 ░▓ Mirror ▓ https://abdullah.support
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

I manage my dotfiles with [chezmoi](https://www.chezmoi.io/), a configuration management tool designed to manage personal configuration files across machines.

Install chezmoi using the package manager available on your system. For example:

- `sudo apt install chezmoi`
- `sudo dnf install chezmoi`
- `sudo pacman -S chezmoi`
- `brew install chezmoi`

Alternatively, follow the [official chezmoi installation instructions](https://www.chezmoi.io/install/).

Once chezmoi is installed, initialize this repository and apply the configuration:

```bash
chezmoi init --apply git@github.com:Awan/cfg.git
```

The chezmoi source directory is stored at:

```text
~/.local/share/chezmoi
```

To inspect the configuration before applying it:

```bash
chezmoi diff
```

To apply changes from the source repository to your home directory:

```bash
chezmoi apply
```

To check whether the live configuration differs from the chezmoi source:

```bash
chezmoi status
```

The chezmoi source directory is also a Git repository, so configuration changes can be reviewed, committed, and pushed using the normal Git workflow.

For example:

```bash
cd ~/.local/share/chezmoi

git status
git diff
git add <file>
git commit -m "Describe the configuration change"
git push
```

When making changes, edit the files in the chezmoi source directory rather than modifying the managed files in your home directory directly.

For example, to edit the Vim configuration:

```bash
chezmoi edit ~/.vimrc
```

or edit the corresponding source file directly:

```bash
vim ~/.local/share/chezmoi/dot_vimrc
```

After making changes, review them with:

```bash
chezmoi diff
```

and apply them with:

```bash
chezmoi apply
```

# Lemonbar NG

Lemonbar NG is my maintained fork of Lemonbar XFT, focused on improved Unicode and Nerd Font support while preserving the lightweight design and XCB-based architecture of the original project.

It provides XFT rendering, full UTF-8/32-bit Unicode support, Nerd Font compatibility, basic formatting, RandR and Xinerama support, and EWMH compliance without wasting precious memory.

The source code is available on [GitHub](https://github.com/Awan/lemonbar-ng.git) and an AUR package is available [here](https://aur.archlinux.org/packages/lemonbar-ng) for Arch Linux.

# Polybar

Polybar is a stylish status bar. You have to compile it from [source](https://github.com/polybar/polybar.git) for some distributions.

It's now available in Arch Linux official repositories. As a dependency, you can install Font Awesome, which is available in the official Arch Linux repositories.

# Installed Packages

This [encrypted file](installed_packages) contains packages currently installed on my Arch Linux host. It is encrypted to myself using `age`:

```bash
pacman -Qq | age -e -a -r age1teq3zep9z3l9ea5s3x2t6859pskkj4nz74w2cy8kxh7jgnyvdcpq0xm9gg > installed_packages
```

# Mail

I use `mbsync + notmuch + mutt + msmtp` for email. I have enabled syncing with my mail account using `systemd timers`. Just copy those two files, `isync.timer` and `isync.service`, to `~/.config/systemd/user/` and enable the timer:

```bash
systemctl --user --now enable isync.timer
```

# MPD

Enable `mpd.socket` as a user service:

```bash
systemctl --user --now enable mpd.socket
```
