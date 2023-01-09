#!/bin/sh

rm ~/.vimrc
rm ~/.zshrc
rm -r ~/.config
rm -r ~/.vim_runtime

DIR=$(PWD)

ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/zshrc ~/.zshrc
ln -s $DIR/vim_runtime ~/.vim_runtime
ln -s $DIR/config ~/.config

# Original code from https://github.com/driesvints/dotfiles/blob/main/fresh.sh
# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew install zsh neovim tldr gh

gh auth login

chsh -s $(which zsh)

source ~/.zshrc