# syntax=docker/dockerfile:1
FROM archlinux:latest
LABEL org.opencontainers.image.title="My Custom archlinux Image for Dotfiles Tests"
LABEL org.opencontainers.image.description="Arch Linux base image with pre-configured chezmoi, vim, and zsh environment."
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.authors="Muhammad Abdullah Khabir <abdullah@abdullah.support>"
LABEL org.opencontainers.image.source="https://github.com/Awan/cfg"
LABEL org.opencontainers.image.documentation="https://github.com/Awan/cfg/blob/main/README.md"
LABEL environment="testing"



RUN printf '%s\n' \
    'Server = https://singapore.mirror.pkgbuild.com/$repo/os/$arch' \
    'Server = https://frankfurt.mirror.pkgbuild.com/$repo/os/$arch' \
    'Server = https://london.mirror.pkgbuild.com/$repo/os/$arch' \
    'Server = https://taipei.mirror.pkgbuild.com/$repo/os/$arch' \
    'Server = https://losangeles.mirror.pkgbuild.com/$repo/os/$arch' \
    'Server = https://berlin.mirror.pkgbuild.com/$repo/os/$arch' \
    > /etc/pacman.d/mirrorlist
RUN printf '%s\n' 'DisableDownloadTimeout' >> /etc/pacman.conf
RUN pacman -Syu --noconfirm base-devel go zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting git openssh chezmoi zsh vim shellcheck python age opendoas nodejs && pacman -Scc --noconfirm

RUN useradd -m -s /usr/sbin/zsh ak
RUN usermod -aG wheel ak
RUN printf '%s\n' 'permit nopass keepenv :wheel' > /etc/doas.conf && chmod 0400 /etc/doas.conf
RUN printf '%s\n' 'PACMAN_AUTH=(doas)' >> /etc/makepkg.conf
RUN mkdir -p /home/ak/.ssh && chmod 700 /home/ak/.ssh && ssh-keyscan -H github.com gitlab.com git.sr.ht codeberg.org > /home/ak/.ssh/known_hosts && chmod 644 /home/ak/.ssh/known_hosts && chown -R ak:ak /home/ak/.ssh

RUN mkdir -p /build && chown ak:ak /build

USER ak
WORKDIR /home/ak
ENV GOPATH=/home/ak/go
ENV PATH=/home/ak/go/bin:/usr/local/bin:/usr/bin:/bin
ENV HOME=/home/ak
ENV USER=ak
ENV SHELL=/usr/sbin/zsh

RUN git clone https://aur.archlinux.org/age-plugin-sshagent.git /build/age-plugin-sshagent && cd /build/age-plugin-sshagent && makepkg -si --noconfirm && cd / && rm -rf /build/age-plugin-sshagent
RUN rm -rf /home/ak/.config/go/telemetry
CMD ["/usr/sbin/zsh"]
