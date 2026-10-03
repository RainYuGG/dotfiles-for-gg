#!/usr/bin/env bash

_INIT_SOURCE_PATH="${BASH_SOURCE[0]}"
case "$_INIT_SOURCE_PATH" in
    /*) ;;
    *) _INIT_SOURCE_PATH="$PWD/$_INIT_SOURCE_PATH" ;;
esac

resolve_repo_root() {
    REPO_ROOT="$(cd -- "$(dirname -- "$_INIT_SOURCE_PATH")" && pwd -P)"
}

detect_platform() {
    DETECTED_OS="$(uname -s)" || return 1
    DETECTED_ARCH="$(uname -m)" || return 1
    PLATFORM=''
    case "$DETECTED_OS" in
        Linux) PLATFORM=ubuntu ;;
        Darwin) PLATFORM=macos ;;
        *) printf 'Unsupported platform: OS=%s architecture=%s\n' "$DETECTED_OS" "$DETECTED_ARCH" >&2; return 1 ;;
    esac
}

validate_platform() {
    detect_platform || return 1
    local ID='' VERSION_ID='' release_file="${OS_RELEASE_FILE:-/etc/os-release}"
    local line key value release_valid=1
    local assignment_pattern='^([A-Z_][A-Z0-9_]*)=(.*)$'
    local unquoted_pattern='^[a-zA-Z0-9_./:-]*$'
    local double_quoted_pattern='^"([^"\\]|\\.)*"$'
    local single_quoted_pattern="^'[^']*'$"
    if [[ "$PLATFORM" == ubuntu ]]; then
        if [[ ! -f "$release_file" || ! -r "$release_file" ]]; then
            release_valid=0
        else
            while IFS= read -r line || [[ -n "$line" ]]; do
                [[ "$line" =~ ^[[:space:]]*(#.*)?$ ]] && continue
                if [[ ! "$line" =~ $assignment_pattern ]]; then
                    release_valid=0
                    break
                fi
                key="${BASH_REMATCH[1]}"
                value="${BASH_REMATCH[2]}"
                if [[ "$value" =~ $double_quoted_pattern || "$value" =~ $single_quoted_pattern ]]; then
                    value="${value:1:${#value}-2}"
                elif [[ ! "$value" =~ $unquoted_pattern ]]; then
                    release_valid=0
                    break
                fi
                case "$key" in
                    ID) ID="$value" ;;
                    VERSION_ID) VERSION_ID="$value" ;;
                esac
            done < "$release_file" || release_valid=0
        fi
        if (( ! release_valid )); then
            printf 'Invalid or unreadable OS release file: %s\n' "$release_file" >&2
        elif [[ "$ID" == ubuntu && "$VERSION_ID" =~ ^([0-9]+)\.([0-9]+)$ ]]; then
            if (( 10#${BASH_REMATCH[1]} > 22 || (10#${BASH_REMATCH[1]} == 22 && 10#${BASH_REMATCH[2]} >= 4) )); then
                return 0
            fi
        fi
    elif [[ "$DETECTED_ARCH" == arm64 ]]; then
        return 0
    fi
    printf 'Unsupported platform: OS=%s architecture=%s distribution=%s version=%s; require Ubuntu 22.04+ or Darwin/arm64.\n' \
        "$DETECTED_OS" "$DETECTED_ARCH" "$ID" "$VERSION_ID" >&2
    return 1
}

validate_package_manager() {
    local required_command
    local -a required_commands=(git readlink)
    case "$PLATFORM" in
        ubuntu) required_commands+=(sudo apt snap) ;;
        macos)
            BREW_BIN="${BREW_BIN-/opt/homebrew/bin/brew}"
            if [[ ! -f "$BREW_BIN" || ! -x "$BREW_BIN" ]]; then
                printf 'Missing executable Homebrew at %s; install Homebrew from https://brew.sh and rerun this script.\n' "$BREW_BIN" >&2
                return 1
            fi
            ;;
        *) printf 'Validate the platform before checking package managers.\n' >&2; return 1 ;;
    esac
    for required_command in "${required_commands[@]}"; do
        if ! command -v "$required_command" >/dev/null 2>&1; then
            printf 'Missing required command %s for %s; install it manually before retrying.\n' "$required_command" "$PLATFORM" >&2
            return 1
        fi
    done
}

validate_link_destination() {
    local source="$1" destination="$2" parent
    if [[ ! -e "$source" ]]; then
        printf 'Missing link source: %s\n' "$source" >&2
        return 1
    fi
    if [[ -e "$destination" && ! -L "$destination" ]]; then
        printf 'Link conflict: %s; manually move or remove this file or directory before retrying.\n' "$destination" >&2
        return 1
    fi
    parent="$(dirname -- "$destination")"
    while [[ ! -e "$parent" && ! -L "$parent" ]]; do
        parent="$(dirname -- "$parent")"
    done
    if [[ ! -d "$parent" ]]; then
        printf 'Link parent conflict: %s; manually move or remove it before retrying.\n' "$parent" >&2
        return 1
    fi
}

validate_managed_repo() {
    local path="$1" expected_origin="$2" root origin parent
    if [[ ! -e "$path" && ! -L "$path" ]]; then
        parent="$(dirname -- "$path")"
        while [[ ! -e "$parent" && ! -L "$parent" ]]; do
            parent="$(dirname -- "$parent")"
        done
        if [[ -d "$parent" ]]; then
            return 0
        fi
        printf 'Managed repository parent conflict: %s; manually move or remove it before retrying.\n' "$parent" >&2
        return 1
    fi
    if [[ -d "$path" && ! -L "$path" ]] && \
        root="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)" && \
        [[ "$root" == "$(cd -- "$path" && pwd -P)" ]] && \
        origin="$(git -C "$path" remote get-url origin 2>/dev/null)" && \
        [[ "$origin" == "$expected_origin" ]]; then
        return 0
    fi
    printf 'Managed repository conflict: %s; expected its own Git repository with origin %s. Manually move or repair it before retrying.\n' \
        "$path" "$expected_origin" >&2
    return 1
}

preflight() {
    resolve_repo_root || return 1
    validate_platform || return 1
    validate_package_manager || return 1
    validate_link_destination "$REPO_ROOT/.tmux.conf" "$HOME/.tmux.conf" || return 1
    validate_link_destination "$REPO_ROOT/.zshrc" "$HOME/.zshrc" || return 1
    validate_link_destination "$REPO_ROOT/.config/nvim" "$HOME/.config/nvim" || return 1
    validate_managed_repo "$HOME/.oh-my-zsh" https://github.com/ohmyzsh/ohmyzsh.git || return 1
    validate_managed_repo "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" https://github.com/romkatv/powerlevel10k.git || return 1
    validate_managed_repo "$HOME/.tmux/plugins/tpm" https://github.com/tmux-plugins/tpm.git || return 1
}

ensure_link() {
    local source="$1" destination="$2"
    validate_link_destination "$source" "$destination" || return 1
    if [[ -L "$destination" ]]; then
        if [[ "$(readlink "$destination")" == "$source" || "$destination" -ef "$source" ]]; then
            return 0
        fi
        rm -- "$destination" || return 1
    fi
    mkdir -p -- "$(dirname -- "$destination")" || return 1
    ln -s -- "$source" "$destination"
}

ensure_managed_repo() {
    local path="$1" expected_origin="$2"
    case "$expected_origin" in
        https://github.com/ohmyzsh/ohmyzsh.git|https://github.com/romkatv/powerlevel10k.git|https://github.com/tmux-plugins/tpm.git) ;;
        *) printf 'Unapproved managed repository origin: %s\n' "$expected_origin" >&2; return 1 ;;
    esac
    validate_managed_repo "$path" "$expected_origin" || return 1
    if [[ ! -e "$path" && ! -L "$path" ]]; then
        mkdir -p -- "$(dirname -- "$path")" || return 1
        git clone "$expected_origin" "$path" || {
            printf 'Managed repository clone failed: git clone %s %s\n' "$expected_origin" "$path" >&2
            return 1
        }
    else
        git -C "$path" pull --ff-only || {
            printf 'Managed repository update failed: git -C %s pull --ff-only\n' "$path" >&2
            return 1
        }
    fi
}

validate_atomic_target() {
    local target="$1"
    local -a elevated=()
    if [[ "${2:-}" == sudo ]]; then
        elevated=(sudo)
    fi
    if "${elevated[@]}" test -d "$target"; then
        printf 'Generated file target conflict: %s is a directory or a symlink to a directory; manually move or remove it before retrying.\n' "$target" >&2
        return 1
    fi
}

write_atomic() (
    local target="$1" temporary
    local -a elevated=()
    if [[ "${2:-}" == sudo ]]; then
        elevated=(sudo)
    fi
    validate_atomic_target "$target" "${2:-}" || return 1
    temporary="$("${elevated[@]}" mktemp "$(dirname -- "$target")/.$(basename -- "$target").XXXXXX")" || return 1
    trap '"${elevated[@]}" rm -f -- "$temporary"' EXIT
    "${elevated[@]}" tee "$temporary" >/dev/null || return 1
    "${elevated[@]}" chmod 644 "$temporary" || return 1
    validate_atomic_target "$target" "${2:-}" || return 1
    "${elevated[@]}" mv -- "$temporary" "$target" || return 1
)

install_ubuntu_packages() (
    local -a packages=(zsh tmux bat universal-ctags xclip unzip build-essential ripgrep fd-find fzf zoxide thefuck cmatrix tree gh ca-certificates curl gnupg nodejs)
    local -a snap_packages=(nvim helm kubectl go)
    local key_download='' key_staging='' package delta_metadata
    trap 'rm -f -- "$key_download"; if [[ -n "$key_staging" ]]; then sudo rm -f -- "$key_staging"; fi' EXIT
    validate_atomic_target /etc/apt/keyrings/nodesource.gpg sudo || return 1
    sudo apt update || return 1
    sudo apt install -y "${packages[@]:0:${#packages[@]}-1}" || return 1
    sudo mkdir -p /etc/apt/keyrings /etc/apt/sources.list.d || return 1
    key_download="$(mktemp)" || return 1
    curl --fail --silent --show-error --location https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key --output "$key_download" || return 1
    key_staging="$(sudo mktemp /etc/apt/keyrings/.nodesource.gpg.XXXXXX)" || return 1
    sudo gpg --batch --yes --dearmor --output "$key_staging" "$key_download" || return 1
    sudo chmod 644 "$key_staging" || return 1
    validate_atomic_target /etc/apt/keyrings/nodesource.gpg sudo || return 1
    sudo mv -- "$key_staging" /etc/apt/keyrings/nodesource.gpg || return 1
    key_staging=''
    printf '%s\n' 'deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main' |
        write_atomic /etc/apt/sources.list.d/nodesource.list sudo || return 1
    sudo apt update || return 1
    sudo apt install -y "${packages[${#packages[@]}-1]}" || return 1
    if delta_metadata="$(apt-cache show git-delta 2>/dev/null)" &&
        grep -qx 'Package: git-delta' <<< "$delta_metadata"; then
        sudo apt install -y git-delta || return 1
    fi
    for package in "${snap_packages[@]}"; do
        if ! snap list "$package" >/dev/null 2>&1; then
            sudo snap install "$package" --classic || return 1
        fi
    done
)

install_macos_packages() {
    local -a packages=(tmux bat universal-ctags unzip ripgrep fd thefuck cmatrix tree gh neovim helm kubernetes-cli go git-delta fzf zoxide node@22)
    local entry remaining_path="$PATH" next_path='/opt/homebrew/opt/node@22/bin:/opt/homebrew/bin'
    "$BREW_BIN" install "${packages[@]}" || return 1
    while :; do
        entry="${remaining_path%%:*}"
        case "$entry" in
            /opt/homebrew/opt/node@22/bin|/opt/homebrew/bin) ;;
            *) next_path+=":$entry" ;;
        esac
        [[ "$remaining_path" == *:* ]] || break
        remaining_path="${remaining_path#*:}"
    done
    export PATH="$next_path"
}

install_platform_packages() {
    case "$PLATFORM" in
        ubuntu) install_ubuntu_packages ;;
        macos) install_macos_packages ;;
        *) printf 'Unsupported installer platform: %s\n' "$PLATFORM" >&2; return 1 ;;
    esac
}

configure_delta_if_available() {
    if command -v delta >/dev/null 2>&1; then
        git config --global core.pager delta || return 1
        git config --global interactive.diffFilter 'delta --color-only' || return 1
        git config --global delta.navigate true || return 1
        git config --global delta.dark true || return 1
        git config --global delta.side-by-side true || return 1
    fi
}

install_tpm() {
    local path="$HOME/.tmux/plugins/tpm"
    ensure_managed_repo "$path" https://github.com/tmux-plugins/tpm.git || return 1
    printf 'Installing/Updating tmux plugins...\n'
    "$path/bin/install_plugins" || {
        printf 'TPM plugin installation failed: %s\n' "$path" >&2
        return 1
    }
}

configure_shared() (
    local completion
    completion="$(mktemp)" || return 1
    trap 'rm -f -- "$completion"' EXIT
    mkdir -p -- "$HOME/.npm-global" || return 1
    npm config set prefix "$HOME/.npm-global" || return 1
    git config --global core.editor nvim || return 1
    git config --global merge.conflictstyle diff3 || return 1
    git config --global diff.colorMoved default || return 1
    configure_delta_if_available || return 1
    if command -v gh >/dev/null 2>&1; then
        gh config set editor nvim || return 1
        gh config set git_protocol ssh || return 1
        if ! gh auth status >/dev/null 2>&1; then
            printf "Tip: Run 'gh auth login' to authenticate with GitHub CLI.\n"
        fi
    fi
    ensure_managed_repo "$HOME/.oh-my-zsh" https://github.com/ohmyzsh/ohmyzsh.git || return 1
    ensure_managed_repo "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" https://github.com/romkatv/powerlevel10k.git || return 1
    kubectl completion zsh > "$completion" || return 1
    write_atomic "$HOME/.kube-completion.bash" < "$completion" || return 1
    install_tpm || return 1
    printf 'Updating Neovim plugins...\n'
    nvim --headless "+Lazy! update" +qa || return 1
)

main() {
    set -euo pipefail
    preflight || return 1
    ensure_link "$REPO_ROOT/.tmux.conf" "$HOME/.tmux.conf" || return 1
    ensure_link "$REPO_ROOT/.zshrc" "$HOME/.zshrc" || return 1
    ensure_link "$REPO_ROOT/.config/nvim" "$HOME/.config/nvim" || return 1
    install_platform_packages || return 1
    configure_shared || return 1
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
