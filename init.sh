#!/usr/bin/env bash

# set softlinks (force create/update)
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/.zshrc ~/.zshrc
mkdir -p ~/.config
ln -sf $(pwd)/.config/nvim ~/.config/nvim

# install packages from apt & snap
sudo apt update && sudo apt install -y zsh tmux bat universal-ctags xclip font-manager unzip build-essential ripgrep fd-find thefuck cmatrix tree
sudo snap install nvim --classic || true
sudo snap install helm --classic || true
sudo snap install kubectl --classic || true
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
