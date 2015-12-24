#!/bin/sh
# This script based on work by Michael Jakl (jakl.michael AT gmail DOTCOM) and used 
# with express permission.
HOST=hulk.dinohensen.nl
SOURCE=$HOME
PATHTOBACKUP=/home/dhensen/home-backup

date=`date "+%Y-%m-%dT%H:%M:%S"`

rsync -az \
    --progress \
    --exclude-from=/home/dino/excludes \
    --link-dest=../current \
    $SOURCE \
    $HOST:$PATHTOBACKUP/back-$date

ssh $HOST "rm $PATHTOBACKUP/current && ln -s back-$date $PATHTOBACKUP/current"
