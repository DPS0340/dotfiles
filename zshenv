if [ "$(uname)" = "Linux" ] && [ "$(mount -l | grep "pdf")" = "" ]; then
	~/dotfiles/rclone.sh
fi

setxkbmap -option ctrl:nocaps

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
