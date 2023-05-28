#!/bin/bash

export NIXPKGS_ALLOW_UNFREE=1
nix-env -i -f packages.nix

if [ "$(uname)" == "Darwin" ]; then
	nix-env -i -f darwin-packages.nix
fi
