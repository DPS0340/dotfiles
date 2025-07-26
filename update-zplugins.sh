#!/usr/bin/env zsh

LOCATION=$(realpath "$0")
DIR=$(dirname "$LOCATION")

# Cache sudo credential
sudo -v

export ZPLUG_HOME=$(brew --prefix)/opt/zplug
export ZINIT_HOME=$(brew --prefix)/opt/zinit
source $ZPLUG_HOME/init.zsh
source $ZINIT_HOME/zinit.zsh

zplug load

zplug update

zinit update --all
