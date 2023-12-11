#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

nix-channel --add https://nixos.org/channels/nixos-23.05

export NIXPKGS_ALLOW_UNFREE=1
nix-env -i -f packages.nix

if [ "$(uname)" == "Darwin" ]; then
	nix-env -i -f darwin-packages.nix
fi

if [ "$(uname)" == "Linux" ]; then
	nix-env -i -f linux-packages.nix
fi

go install golang.org/x/tools/gopls@latest
