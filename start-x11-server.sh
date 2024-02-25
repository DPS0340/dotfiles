#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

sudo -v

nohup sudo startx > ~/dotfiles/nohup-startx.out 2>&1 &
