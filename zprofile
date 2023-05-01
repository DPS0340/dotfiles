if [ "$(uname)" = "Linux" ]; then
	~/dotfiles/rclone.sh
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
