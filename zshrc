# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export DISPLAY=':0.0'
export XAUTHORITY=~/.Xauthority

export ZSH="$HOME/.zplugin/plugins/robbyrussell---oh-my-zsh/"

if [ "$(uname)" = "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "jeffreytse/zsh-vi-mode"

zplug load --verbose
zplug install

plugins=(
  git
  kubectl
  kube-ps1
  wakatime
)

source $ZSH/oh-my-zsh.sh

source $HOME/.zsh/BlaCk-Void.zshrc

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

# Wsl specific settings
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

# export PAGER=nvimpager
# export MANPAGER=nvimpager

bindkey -e

bindkey '^H' backward-kill-word
bindkey '^[^?' backward-kill-word

bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

bindkey '^[[Z' reverse-menu-complete

bindkey '[C' forward-word
bindkey '[D' backward-word

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -Uz compinit
compinit

source <(kubectl completion zsh)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
