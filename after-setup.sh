#!/bin/sh

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

LOCATION=$(realpath "$0")
DIR=$(dirname "$LOCATION")

# Cache sudo credential
sudo -v

chsh -s $(which zsh)

nvim +'PlugInstall --sync' +qa
nvim +'CocInstall coc-yaml coc-rust-analyzer coc-pyright coc-json coc-go coc-tsserver coc-marksman' +qa

python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)"

gh auth login
