# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# autoload -Uz zsh-newuser-install && zsh-newuser-install -f
# autoload -Uz compinstall && compinstall
autoload -Uz compinit && compinit


# export DISPLAY=':0.0'
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

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

source $ZSH/oh-my-zsh.sh
source $HOME/.zsh/BlaCk-Void.zshrc

alias rr='source ~/.zshrc'

alias glom='git pull origin main'
alias glmm='git pull mine main'
alias glod='git pull origin dev'
alias glmd='git pull mine dev'
alias gllo='git pull origin'

alias gpom='git push origin main || git push origin master'
alias gpmm='git push mine main || git push origin master'
alias gpod='git push origin dev'
alias gpmd='git push mine dev'
alias gpo='git push origin'
alias gpm='git push mine'

alias gck='git checkout'
alias gckb='git checkout -b'

alias gmv='git mv'
alias gr='git reset'
alias grs='git reset --soft'
alias grm='git reset --mixed'
alias grh='git reset --hard'

function grsa () {
	git restore --staged $1
	git restore $1
}

alias gmc='git merge --continue'

alias gcob='git checkout -b'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vv='nvim .'

alias hh='history'

# alias cat='bat'
alias b='bat'

alias nf='neofetch'

alias cx='chmod +x'
alias s='sudo'
alias '$'=''

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

alias g++='g++-12'
alias c++='g++-12'
alias gcc='gcc-12'
alias cc='gcc-12'

alias dq='xattr -r -d com.apple.quarantine'

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

source <(kubectl completion zsh)

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [ "$(uname)" == "Darwin" ]; then
  # Use finder, not xdg-open
  unalias open
fi

git config --global core.editor "nvim"
# git config --global core.pager "more"
git config --global color.pager true
git config --global --replace-all core.pager "less -F -X"
git config --global init.defaultBranch main
git config --global user.name "Jiho Lee"
git config --global user.email "optional.int@kakao.com"

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/share/pkgconfig
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

unalias s
alias s='sudo'

# For cloud foundry cli usage
unalias cf
unset -f cf


# To customize prompt, run `p10k configure` or edit ~/dotfiles/p10k.zsh.
[[ ! -f ~/dotfiles/p10k.zsh ]] || source ~/dotfiles/p10k.zsh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

set -o vi
# bindkey -v

alias ls='exa -alh'
alias ll='exa -alh'
alias l='exa -alh'

alias sl='exa -alh'

alias kill6443='lsof -t -i:6443 | xargs kill -9'

export TERM=xterm-256color
export EDITOR="nvim"
export K9S_EDITOR="nvim"

alias merge='git config pull.rebase false'
alias rebase='git config pull.rebase true'
alias ff='git config pull.ff only'

# autoload -Uz zsh-newuser-install && zsh-newuser-install -f
tmux new
