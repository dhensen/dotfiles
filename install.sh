#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function os_type
{
case `uname` in
  Linux )
     LINUX=1
     test -x "$(which apt-get)" && { echo debian; return; }
     test -x "$(which pacman)" && { echo archlinux; return; }
     ;;
  * )
     # Handle other here
     ;;
esac
}

# For now I only support this to work on arch linux because of messing up PATH in other distros
OS_TYPE=$(os_type)
if [ $OS_TYPE = "archlinux" ]; then
    ln --backup=numbered -s "$DIR/.zshrc" ~/.zshrc
else
    echo "skipped symlinking zshrc because this is not archlinux"
fi

# Create a .vim/bundle dir if it doesn't already exist
[ -d ~/.vim/bundle ] || mkdir -p ~/.vim/bundle

# Clone Vundle plugin if the folder doesn't already exist. Assuming folder is complete.
[ -d ~/.vim/bundle/Vundle.vim ] || git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

[ -d ~/.vim/colors ] || cp -R "$DIR/.vim/colors" ~/.vim/

ln --backup=numbered -s "$DIR/.vimrc" ~/.vimrc

# TODO install Padawan server

ln --backup=numbered -s "$DIR/.screenrc" ~/.screenrc
ln --backup=numbered -s "$DIR/.conkyrc.$HOSTNAME" ~/.conkyrc
ln --backup=numbered -s "$DIR/.Xresources.$HOSTNAME" ~/.Xresources

xrdb ~/.Xresources

vim +PluginInstall +qall

# At the moment this script is backing up symlink destination files. If you run this
# script more than once, symlinks will be made already and the backup will be a copy of the symlink
# Running this several times thus leaves backups of .zshrc, .vimrc and .screenrc in your home folder

# remove al backup files that are actually symlinks, this happens when you have no files to begin with or after the first install
find $DIR -regex '^\..*~[0-9]~$' -type l -exec rm {} \; 2>/dev/null
