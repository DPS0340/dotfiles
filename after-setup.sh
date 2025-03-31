#!/bin/sh

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

LOCATION=$(realpath "$0")
DIR=$(dirname "$LOCATION")

# Cache sudo credential
sudo -v

chsh -s $(which zsh)

nvim +'PlugInstall --sync' +qa
nvim +'CocInstall coc-yaml coc-rust-analyzer coc-pyright coc-json coc-go coc-tsserver coc-marksman' +qa

python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)"

gh auth login

(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

kubectl krew install ctx
kubectl krew install ns
kubectl krew install rook-ceph
kubectl krew install view-secret
kubectl krew install view-cert
kubectl krew install neat
kubectl krew install df-pv

(crontab -l 2>/dev/null; cat $DIR/crontab)| crontab -

