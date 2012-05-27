#!/usr/bin/env bash

# Updates all files by copying them from their respective locations.
# (C) 2012 Dennis Ideler <ideler.dennis at gmail.com>

# Enable error checking.
set -e

# Delete everything except a few things (including hidden files).
shopt -s extglob # Set extended pattern matching to be sure.
rm -rf !(README|update.sh)

# Finally, copy the original files.
echo "Password needed to properly copy files & directories."
sudo cp -rp ~/.bash_aliases ~/.vim/ ~/.vimrc ~/.gitconfig .

# Unhide all hidden files and dirs, except .git and .gitignore.
find . \( -iname ".*" ! -iname ".git" ! -iname ".gitignore" \) -print0 | xargs -r0 rename -v 's|/\.+([^/]+)$|/$1|'

# Redact my github token.
sed -i 's/token = [0-9a-z]*/token = --redacted--/' gitconfig
