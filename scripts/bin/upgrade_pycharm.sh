#!/usr/bin/env sh

set -e

VERSION=$1

mkdir -p /tmp/pycharm_upgrade
cd /tmp/pycharm_upgrade

# download archive
wget https://download.jetbrains.com/python/pycharm-community-$VERSION.tar.gz

# unpack as root to /opt
sudo tar xf pycharm-community-$VERSION.tar.gz -C /opt/

# move the archive to /opt for future reference
sudo mv pycharm-community-$VERSION.tar.gz /opt

# create the symlink
sudo rm /usr/bin/pycharm
sudo ln -s /opt/pycharm-community-$VERSION/bin/pycharm.sh /usr/bin/pycharm

