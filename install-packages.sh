#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_INSECURE=1

_OS=$(uname | tr '[:upper:]' '[:lower:]')
_ARCH=$(uname -m)

flake_attr="legacyPackages.${_ARCH}-${_OS}.homeConfigurations."dps0340".activationPackage"

nix profile install github:dps0340/...s#$flake_attr
nix profile upgrade $flake_attr

go install golang.org/x/tools/gopls@latest
