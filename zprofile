export XDG_DATA_DIRS="/usr/share:$HOME/.nix-profile/share:$XDG_DATA_DIRS"

if [ "$(uname)" = "Linux" ]; then
    setxkbmap -option ctrl:nocaps
fi

if [ "$(uname)" = "Darwin" ]; then
    chflags nohidden ~/Library
fi

~/dotfiles/scripts/rclone/rclone.sh

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
