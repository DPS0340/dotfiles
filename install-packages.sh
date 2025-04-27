#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_INSECURE=1

nix profile install github:dps0340/...s

go install golang.org/x/tools/gopls@latest
