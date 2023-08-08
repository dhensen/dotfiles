#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SUDO=
if which sudo; then
    SUDO="sudo"
fi

# first install some deps
if cat /etc/os-release | grep -qo "Ubuntu 18.04"; then
    echo "Detected Ubuntu, going to install Ubuntu dependencies"

    $SUDO apt update
    $SUDO apt install -y $(cat ubuntu-dependencies)

    if [ ! -d wm ]; then
        mkdir -p wm && cd wm
        git clone https://github.com/baskerville/bspwm.git
        cd bspwm && make && $SUDO make install
        $SUDO cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/
        cd ..
        git clone https://github.com/baskerville/sxhkd.git
        cd sxhkd && make && $SUDO make install
        cd ..
        git clone https://github.com/baskerville/xdo.git
        cd xdo && make && $SUDO make install
        cd ..
        git clone https://github.com/baskerville/sutils.git
        cd sutils && make && $SUDO make install
        cd ..
        git clone https://github.com/baskerville/xtitle.git
        cd xtitle && make && $SUDO make install
        cd ..
        git clone https://github.com/krypt-n/bar.git
        cd bar && make && $SUDO make install
        cd ..
        cd ..
    fi
else
    echo "Falling back to an Arch Linux install"
    yay -S --needed --noconfirm $(cat $DIR/dependencies)
fi

# using stow to deploy dotfiles
stow --ignore="wm" */ -t "$HOME"


if [ -n "$DISPLAY" ]; then
    xrdb -merge ~/.Xresources
fi


if [ -f ~/.env ]; then
    echo "a .env file already exists in your home dir, if you experience problems please manually diff ~/.env with dotfile/.env.dist"
else
    cp "$DIR/.env.dist" ~/.env
    echo "Created ~/.env for you, please change it to match your systems configuration"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if [ ! -f ~/.zshrc_brand_spanking_new ] && [ -f ~/.zshrc.pre-oh-my-zsh ]; then
    mv ~/.zshrc ~/.zshrc_brand_spanking_new
    mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
fi

