# Added by Toolbox App
export PATH="$PATH:/home/dps0340/.local/share/JetBrains/Toolbox/scripts"


. "$HOME/.local/bin/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/dps0340/.cache/lm-studio/bin"

# See https://www.reddit.com/r/NixOS/comments/ofmzb9/no_desktop_icons_for_nix_packages/
export XDG_DATA_DIRS="/usr/share:$HOME/.nix-profile/share:$XDG_DATA_DIRS"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/lee/.cache/lm-studio/bin"
# End of LM Studio CLI section

. "$HOME/.cargo/env"
