#!/bin/sh
coded_by='

In the name of Allah, the most Gracious, the most Merciful.

 ▓▓▓▓▓▓▓▓▓▓
░▓ Author ▓ Abdullah <https://abdullah.today>
░▓▓▓▓▓▓▓▓▓▓ YouTube <https://YouTube.com/AbdullahToday>
░░░░░░░░░░

'

# Install my configuration files for some programs I can't live without.

if grep -qs "ubuntu" /etc/os-release; then
    os="ubuntu"
elif [[ -e /etc/debian_version ]]; then
    os="debian"
elif [[ -e /etc/centos-release ]]; then
    os="centos"
elif [[ -e /etc/fedora-release ]]; then
    os="fedora"
elif [[ -e /etc/arch-release ]]; then
    os="archlinux"
elif [[ -e /etc/gentoo-release ]]; then
    os="gentoo"
elif [[ "$osTYPE" == "darwin"* ]]; then
        os="macos"
else
    echo "please install stow manually then try again."
    exit
fi

if ! command -v stow >/dev/null 2>&1; then
    if [[ "$os" = 'debian' ]]; then
        sudo apt-get install -y stow git
    elif [[ "$os" = 'ubuntu' ]]; then
        sudo apt-get install -y stow git
    elif [[ "$os" = 'macos' ]]; then
        brew install stow git
    elif [[ "$os" = 'centos' ]]; then
        sudo yum -y install stow git
    elif [[ "$os" = 'fedora' ]]; then
        sudo yum -y install stow git
    elif [[ "$os" = 'gentoo' ]]; then
        sudo emerge stow git
    elif [[ "$os" = 'archlinux' ]]; then
        sudo pacman -S --noconfirm stow git
    fi
fi
    
git clone https://gitlab.com/Abdullah/cfg.git ~/cfg

cd ~/cfg || exit

for d in */; do stow "${d%/}"; done

echo 'Congrats, you are done, Enjoy!'
