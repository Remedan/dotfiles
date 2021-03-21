#!/bin/bash

mkdir -p "$HOME/.config"
mkdir -p "$HOME/dotfiles_old/.config"

cd "$HOME/dotfiles"

BLACKLIST="-I install.sh -I .config -I .git -I .gitignore -I .gitmodules -I README.md -I screenshot.png"

for file in $(ls -A $BLACKLIST)
do
    mv "$HOME/$file" "$HOME/dotfiles_old"
    ln -s "$HOME/dotfiles/$file" "$HOME/$file"
done

for file in $(ls -A -I .config .config)
do
    mv "$HOME/.config/$file" "$HOME/dotfiles_old/.config"
    ln -s "$HOME/dotfiles/.config/$file" "$HOME/.config/$file"
done

curl -fLo "$HOME/.config/nvin/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall
