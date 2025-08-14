#!/usr/bin/env bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

LOCATION=$(realpath "$0")
DIR=$(dirname "$LOCATION")

# Cache sudo credential
sudo -v

datetime=$(date +'%Y-%m-%d_%H:%M:%S')

mv ~/.vim ~/.vim.bak-$datetime
mv ~/.vimrc ~/.vimrc.bak-$datetime
mv ~/.zshrc ~/.zshrc.bak-$datetime
mv ~/.config ~/.config.bak-$datetime
mv ~/.zsh ~/.zsh.bak-$datetime
mv ~/.xinitrc ~/.xinitrc.bak-$datetime
mv ~/.profile ~/.profile.bak-$datetime
mv ~/.xprofile ~/.xprofile.bak-$datetime
mv ~/.zprofile ~/.zprofile.bak-$datetime
mv ~/.zplugin ~/.zplugin.bak-$datetime
mv ~/.zshenv ~/.zshenv.bak-$datetime
mv ~/.vim_runtime ~/.vim_runtime.bak-$datetime
mv ~/.p10k.zsh ~/.p10k.zsh.bak-$datetime
mv ~/.tmux ~/.tmux.bak-$datetime
mv ~/.tmux.conf ~/.tmux.conf.bak-$datetime
mv ~/.wezterm.lua ~/.wezterm.lua.bak-$datetime
mv ~/.gitconfig ~/.gitconfig.bak-$datetime
mv ~/.gitignore ~/.gitignore.bak-$datetime

mv ~/kakaotalk-downloads ~/kakaotalk-downloads.bak-$datetime

ln -s $DIR/vim ~/.vim
ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/zshrc ~/.zshrc
ln -s $DIR/config ~/.config
ln -s $DIR/zsh ~/.zsh
ln -s $DIR/xinitrc ~/.xinitrc
ln -s $DIR/profile ~/.profile
ln -s $DIR/xprofile ~/.xprofile
ln -s $DIR/zprofile ~/.zprofile
ln -s $DIR/zplugin ~/.zplugin
ln -s $DIR/zshenv ~/.zshenv
ln -s $DIR/vim_runtime ~/.vim_runtime
ln -s $DIR/p10k.zsh ~/.p10k.zsh
ln -s $DIR/tmux ~/.tmux
ln -s $DIR/tmux.conf ~/.tmux.conf
ln -s $DIR/wezterm.lua ~/.wezterm.lua
ln -s $DIR/gitconfig ~/.gitconfig
ln -s $DIR/gitignore ~/.gitignore

ln -s "~/.wine/drive_c/users/dps0340/Documents/KakaoTalk Downloads" ~/kakaotalk-downloads

$DIR/...s/install-packages.sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

curl -s "https://get.sdkman.io" | bash

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 17.0.5-amzn
sdk install gradle 7.6

pyenv install 3.10.9
pyenv global 3.10.9

go install golang.org/x/tools/gopls@latest

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

command -v zsh | sudo tee -a /etc/shells
zsh
