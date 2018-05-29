#!/bin/bash
#Inspired by http://blog.neutrino.es/2012/git-copy-a-file-or-directory-from-another-repository-preserving-history/
#Copy a file or directory out of a git repository, preserving history!
#Creates DESTINATIONPATH with patches that can be applied with git am
#e.g.
#0001-Add-new-theme-Gum.patch
#0002-Add-syntax-highlighting-for-Gum-theme.patch
#0003-Gum-Fix-tag-URLs-not-being-slugified-and-therefore-b.patch
#0004-Gum-Add-Disqus-support.patch
#0005-Gum-Use-article-title-as-the-title-of-the-generated-.patch
#0006-Gum-HTML-escape-tag-names-when-rendering-them.patch

#Usage: copy-git-file.sh /some/repo/interesting/thing /destination/patch/path

#todo, test $1 and $2
DESTINATIONPATH=$2
SOURCE=$1 #first arg to script, either file or dir

pushd $SOURCE
git format-patch -o $DESTINATIONPATH $(git log $SOURCE|grep ^commit|tail -1|awk '{print $2}')..HEAD $SOURCE
popd
