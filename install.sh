#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -b -s "$DIR/.zshrc" ~/.zshrc

# Create a .vim/bundle dir if it doesn't already exist
[ -d ~/.vim/bundle ] || mkdir -p ~/.vim/bundle

# Clone Vundle plugin if the folder doesn't already exist. Assuming folder is complete.
[ -d ~/.vim/bundle/Vundle.vim ] || git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -b -s "$DIR/.vimrc" ~/.vimrc

# TODO install Padawan server

ln -b -s "$DIR/.screenrc" ~/.screenrc

vim +PluginInstall +qall
