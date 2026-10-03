# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset _shell_os="$(uname -s)" _shell_arch="$(uname -m)"
typeset _shell_id='' _shell_version='' _shell_line _shell_value
typeset _shell_version_pattern='^([0-9]+)\.([0-9]+)$'
SHELL_PLATFORM=''
case "$_shell_os" in
  Linux)
    if [[ -r /etc/os-release ]]; then
      while IFS= read -r _shell_line || [[ -n $_shell_line ]]; do
        case "$_shell_line" in
          ID=*|VERSION_ID=*)
            _shell_value=${_shell_line#*=}
            if [[ $_shell_value == \"*\" || $_shell_value == \'*\' ]]; then
              _shell_value=${_shell_value[2,-2]}
            fi
            case "$_shell_line" in
              ID=*) _shell_id=$_shell_value ;;
              VERSION_ID=*) _shell_version=$_shell_value ;;
            esac
            ;;
        esac
      done < /etc/os-release
    fi
    if [[ $_shell_id == ubuntu && $_shell_version =~ $_shell_version_pattern ]] &&
       (( 10#$match[1] > 22 || (10#$match[1] == 22 && 10#$match[2] >= 4) )); then
      SHELL_PLATFORM=ubuntu
    fi
    ;;
  Darwin)
    [[ $_shell_arch == arm64 ]] && SHELL_PLATFORM=macos
    ;;
esac
if [[ -z $SHELL_PLATFORM ]]; then
  print -u2 -r -- "Unsupported platform: OS=$_shell_os architecture=$_shell_arch distribution=$_shell_id version=$_shell_version; require Ubuntu 22.04+ or Darwin/arm64."
  return 1
fi
unset _shell_os _shell_arch _shell_id _shell_version _shell_line _shell_value _shell_version_pattern

typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.npm-global/bin" "$HOME/dotfiles/git-fuzzy/bin" $path /usr/local/go/bin "$HOME/go/bin")
typeset -a CLIP_COPY_CMD CLIP_PASTE_CMD
case "$SHELL_PLATFORM" in
  ubuntu)
    FD_CMD=fdfind
    BAT_CMD=batcat
    OPEN_CMD=xdg-open
    CLIP_COPY_CMD=(xclip -selection clipboard)
    CLIP_PASTE_CMD=(xclip -selection clipboard -o)
    if (( $+commands[java] && $+commands[readlink] )); then
      if _shell_java="$(command readlink -f "$commands[java]" 2>/dev/null)" && [[ -n $_shell_java ]]; then
        export JAVA_HOME=${_shell_java:h:h}
      fi
    fi
    ;;
  macos)
    path=(/opt/homebrew/opt/node@22/bin /opt/homebrew/bin $path)
    FD_CMD=fd
    BAT_CMD=bat
    OPEN_CMD=open
    CLIP_COPY_CMD=(pbcopy)
    CLIP_PASTE_CMD=(pbpaste)
    if [[ -x /usr/libexec/java_home ]]; then
      if _shell_java="$(/usr/libexec/java_home 2>/dev/null)" && [[ -n $_shell_java ]]; then
        export JAVA_HOME=$_shell_java
      fi
    fi
    ;;
esac
unset _shell_java

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=''
if [[ -f "${ZSH_CUSTOM:-$ZSH/custom}/powerlevel10k/powerlevel10k.zsh-theme" ||
      -f "${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" ||
      -f "$ZSH/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi
plugins=(git)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if (( ! $+functions[compdef] )) &&
   { { (( $+commands[npm] )) && [[ -r "$HOME/.npm-completion.bash" ]]; } ||
     { (( $+commands[kubectl] )) && [[ -r "$HOME/.kube-completion.bash" ]]; } ||
     (( $+commands[fzf] )); }; then
  autoload -Uz compinit
  compinit -i -D
fi

if (( $+commands[fzf] )); then
  if [[ -r "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
  else
    case "$SHELL_PLATFORM" in
      ubuntu) _shell_fzf_dir=/usr/share/doc/fzf/examples ;;
      macos) _shell_fzf_dir=/opt/homebrew/opt/fzf/shell ;;
    esac
    for _shell_fzf_file in completion.zsh key-bindings.zsh; do
      if [[ -r "$_shell_fzf_dir/$_shell_fzf_file" ]]; then
        source "$_shell_fzf_dir/$_shell_fzf_file"
      fi
    done
    unset _shell_fzf_dir _shell_fzf_file
  fi
fi
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1 --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
if [[ $SHELL_PLATFORM == macos ]] && (( $+commands[fzf] )); then
  if (( $+commands[fd] )); then
    export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
  if (( $+commands[bat] )); then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always -- {}'"
  fi
  if (( $+commands[tree] )); then
    export FZF_ALT_C_OPTS="--preview 'tree -C -- {}'"
  fi
fi

if (( $+commands[npm] )) && [[ -r "$HOME/.npm-completion.bash" ]]; then
  source "$HOME/.npm-completion.bash"
fi
if (( $+commands[kubectl] )) && [[ -r "$HOME/.kube-completion.bash" ]]; then
  source "$HOME/.kube-completion.bash"
fi
_ZO_DATA_DIR='$HOME/.local/share'
_ZO_ECHO='1'
if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd cd zsh)"
fi
if (( $+commands[thefuck] )); then
  eval "$(thefuck --alias)"
fi

alias diff='delta'
alias fd="$FD_CMD"
alias bat="$BAT_CMD"
alias cat="$BAT_CMD"
alias open="$OPEN_CMD"
alias re='exec $SHELL'
alias so='source ~/.zshrc; tmux source ~/.tmux.conf'
alias nr='npm run'
alias rr='clear'
alias vim='nvim'
alias vimdiff='nvim -d'
alias lg='lazygit'
alias python='python3'
alias py='python3'
alias dk='docker'
alias oc='opencode'
alias glog='git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium --oneline'
alias gpfwl='git push --force-with-lease origin $(git rev-parse --abbrev-ref HEAD)'
alias gpsu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gcfd='git clean -fd'
alias k='kubectl'

unalias gco kgp kcp kpod p 2>/dev/null
gco() {
  if (( $# )); then
    command git checkout "$@"
    return $?
  fi
  (( $+commands[git] && $+commands[fzf] )) || return 1
  [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1
  local current refs ref symbolic branch selection
  local -aU branches
  current=$(command git rev-parse --abbrev-ref HEAD) || return
  refs=$(command git for-each-ref --sort=-committerdate --format='%(refname)%09%(symref)' refs/heads refs/remotes) || return
  while IFS=$'\t' read -r ref symbolic; do
    [[ -n $ref && -z $symbolic ]] || continue
    case "$ref" in
      refs/heads/*) branch=${ref#refs/heads/} ;;
      refs/remotes/*) branch=${ref#refs/remotes/}; branch=${branch#*/} ;;
      *) continue ;;
    esac
    [[ $branch != "$current" ]] && branches+=("$branch")
  done <<< "$refs"
  (( ${#branches} )) || return 0
  selection=$(print -rl -- "${branches[@]}" | fzf --header "Checkout Recent Branch. current branch: $current" --preview 'git diff {} --color=always' --preview-window top) || return 0
  [[ -n $selection ]] || return 0
  command git checkout "$selection"
}

kgp() {
  (( $+commands[kubectl] && $+commands[fzf] )) || return 1
  local pods pod
  pods=$(command kubectl get pods --no-headers -o 'custom-columns=:metadata.name') || return
  [[ -n $pods ]] || return 0
  pod=$(print -r -- "$pods" | fzf) || return 0
  [[ -n $pod ]] || return 0
  print -r -- "$pod"
}
kcp() {
  (( $+commands[kubectl] )) || return 1
  if (( $# != 1 )); then
    command kubectl cp "$@"
    return $?
  fi
  local pod
  pod=$(kgp) || return
  [[ -n $pod ]] || return 0
  command kubectl cp "$1" "$pod:/tmp/."
}
kpod() {
  local pod
  pod=$(kgp) || return
  [[ -n $pod ]] || return 0
  command kubectl exec -it "$pod" -- /bin/bash
}

c() {
  if (( $# == 0 )); then
    "${CLIP_COPY_CMD[@]}"
  else
    command cat -- "$@" | "${CLIP_COPY_CMD[@]}"
  fi
}
p() {
  "${CLIP_PASTE_CMD[@]}"
}

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

if [[ -r "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi
