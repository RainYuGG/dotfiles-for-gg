#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# ------------------------------------------------------------------------------
# 1. Detect Platform
# ------------------------------------------------------------------------------
echo "==> [1/8] Detecting platform..."
DETECTED_OS="$(uname -s)"
DETECTED_ARCH="$(uname -m)"

case "$DETECTED_OS" in
    Linux)  PLATFORM="ubuntu" ;;
    Darwin) PLATFORM="macos" ;;
    *)
        echo "Unsupported OS: $DETECTED_OS ($DETECTED_ARCH)" >&2
        exit 1
        ;;
esac

echo "Platform: $PLATFORM, Architecture: $DETECTED_ARCH"

# ------------------------------------------------------------------------------
# 2. Create Dotfiles Symlinks
# ------------------------------------------------------------------------------
echo "==> [2/8] Creating dotfiles symlinks..."
mkdir -p "$HOME/.config"
ln -snf "$REPO_ROOT/.tmux.conf" "$HOME/.tmux.conf"
ln -snf "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
ln -snf "$REPO_ROOT/.config/nvim" "$HOME/.config/nvim"
echo "Symlinks created (.tmux.conf, .zshrc, .config/nvim)"

# ------------------------------------------------------------------------------
# 3. Install Base Packages via Package Manager (APT / Homebrew)
# ------------------------------------------------------------------------------
echo "==> [3/8] Installing base packages via package manager..."
if [[ "$PLATFORM" == "ubuntu" ]]; then
    echo "Installing Ubuntu base packages via apt..."
    sudo apt update
    sudo apt install -y \
        zsh tmux bat universal-ctags xclip unzip build-essential \
        ripgrep fd-find zoxide thefuck cmatrix tree gh ca-certificates curl gnupg

    # Ubuntu package names conflict resolution: fd-find installs as 'fdfind', bat as 'batcat'
    if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        echo "Creating symlink for fd (/usr/local/bin/fd -> $(which fdfind))..."
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi
    if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
        echo "Creating symlink for bat (/usr/local/bin/bat -> $(which batcat))..."
        sudo ln -sf "$(which batcat)" /usr/local/bin/bat
    fi
elif [[ "$PLATFORM" == "macos" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            echo "Homebrew not found. Please install Homebrew from https://brew.sh and rerun this script." >&2
            exit 1
        fi
    fi
    echo "Installing macOS packages via Homebrew..."
    brew install \
        tmux bat universal-ctags unzip ripgrep fd thefuck cmatrix tree gh \
        neovim helm kubernetes-cli go git-delta fzf zoxide node@22 tree-sitter-cli
fi

# ------------------------------------------------------------------------------
# 4. Set up Node.js and Snap Packages
# ------------------------------------------------------------------------------
echo "==> [4/8] Setting up Node.js and snap packages..."
if [[ "$PLATFORM" == "ubuntu" ]]; then
    if ! command -v node >/dev/null 2>&1 || [[ "$(node -v 2>/dev/null)" != v22* ]]; then
        echo "Ubuntu: Setting up NodeSource repository and installing Node.js 22..."
        sudo mkdir -p /etc/apt/keyrings /etc/apt/sources.list.d
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null
        sudo apt update
        sudo apt install -y nodejs
    else
        echo "Ubuntu: Node.js 22 is already installed."
    fi

    echo "Ubuntu: Installing snap packages (nvim, helm, kubectl, go)..."
    for pkg in nvim helm kubectl go; do
        if ! snap list "$pkg" >/dev/null 2>&1; then
            echo "Installing $pkg via snap..."
            sudo snap install "$pkg" --classic
        else
            echo "$pkg is already installed via snap."
        fi
    done
else
    echo "macOS: Node.js and developer tools were already installed via Homebrew."
fi

mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

if ! command -v bun >/dev/null 2>&1; then
    echo "Installing bun via npm..."
    npm install -g --allow-scripts=bun bun
else
    echo "bun is already installed."
fi
export PATH="$HOME/.bun/bin:$PATH"

# ------------------------------------------------------------------------------
# 5. Install git-delta
# ------------------------------------------------------------------------------
echo "==> [5/8] Installing git-delta..."
if [[ "$PLATFORM" == "ubuntu" ]]; then
    if ! command -v delta >/dev/null 2>&1; then
        echo "Ubuntu: Downloading and installing .deb from dandavison/delta releases..."
        DELTA_ARCH="$(dpkg --print-architecture 2>/dev/null || uname -m)"
        case "$DELTA_ARCH" in
            amd64|x86_64) DELTA_ARCH="amd64" ;;
            arm64|aarch64) DELTA_ARCH="arm64" ;;
            *) echo "Unsupported architecture for delta: $DELTA_ARCH" >&2; exit 1 ;;
        esac
        DELTA_DEB="$(mktemp --suffix=.deb)"
        curl -fsSL "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${DELTA_ARCH}.deb" -o "$DELTA_DEB"
        sudo dpkg -i "$DELTA_DEB"
        rm -f "$DELTA_DEB"
    else
        echo "git-delta is already installed."
    fi
else
    echo "macOS: git-delta is already installed via Homebrew."
fi

# ------------------------------------------------------------------------------
# 6. Install fzf
# ------------------------------------------------------------------------------
echo "==> [6/8] Installing fzf..."
if [[ "$PLATFORM" == "ubuntu" ]]; then
    if [[ ! -d "$HOME/.fzf" ]]; then
        echo "Ubuntu: Installing fzf via git clone..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all --no-update-rc
    else
        echo "Ubuntu: Updating existing fzf..."
        git -C "$HOME/.fzf" pull --ff-only || true
        "$HOME/.fzf/install" --all --no-update-rc
    fi
else
    echo "macOS: fzf is already installed via Homebrew."
fi

# ------------------------------------------------------------------------------
# 7. Shell and Terminal Extensions (oh-my-zsh, powerlevel10k, TPM)
# ------------------------------------------------------------------------------
echo "==> [7/8] Setting up oh-my-zsh, powerlevel10k, and TPM..."

# oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Cloning oh-my-zsh..."
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
    echo "oh-my-zsh is already installed, checking for updates..."
    git -C "$HOME/.oh-my-zsh" pull --ff-only || true
fi

# powerlevel10k theme
P10K_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    echo "Cloning powerlevel10k theme..."
    git clone https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "powerlevel10k is already installed, checking for updates..."
    git -C "$P10K_DIR" pull --ff-only || true
fi

# tpm (tmux plugin manager)
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    echo "Cloning tmux TPM..."
    git clone https://github.com/tmux-plugins/tpm.git "$TPM_DIR"
else
    echo "TPM is already installed, checking for updates..."
    git -C "$TPM_DIR" pull --ff-only || true
fi

echo "Installing/updating tmux plugins via TPM..."
"$TPM_DIR/bin/install_plugins" || true

# ------------------------------------------------------------------------------
# 8. Tool Configuration (Git, GitHub CLI, Kubectl, Neovim)
# ------------------------------------------------------------------------------
echo "==> [8/8] Configuring Git, GitHub CLI, Kubectl, and Neovim..."

# Git config
git config --global core.editor nvim
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default
if command -v delta >/dev/null 2>&1; then
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global delta.dark true
    git config --global delta.side-by-side true
fi

# GitHub CLI
if command -v gh >/dev/null 2>&1; then
    gh config set editor nvim
    gh config set git_protocol ssh
    if ! gh auth status >/dev/null 2>&1; then
        echo "Tip: Run 'gh auth login' to authenticate with GitHub CLI."
    fi
fi

# Kubectl zsh completion
if command -v kubectl >/dev/null 2>&1; then
    kubectl completion zsh > "$HOME/.kube-completion.bash"
fi

# Neovim plugins update
if command -v nvim >/dev/null 2>&1; then
    echo "Updating Neovim plugins via Lazy..."
    nvim --headless "+Lazy! update" +qa || true
fi

echo "==> All setup steps completed successfully!"
