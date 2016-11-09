#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# first install some deps
pacaur -S --needed --noconfirm $(cat $DIR/dependencies)

# using stow to deploy dotfiles
stow */ -t "$HOME"

# Create a .vim/bundle dir if it doesn't already exist
[ -d ~/.vim/bundle ] || mkdir -p ~/.vim/bundle

# Clone Vundle plugin if the folder doesn't already exist. Assuming folder is complete.
[ -d ~/.vim/bundle/Vundle.vim ] || git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# TODO install Padawan server

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

