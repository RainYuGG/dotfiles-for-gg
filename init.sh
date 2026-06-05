#!/usr/bin/env bash

# set softlinks
ln -s $(pwd)/.tmux.conf ~/.tmux.conf
ln -s $(pwd)/.zshrc ~/.zshrc
ln -s $(pwd)/.config/nvim ~/.config/nvim

# install packages from apt & snap
sudo apt install zsh tmux bat autojump universal-ctags xsel font-manager unzip golang-go build-essential ripgrep fd-find thefuck cmatrix tree -y
sudo snap install nvim --classic
sudo snap install helm --classic
sudo snap install kubectl --classic
kubectl completion zsh > ~/.kube-completion.bash 

# git configure
# git config --global credential.helper store # deprecated: now use libsecret to protect credential
git config --global core.editor nvim
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.dark true  # or `delta.light true`, or omit for auto-detection
git config --global delta.side-by-side true
git config --global merge.conflictstyle zdiff3
git config --global diff.colorMoved default

# omz

# tpm

# fzf

# fonts

# npm
sudo apt update
sudo apt install -y ca-certificates curl gnupg

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=22

echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
  | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt update
sudo apt install -y nodejs
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
