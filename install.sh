#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# first install some deps
sudo apt-get install $(cat ubuntu-dependencies)

sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/

mkdir wm && cd wm
git clone https://github.com/baskerville/xdo.git
cd xdo && make && sudo make install
cd ..
git clone https://github.com/baskerville/sutils.git
cd xdo && make && sudo make install
cd ..
git clone https://github.com/baskerville/xtitle.git
cd xdo && make && sudo make install
cd ..
git clone https://github.com/krypt-n/bar.git
cd xdo && make && sudo make install
cd ..
cd ..


# using stow to deploy dotfiles
stow */ -t "$HOME"

# Create a .vim/bundle dir if it doesn't already exist
[ -d ~/.vim/bundle ] || mkdir -p ~/.vim/bundle

# Clone Vundle plugin if the folder doesn't already exist. Assuming folder is complete.
[ -d ~/.vim/bundle/Vundle.vim ] || git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# TODO install Padawan server

xrdb -merge ~/.Xresources

vim +PluginInstall +qall

if [ -f ~/.env ]; then
    echo "a .env file already exists in your home dir, if you experience problems please manually diff ~/.env with dotfile/.env.dist"
else
    cp "$DIR/.env.dist" ~/.env
    echo "Created ~/.env for you, please change it to match your systems configuration"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv ~/.zshrc ~/.zshrc_brand_spanking_new
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
