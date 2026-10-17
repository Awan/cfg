<p align="center">
  <a href="https://github.com/Awan/cfg/actions/workflows/ci.yml">
    <img src="https://github.com/Awan/cfg/actions/workflows/ci.yml/badge.svg" alt="Dotfiles CI">
  </a>
</p>

![bspwm](https://user-images.githubusercontent.com/42554663/100934595-ca9d7e00-3510-11eb-8943-4061ea1040ea.png)
![dwm](https://user-images.githubusercontent.com/42554663/62346164-8827f380-b50e-11e9-8538-a25c46c51af9.png)
![lewany](https://user-images.githubusercontent.com/42554663/68199427-d8b45e80-ffdf-11e9-80d5-b8666ceff734.png)
![Yaseen](https://user-images.githubusercontent.com/42554663/67501758-3ff81780-f69e-11e9-8f68-dda0695eda3d.png)
![zsh](https://user-images.githubusercontent.com/42554663/81833793-93a65180-9559-11ea-9687-9b56224707e9.png)
![mypanel](https://user-images.githubusercontent.com/42554663/177259504-4afb0440-a7f5-4b0c-bc98-f95a51ff7303.png)
![mypanel](https://github.com/user-attachments/assets/3b64cf0d-e8c3-4ac3-95ac-76002116855b)

```text
  ▓▓▓▓▓▓▓▓▓▓
 ░▓ About  ▓ linux configuration files
 ░▓ Author ▓ Abdullah Khabir <abdullah@abdullah.support>
 ░▓ Code   ▓ https://github.com/Awan/cfg.git
 ░▓ Mirror ▓ https://abdullah.support
 ░▓▓▓▓▓▓▓▓▓▓
 ░░░░░░░░░░

 bin        > automation scripts, utilities and fonts
 git        > git configuration and aliases
 vim        > Vim configuration
 zsh        > vanilla Zsh setup with a lightweight Git-aware prompt
 tmux       > terminal multiplexer
 alacritty  > terminal emulator configuration
 bspwm      > current tiling window manager configuration
 lemonbar   > lightweight status bar and panel configuration
 picom      > compositor configuration
 dunst      > notification daemon
 sxhkd      > hotkey daemon configuration
 ranger     > file manager configuration
 feh        > image viewer configuration
 mpd        > Music Player Daemon configuration
 mpv        > media player configuration
 mutt       > Mail user agent configuration
 isync      > mailbox synchronization configuration
 notmuch    > thread-based email indexing, search and tagging
 msmtp      > mail transport configuration

 Additional configurations for other applications and desktop environments
 are also retained in the repository for optional use.
```

# Supported Systems

This repository is primarily configured for the author's Arch Linux installation. The active dotfiles include Arch-specific plugin paths and Linux desktop settings, and the `system/` configuration and `.chezmoiscripts/` installers target Arch Linux and its `/etc` layout. Applying the whole repository on another operating system is not supported as a complete setup.

On another system, you can use chezmoi to select and apply home-directory files that suit that machine. Review the proposed changes first, skip chezmoi lifecycle scripts, and apply only configurations you have checked for that operating system. In particular, do not run the system installers outside Arch Linux.

# Installation

I manage my dotfiles with [chezmoi](https://www.chezmoi.io/), a configuration management tool designed to manage personal configuration files across machines.

Install chezmoi using the package manager available on your system. For example:

* `sudo apt install chezmoi`
* `sudo dnf install chezmoi`
* `sudo pacman -S chezmoi`
* `brew install chezmoi`

Alternatively, follow the [official chezmoi installation instructions](https://www.chezmoi.io/install/).

On the supported Arch Linux setup, initialize the repository and review the proposed changes before applying them:

```bash
chezmoi init https://github.com/Awan/cfg.git
chezmoi diff
chezmoi apply
```

Applying on Arch Linux may run scripts that install files under `/etc`. Those scripts use `doas`, so configure working `doas` access before applying the repository.

On another operating system, initialize without `--apply`, inspect the changes, and exclude scripts when applying:

```bash
chezmoi init https://github.com/Awan/cfg.git
chezmoi diff --exclude=scripts
chezmoi apply --exclude=scripts
```

Excluding scripts prevents the system installers from running. It does not make every home-directory configuration portable: review the diff and apply only files that fit the system and installed software. Chezmoi also supports applying selected targets, for example `chezmoi apply --exclude=scripts ~/.zshrc`.

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

When making changes, edit files through chezmoi or in the chezmoi source directory rather than modifying managed files in your home directory directly.

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

# System Configuration

System-wide configuration that must be installed outside the home directory is kept separately under `system/` in the chezmoi source tree. The system configuration and installers target Arch Linux; do not run these system installers on another operating system.

The current layout is:

```text
system/
├── cmdline.d/
│   └── 10-common.conf
├── console/
│   └── vconsole.conf
├── doas/
│   └── doas.conf
├── kernel/
│   └── generate-storage-cmdline.sh
├── mkinitcpio/
│   └── linux.preset
├── nftables/
│   └── nftables.conf
├── pacman/
│   ├── hooks/
│   │   ├── chezmoi-packages.hook
│   │   ├── dash.hook
│   │   └── zz-sbctl-sign-all.hook
│   └── pacman.conf
├── sysctl/
│   └── 99-security.conf
└── xorg/
    └── 30-touchpad.conf
```

These files are source-only chezmoi files and are not deployed into the home directory. Their corresponding installation scripts are kept under `.chezmoiscripts/`:

```text
.chezmoiscripts/
├── run_onchange_after_system-cmdline.d-10-common.conf.sh.tmpl
├── run_onchange_after_system-doas.conf.sh.tmpl
├── run_onchange_after_system-kernel-generate-storage-cmdline.sh.tmpl
├── run_onchange_after_system-mkinitcpio-linux.preset.sh.tmpl
├── run_onchange_after_system-nftables.conf.sh.tmpl
├── run_onchange_after_system-pacman-chezmoi-packages.hook.sh.tmpl
├── run_onchange_after_system-pacman-dash.hook.sh.tmpl
├── run_onchange_after_system-pacman-zz-sbctl-sign-all.hook.sh.tmpl
├── run_onchange_after_system-pacman.conf.sh.tmpl
├── run_onchange_after_system-sysctl.conf.sh.tmpl
├── run_onchange_after_system-vconsole.conf.sh.tmpl
└── run_onchange_after_system-xorg.conf.sh.tmpl
```

Each `run_onchange_` installer includes a SHA-256 hash of the relevant source file, so chezmoi reruns the installer when its rendered script changes. The generator installer uses run_onchange_after_: it runs after managed files are updated and only when its rendered contents change. It generates the local storage configuration on the first apply and reruns if the generator changes, without rewriting machine-specific storage configuration on every apply.

The files are installed to their system locations as follows:

| Source file | System destination |
| --- | --- |
| `system/cmdline.d/10-common.conf` | `/etc/cmdline.d/10-common.conf` |
| `system/console/vconsole.conf` | `/etc/vconsole.conf` |
| `system/doas/doas.conf` | `/etc/doas.conf` |
| `system/kernel/generate-storage-cmdline.sh` | `/usr/local/bin/generate-storage-cmdline` |
| `system/mkinitcpio/linux.preset` | `/etc/mkinitcpio.d/linux.preset` |
| `system/nftables/nftables.conf` | `/etc/nftables.conf` |
| `system/pacman/pacman.conf` | `/etc/pacman.conf` |
| `system/pacman/hooks/chezmoi-packages.hook` | `/etc/pacman.d/hooks/chezmoi-packages.hook` |
| `system/pacman/hooks/dash.hook` | `/etc/pacman.d/hooks/dash.hook` |
| `system/pacman/hooks/zz-sbctl-sign-all.hook` | `/etc/pacman.d/hooks/zz-sbctl-sign-all.hook` |
| `system/sysctl/99-security.conf` | `/etc/sysctl.d/99-security.conf` |
| `system/xorg/30-touchpad.conf` | `/etc/X11/xorg.conf.d/30-touchpad.conf` |

## Kernel command line and UKIs

The UKI preset in `system/mkinitcpio/linux.preset` sets `ALL_cmdline="/etc/cmdline.d"`. The preset therefore builds the default and fallback UKIs using the command-line drop-ins in that directory, rather than embedding a static command line containing one machine's disk UUIDs.

The command line is split into two parts:

- `system/cmdline.d/10-common.conf` is public, version-controlled configuration. It contains the author's general boot preferences and hardware/policy options. Review the options below before applying them to another computer; they are deliberately visible so users can make their own choices.
- `/etc/cmdline.d/00-storage.conf` is generated locally by `/usr/local/bin/generate-storage-cmdline`. It is **not stored in this repository**. The generator detects the running system's root filesystem, its LUKS backing device and active swap UUID (when the configured initramfs hooks use resume), then writes the corresponding storage parameters. This avoids copying the author's root, LUKS or swap UUIDs to another installation.

Run the generator after booting into the installed target system, not from an installation ISO or a chroot. Inspect its proposed values first:

```bash
doas /usr/local/bin/generate-storage-cmdline --dry-run
doas /usr/local/bin/generate-storage-cmdline --write
```

The generator intentionally stops when it encounters storage layouts or options it cannot identify safely. Its current implementation expects a block-device root and supports the configured `encrypt` or `sd-encrypt` initramfs unlock hook, with the matching LVM hook when applicable. Swap-file resume and ambiguous or separate encryption chains require explicit configuration rather than guessed UUIDs. If the storage layout changes later, inspect the dry run and regenerate the local file deliberately.

After changing the common options, generator, or UKI preset, rebuild the UKIs and check their signatures before rebooting:

```bash
chezmoi apply
doas mkinitcpio -P
doas sbctl sign-all
doas sbctl verify
```

The custom `zz-sbctl-sign-all.hook` supplements the hook installed by the `sbctl` package so EFI binaries are re-signed after relevant package transactions. The signing keys stay on the machine and must never be committed to this repository. Secure Boot key enrollment is separate from signing; this configuration does not enroll keys or replace your existing keys.

### Public kernel options

The options below are ordinary kernel parameters, not credentials or secrets. Their effects vary with hardware, kernel version, initramfs configuration and userspace. The values are published intentionally for review, not as a claim that every machine should use all of them.

| Option | Intent and considerations |
| --- | --- |
| `rw` | Requests a read-write root mount. |
| `quiet` | Suppresses routine boot messages; this can make startup less noisy but also less informative when diagnosing problems. |
| `consoleblank=60` | Blanks the text console after 60 seconds of inactivity. Review this if it is undesirable on a particular console or device. |
| `nowatchdog` | Disables kernel watchdog functionality. This may reduce watchdog-related overhead, but also removes a mechanism that can help detect some hangs. |
| `mitigations=auto` | Uses the kernel's automatic policy for applicable CPU vulnerability mitigations; it does not explicitly disable mitigations. |
| `loglevel=3` | Restricts routine kernel console output to more severe messages. Increase or remove it when investigating boot problems. |
| `rd.systemd.show_status=auto` | Controls status display when systemd is PID 1 in the initramfs. The current configuration uses BusyBox-based initramfs hooks, so this option has no effect during the current initramfs stage; it may be useful on systems using a systemd-based initramfs. |
| `bgrt_disable` | Disables use of the firmware-provided boot graphics resource table image. |
| `intel_pstate=active` | Requests active mode for the Intel P-state CPU frequency driver. It is relevant only to supported Intel CPUs and driver configurations. |
| `i915.enable_fbc=1` | Requests framebuffer compression from the Intel `i915` graphics driver when supported. Remove it if unsupported or problematic on other graphics hardware. |
| `i915.enable_guc=2` | Selects the `i915` GuC/HuC parameter bitmask value `2` (HuC loading in documented versions). Support depends on GPU generation, firmware and driver version; do not assume it applies to other GPUs. See the [i915 driver documentation](https://docs.kernel.org/gpu/i915.html). |
| `pcie_aspm=auto` | Retained from the author's existing command line, but `auto` is not listed as a documented value for `pcie_aspm=` in current upstream kernel parameter documentation. Do not assume this token changes ASPM policy; verify its effect or remove it. See [kernel parameters](https://docs.kernel.org/admin-guide/kernel-parameters.html). |
| `usbcore.autosuspend=1` | Sets the default USB autosuspend delay to one second. Some peripherals do not tolerate runtime power management well; remove or adjust it if devices disconnect or misbehave. |
| `noatime` | Intended to avoid file access-time updates, but a bare `noatime` token on the kernel command line does not itself guarantee that the root filesystem is mounted with that option. Configure actual mount options (for example through the appropriate root mount configuration) and verify with `findmnt`. |
| `ipv6.disable=1` | Disables IPv6 system-wide. This is a deliberate policy choice that can break networks or services requiring IPv6; remove it if IPv6 is needed. |
| `apparmor=1` | Requests enabling AppArmor where the kernel and initramfs support it. |
| `security=apparmor` | Selects AppArmor as the primary Linux Security Module where supported. Review alongside the `lsm=` list for the target kernel. |
| `lsm=landlock,lockdown,yama,integrity,apparmor,bpf` | Explicitly specifies the desired Linux Security Module list/order. Entries must be supported and enabled by the target kernel; adjust this list to the kernel's compiled-in LSM support and security requirements. |

The Intel options are hardware-specific, `ipv6.disable=1` reflects a network-policy choice, and the other options may affect diagnostics, power management or security behavior. Users should edit `system/cmdline.d/10-common.conf` to suit their hardware and requirements rather than blindly copying every option. After editing it, rebuild and verify the UKIs before rebooting.

This keeps system-level configuration organized by subsystem, stores reusable choices in the public repository, and generates storage identifiers locally for each installation.

# Zsh

The Zsh configuration is intentionally lightweight and modular. Configuration files are stored under `~/.zsh/` and are sourced from the main Zsh configuration.

The prompt is implemented using native Zsh features rather than a prompt framework. It provides:

* A single-line prompt
* Current working directory with `~` used for the home directory
* Current Git branch
* A dirty-state indicator for modified Git repositories
* Dynamic mail count from the local Maildir
* Battery status on virtual terminals

Third-party Zsh components are installed through the system package manager rather than being vendored into this repository.

On Arch Linux, the current setup uses:

* `zsh-autosuggestions`
* `zsh-completions`
* `zsh-history-substring-search`
* `zsh-syntax-highlighting`

The repository contains the Zsh configuration and package references, while the third-party plugin implementations are maintained by the package manager.

# Current Desktop and Terminal Setup

My current graphical setup is based on:

* **Alacritty** as the terminal emulator
* **bspwm** as the tiling window manager
* **sxhkd** for keyboard shortcuts
* **picom** as the compositor
* **lemonbar-ng** and my panel scripts for the status bar
* **dunst** for notifications

The repository also contains configurations for other window managers, compositors, terminal emulators and status bars that are not necessarily part of the current setup. These are retained as optional configurations rather than indicating that every application is currently installed or in use.

# Archived Configurations

The `archive/` directory contains configurations retained for historical reference or optional use. These files are kept in the repository but are **not managed or deployed by chezmoi**.

Archived configurations include older desktop environments, terminal emulators, status bars, and applications that are no longer part of the current setup. They can be restored or adapted for use on another system without affecting the active configuration.

The active configuration remains in the chezmoi source tree and represents the setup currently deployed on my system.

# Additional Configurations

The repository contains configurations accumulated over time for additional applications and environments.

Alternative window-manager and desktop configurations include:

```text
awesome
cagebreak
herbstluftwm
i3
hyprland
river
spectrwm
sway
weston
```

Alternative terminal and terminal-related configurations include:

```text
kitty
terminator
termite
urxvt
xfce4-terminal
```

Other retained application configurations include, among others:

```text
cava
cmus
colorls
htop
leafpad
ncmpc
ncmpcpp
neofetch
ranger
redshift
screenkey
waybar
wiremix
yambar
zathura
```

These configurations remain available in the repository even when the corresponding application is not part of my current daily environment. The repository therefore serves both as the configuration for my current system and as a collection of configurations for applications I may use on other systems or at another time.

# Lemonbar NG

Lemonbar NG is my maintained fork of Lemonbar XFT, focused on improved Unicode and Nerd Font support while preserving the lightweight design and XCB-based architecture of the original project.

It provides XFT rendering, full UTF-8/32-bit Unicode support, Nerd Font compatibility, basic formatting, RandR and Xinerama support, and EWMH compliance without wasting precious memory.

The source code is available on [GitHub](https://github.com/Awan/lemonbar-ng.git) and an AUR package is available [here](https://aur.archlinux.org/packages/lemonbar-ng) for Arch Linux.

# Polybar

A Polybar configuration is still retained in the repository for optional use.

Polybar is a stylish status bar and is available in the Arch Linux official repositories. Font Awesome is also available from the official repositories.

# Installed Packages

The package inventory for my Arch Linux host is maintained through chezmoi as an encrypted `age` file.

The current package inventory is stored in:

```text
~/.config/pacman/installed_packages
```

and its encrypted chezmoi source is:

```text
private_dot_config/pacman/encrypted_installed_packages.age
```

The package inventory is encrypted so that the installed package list can remain version-controlled without storing its contents as plaintext in the repository.

# Mail

I use:

```text
mbsync + notmuch + mutt + msmtp
```

for email.

Mail synchronization is configured through user-level `systemd` services and timers that are managed by chezmoi.

After applying the configuration with:

```bash
chezmoi apply
```

the service files are already placed under:

```text
~/.config/systemd/user/
```

There is no need to copy the service files manually.

Enable the mail synchronization timer with:

```bash
systemctl --user --now enable isync.timer
```

The Zsh prompt also checks the local Maildir dynamically and displays the number of new messages when available.

# Prayer Reminders

Prayer reminders are calculated locally for Islamabad using the `Asia/Karachi`
time zone, the Karachi calculation method, and standard (non-Hanafi) Asr. The
scheduler needs no network connection. It refreshes after the user systemd
manager starts and daily at 00:05, then schedules each reminder 10 minutes
before prayer time. If a reminder timer expires during suspend, it is skipped
when the laptop resumes if it is more than ten minutes past the prayer time; reminders are not
played late after a long suspend.

At reminder time, the service sends a critical Dunst notification and plays
[Ayat al-Kursi (Al-Baqarah 2:255)](https://gitlab.com/Abdullah/haq/-/blob/main/shuraim/002255.mp3)
in Saud Ash-Shuraim's recitation. The audio is managed by chezmoi. Critical
Dunst notifications remain visible until dismissed.
Dunst is started by the X session configuration.

On a fresh Arch Linux installation, install the playback and notification
packages if they are not already present, then apply chezmoi and enable the
scheduler timer:

```bash
sudo pacman -S dunst libnotify mpv
chezmoi apply
systemctl --user enable --now prayer-schedule.timer
```

Only `prayer-schedule.timer` should be enabled. The five prayer playback
services are started on demand by its generated timers; enabling them directly
would start them at session startup. Check the upcoming reminders with:

```bash
systemctl --user list-timers --all | rg prayer
```

These are calculated prayer times and may differ slightly from a local mosque's
timetable.

# MPD

The MPD user service, socket, and configuration are managed by chezmoi. Enable
the socket so MPD starts on the first local client connection, such as the
`music toggle` keybinding, without starting the service at login:

```bash
systemctl --user --now enable mpd.socket
```

The MPD control interface listens only on loopback (`127.0.0.1:6600`), and
audio plays locally through PipeWire. HTTP streaming is disabled, so MPD does
not expose an audio stream to other devices on the network.

