#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

LOCATION=$(realpath "$0")
DIR=$(dirname "$LOCATION")

# Cache sudo credential
sudo -v

rm ~/.vimrc
rm ~/.zshrc
rm ~/.p10k.zsh
rm -rf ~/.config
rm -rf ~/.zsh
rm -rf ~/.xprofile
rm -rf ~/.zprofile
rm -rf ~/.zplugin
rm -rf ~/.vim_runtime
rm -rf ~/.tmux
rm -rf ~/.tmux.conf

ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/zshrc ~/.zshrc
ln -s $DIR/vim_runtime ~/.vim_runtime
ln -s $DIR/config ~/.config
ln -s $DIR/zsh ~/.zsh
ln -s $DIR/xprofile ~/.xprofile
ln -s $DIR/zprofile ~/.zprofile
ln -s $DIR/zplugin ~/.zplugin
ln -s $DIR/p10k.zsh ~/.p10k.zsh
ln -s $DIR/tmux ~/.tmux
ln -s $DIR/tmux.conf ~/.tmux.conf

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

brew install --cask orbstack macfuse onedrive

if test ! $(which nix-env); then
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi

$DIR/install-packages.sh

curl -s "https://get.sdkman.io" | bash

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 17.0.5-amzn
sdk install gradle 7.6

pyenv install 3.10.9
pyenv global 3.10.9

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

command -v zsh | sudo tee -a /etc/shells
zsh
