#!/bin/bash

dir=~/dotfiles # dotfiles directorya
olddir=~/dotfiles_old # old dotfiles backup directory`
files="bashrc vimrc tmux.conf" # list of files to symlink in home

mkdir -p $olddir
cd $dir

for file in $files
do
	mv ~/.$file ~/dotfiles_old/
	ln -s $dir/$file ~/.$file
done

