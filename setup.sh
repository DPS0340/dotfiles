#!/bin/sh

rm ~/.vimrc
rm ~/.zshrc
rm ~/init-discord-rpc.sh
rm -rf ~/.config
rm -rf ~/.zsh
rm -rf ~/.zprofile
rm -rf ~/.zplugin
rm -rf ~/.vim_runtime

DIR=$(pwd)

ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/zshrc ~/.zshrc
ln -s $DIR/vim_runtime ~/.vim_runtime
ln -s $DIR/config ~/.config
ln -s $DIR/zsh ~/.zsh
ln -s $DIR/zprofile ~/.zprofile
ln -s $DIR/zplugin ~/.zplugin
ln -s $DIR/init-discord-rpc.sh ~/init-discord-rpc.sh

# Original code from https://github.com/driesvints/dotfiles/blob/main/fresh.sh
# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ "$(uname)" == "Linux" ]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/dps0340/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/dps0340/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

brew install zsh zplug neovim tldr gh bat exa neofetch curl wget

gh auth login

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

command -v zsh | sudo tee -a /etc/shells
zsh