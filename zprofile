export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"

if [ "$(uname)" = "Linux" ]; then
    setxkbmap -option ctrl:nocaps
fi

if [ "$(uname)" = "Darwin" ]; then
    chflags nohidden
fi

~/dotfiles/rclone.sh
