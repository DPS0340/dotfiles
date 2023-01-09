#!/bin/sh

rm ~/.vimrc
rm ~/.zshrc
rm ~/init-discord-rpc.sh
rm -rf ~/.config
rm -rf ~/.vim_runtime

DIR=$(pwd)

ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/zshrc ~/.zshrc
ln -s $DIR/vim_runtime ~/.vim_runtime
ln -s $DIR/config ~/.config
ln -s $DIR/init-discord-rpc.sh ~/init-discord-rpc.sh

# Original code from https://github.com/driesvints/dotfiles/blob/main/fresh.sh
# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if ["$(uname)" == "Linux" ]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/dps0340/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

brew install zsh neovim tldr gh bat exa neofetch

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
