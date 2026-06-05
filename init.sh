#!/usr/bin/env bash

set -euo pipefail

# set softlinks (force create/update)
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/.zshrc ~/.zshrc
mkdir -p ~/.config
ln -sf $(pwd)/.config/nvim ~/.config/nvim

# install packages from apt & snap
sudo apt update && sudo apt install -y zsh tmux bat universal-ctags xclip font-manager unzip build-essential ripgrep fd-find thefuck cmatrix tree gh

# snap packages
snap_packages=(nvim helm kubectl go)
for pkg in "${snap_packages[@]}"; do
    if ! snap list | grep -q "^$pkg "; then
        echo "Installing $pkg via snap..."
        sudo snap install "$pkg" --classic
    else
        echo "$pkg already installed via snap."
    fi
done

kubectl completion zsh > ~/.kube-completion.bash 

# git configure
git config --global core.editor nvim
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.dark true
git config --global delta.side-by-side true
git config --global merge.conflictstyle zdiff3
git config --global diff.colorMoved default

# gh configure
if command -v gh &> /dev/null; then
    echo "Configuring GitHub CLI..."
    gh config set editor nvim
    gh config set git_protocol ssh
    # Optional: check authentication
    if ! gh auth status &> /dev/null; then
        echo "Tip: You are not logged into GitHub CLI. Run 'gh auth login' to authenticate."
    fi
fi

# tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed, updating..."
    cd ~/.tmux/plugins/tpm && git pull
fi
echo "Installing/Updating tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins

# fzf
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
else
    echo "fzf already installed, skipping..."
fi

# npm setup
if [ ! -f /etc/apt/keyrings/nodesource.gpg ]; then
    echo "Setting up Node.js repository..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    NODE_MAJOR=22
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
      | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt update
fi
sudo apt install -y nodejs
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
