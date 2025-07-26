#!/usr/bin/env zsh

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

LOCATION=$(realpath "$0")
DIR=$(dirname "$LOCATION")

yay -S powerpill downgrade
sudo pacman -Syu vi vim neovim wol gcc python curl wget docker docker-compose man firefox chromium xsel nerd-fonts wine --noconfirm
