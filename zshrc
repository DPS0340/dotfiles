export DISPLAY=':0.0'
export XAUTHORITY=~/.Xauthority

export ZSH="$HOME/.zplugin/plugins/robbyrussell---oh-my-zsh/"

export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/kubectl",   from:oh-my-zsh
zplug "plugins/kube-ps1",   from:oh-my-zsh
zplug "plugins/wakatime",   from:oh-my-zsh
zplug "jeffreytse/zsh-vi-mode"

zplug load --verbose

if [ "$(uname)" -eq "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ZSH_THEME="powerline10k"

source $ZSH/oh-my-zsh.sh

source /home/dps0340/.zsh/BlaCk-Void.zshrc

alias rr='source ~/.zshrc'
alias gpom='git push origin main'
alias gpmm='git push mine main'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vv='nvim .'

alias cat='bat'
alias b='bat'

alias ls='exa'
alias ll='exa -l -a'
alias l='exa -l -a'

alias nf='neofetch'


if [ ! -z $WSL_ENABLE ]; then
    alias clip='win32yank.exe -i'
    alias pwsh='powershell.exe'

    # Requires Pscx
    # https://github.com/Pscx/Pscx
    # Install-Module Pscx -Scope CurrentUser -AllowClobber
    neovideAlias='exec_neovide() {
    powershell.exe neovide --wsl "$1" &
    { sleep 2s ; powershell.exe Set-ForegroundWindow (Get-Process neovide)[-1].MainWindowHandle } &
    }; exec_neovide'

    alias open='explorer.exe'
    alias init-discord-rpc='sudo ~/init-discord-rpc.sh'
else
    alias clip='xclip -sel clip'
    neovideAlias='neovide'   
fi

alias neovide=$neovideAlias
alias nvd=$neovideAlias
alias nv=$neovideAlias
alias gvim=$neovideAlias

alias pacman='sudo powerpill'

unset neovideAlias

alias cl='clear'
alias td='tldr'

alias gcomp='g++ -O3 -Ofast -funroll-loops -msse -msse2 -msse3 -mssse3 -msse4 -mavx -mavx2 -std=c++17'

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

export PAGER=nvimpager
export MANPAGER=nvimpager

bindkey '^H' backward-kill-word
bindkey '^[^?' backward-kill-word

bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

bindkey '^[[Z' reverse-menu-complete

source /usr/share/nvm/init-nvm.sh
