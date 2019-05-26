#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SUDO=
if which sudo; then
    SUDO="sudo"
fi

# first install some deps
<<<<<<< HEAD
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
    pacaur -S --needed --noconfirm $(cat $DIR/dependencies)
fi
=======
sudo apt-get install $(cat ubuntu-dependencies)


mkdir -p wm && cd wm
git clone https://github.com/baskerville/bspwm.git
cd bspwm && make && sudo make install
sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/
cd ..
git clone https://github.com/baskerville/sxhkd.git
cd sxhkd && make && sudo make install
cd ..
git clone https://github.com/baskerville/xdo.git
cd xdo && make && sudo make install
cd ..
git clone https://github.com/baskerville/sutils.git
cd sutils && make && sudo make install
cd ..
git clone https://github.com/baskerville/xtitle.git
cd xtitle && make && sudo make install
cd ..
git clone https://github.com/krypt-n/bar.git
cd bar && make && sudo make install
cd ..
cd ..

>>>>>>> riddles

# using stow to deploy dotfiles
stow --ignore="wm" */ -t "$HOME"

# Create a .vim/bundle dir if it doesn't already exist
[ -d ~/.vim/bundle ] || mkdir -p ~/.vim/bundle

# Clone Vundle plugin if the folder doesn't already exist. Assuming folder is complete.
[ -d ~/.vim/bundle/Vundle.vim ] || git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if [ -n "$DISPLAY" ]; then
    xrdb -merge ~/.Xresources
fi

vim +PluginInstall +qall

if [ -f ~/.env ]; then
    echo "a .env file already exists in your home dir, if you experience problems please manually diff ~/.env with dotfile/.env.dist"
else
    cp "$DIR/.env.dist" ~/.env
    echo "Created ~/.env for you, please change it to match your systems configuration"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
<<<<<<< HEAD
if [ ! -f ~/.zshrc_brand_spanking_new ] && [ -f ~/.zshrc.pre-oh-my-zsh ]; then
    mv ~/.zshrc ~/.zshrc_brand_spanking_new
    mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
fi

=======
mv ~/.zshrc ~/.zshrc_brand_spanking_new
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
>>>>>>> riddles
