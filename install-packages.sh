#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "
set -x

nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

nix-shell '<home-manager>' -A install

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_INSECURE=1

_OS=$(uname | tr '[:upper:]' '[:lower:]')
_ARCH=$(uname -m)

SWITCH_COMMAND="home-manager"

if [ $_OS == "darwin" ]; then
    SWITCH_COMMAND="darwin-rebuild"
    if [ $(darwin-rebuild) -ne 0 ]; then
        nix run nix-darwin/master#darwin-rebuild -- switch
    fi
fi

$SWITCH_COMMAND switch --flake github:dps0340/...s#dps0340

go install golang.org/x/tools/gopls@latest
