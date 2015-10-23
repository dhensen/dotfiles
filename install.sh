#!/bin/bash

ln -sf ~/dotfiles/.zshrc ~/.zshrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -sf ~/dotfiles/.vimrc ~/.vimrc

# TODO install Vundle, Padawan server
# for now if you want to do Vundle manually:
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# run: vim +PluginInstall +qall

ln -sf ~/dotfiles/.screenrc ~/.screenrc

vim +PluginInstall +qall
