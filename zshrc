# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# autoload -Uz zsh-newuser-install && zsh-newuser-install -f
# autoload -Uz compinstall && compinstall
# autoload -Uz compinit && compinit

setxkbmap -option ctrl:nocaps

# export DISPLAY=':0.0'
# export XAUTHORITY=~/.Xauthority

export ZSH="$HOME/.zplugin/plugins/robbyrussell---oh-my-zsh/"

if [ "$(uname)" = "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ "$(uname)" = "Linux" ]; then
    ~/dotfiles/rclone.sh
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

alias glom='git pull origin main || git pull origin master'
alias glmm='git pull mine main || git pull mine master'
alias glod='git pull origin dev'
alias glmd='git pull mine dev'
alias gllo='git pull origin'
alias gllm='git pull mine'

alias gpom='git push origin main || git push origin master'
alias gpmm='git push mine main || git push mine master'
alias gpod='git push origin dev'
alias gpmd='git push mine dev'
alias gpo='git push origin'
alias gpm='git push mine'

unalias gap
alias gap='git add -p'

alias gck='git checkout'
alias gckb='git checkout -b'

alias gmv='git mv'
alias gr='git reset'
alias grs='git reset --soft'
alias grm='git reset --mixed'
alias grh='git reset --hard'

alias gclfx='git clean -fx'

alias gst='git stash'
alias gsta='git stash apply'
alias gstl='git stash list'
alias gsts='git stash show'

function grsa () {
	git restore --staged $1
	git restore $1
}

alias gmc='git merge --continue'

alias gcob='git checkout -b'

unalias c
alias c='code'
alias code='code'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vv='nvim .'

alias lv='lvim'
alias lvi='lvim'
alias lvv='lvim .'

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

unset neovideAlias

alias cl='clear'
alias td='tldr'

alias gcomp='g++ -O3 -Ofast -funroll-loops -msse -msse2 -msse3 -mssse3 -msse4 -mavx -mavx2 -std=c++17'

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
git config --global push.default current
git config --global pull.default current
git config --global core.excludesFile ~/.gitignore

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/share/pkgconfig
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

unalias _
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

alias ls='eza -alh'
alias ll='eza -alh'
alias l='eza -alh'

unalias la
alias la='eza -alh'

alias sl='eza -alh'

alias ls_='/bin/ls'

alias kill6443='lsof -t -i:6443 | xargs kill -9'

# https://github.com/nodejs/corepack/blob/main/README.md
alias yarn="corepack yarn"
alias yarnpkg="corepack yarnpkg"
alias pnpm="corepack pnpm"
alias pnpx="corepack pnpx"
alias npm="corepack npm"
alias npx="corepack npx"

function killport () {
	sudo lsof -t -i:$1 | sudo xargs kill -9
}

function sshloop () {
	while ! ssh $1; do sleep 1; done
}

function set-upstream () {
	remote=${1:-origin}
	branch=$(git rev-parse --abbrev-ref HEAD)
	git branch --set-upstream-to=$remote/$branch $branch
}

# export TERM=xterm-256color
export EDITOR="nvim"
export K9S_EDITOR="nvim"

alias merge='git config pull.rebase false'
alias rebase='git config pull.rebase true'
alias ff='git config pull.ff only'

# autoload -Uz zsh-newuser-install && zsh-newuser-install -f

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/lee/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
#
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

eval "$(direnv hook zsh)"

source ~/.config/locale.conf

alias k=kubectl
autoload -U +X compinit && compinit
source <(kubectl completion zsh)

unalias gap
alias gap='git add -p'

export CMAKE_C_COMPILER=/usr/bin/gcc

export TF_REGISTRY_CLIENT_TIMEOUT=3600

alias tf='TF_REGISTRY_CLIENT_TIMEOUT=3600 tofu'

# unset DISPLAY

tmux new

export YVM_DIR=/Users/lee/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# kubectl aliases
alias k-explain='kubectl explain --recursive'
alias k-use='kubectl config use'
export do='-o yaml --dry-run=client'

alias kaff='kubectl apply --server-side --force-conflicts -f'

# bun completions
[ -s "/Users/lee/.bun/_bun" ] && source "/Users/lee/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# export PATH="/usr/bin:$PATH"
eval "$(~/.local/bin/mise activate zsh)"

export PATH="/home/dps0340/programming/POL-POM-4:$PATH"

# Workaround for ssh hostname duplication on macos
alias ssh="/usr/bin/ssh"

export HISTTIMEFORMAT="%F %T -- "

export HOMEBREW_NO_AUTO_UPDATE=1

# Fixes below error on ansible
# https://github.com/NixOS/nixpkgs/issues/223151#issuecomment-1521702680

fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit
# prompt pure


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/usr/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/dps0340/.local/share/mamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<


alias mamba='micromamba'
alias conda='micromamba'

# Created by `pipx` on 2025-01-09 03:05:54
export PATH="$PATH:/home/dps0340/.local/bin"

# Added by Windsurf
export PATH="/Users/lee/.codeium/windsurf/bin:$PATH"
