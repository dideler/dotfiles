#!/usr/bin/env bash

# Updates all files by copying them from their respective locations.
# (C) 2012 Dennis Ideler <ideler.dennis at gmail.com>

# Enable error checking.
set -e

# Delete everything except a few things (including hidden files).
shopt -s extglob # Set extended pattern matching to be sure.
rm -rf !(README|update.sh)

# Copy the desired dot files to this directory.
echo "Password needed to properly copy files & directories."
sudo cp --recursive --update -p ~/.bash_aliases ~/.vim/plugin/ ~/.vim/syntax/ \
        ~/.vimrc ~/.gitconfig ~/.config/fish/config.fish ~/.config/fish/functions/ .
rsync -a ~/.irssi . --exclude=away.log --exclude=default.theme

# Unhide all hidden files and dirs, except .git and .gitignore.
find . \( -iname ".*" ! -iname ".git" ! -iname ".gitignore" \) -print0 | xargs -r0 rename -v 's|/\.+([^/]+)$|/$1|'

# Redact sensitive information (e.g. irc password).
sed -i 's/password = .*$/password = --redacted--/' irssi/config
