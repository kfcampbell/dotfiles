#!/usr/bin/env bash

git config --global user.name "Keegan Campbell"
git config --global user.email "kfcampbell@github.com"

ln -s ~/.dotfiles/.bashrc ~/
ln -s ~/.dotfiles/.vimrc ~/

# just in case?
cp ~/.dotfiles/.bashrc ~/
cp ~/.dotfiles/.vimrc ~/

# try installing plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qall
