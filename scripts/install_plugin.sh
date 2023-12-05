#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"

ensure_path_exists(){
	local directory="$1"
	mkdir -p "$directory"
}

clone(){
	local directory="$1"
	local plugin="$2"
	local branch="$3"
	ensure_path_exists "$directory" &&
		cd "$directory" 
	if [ -n "$branch" ]; then
		GIT_TERMINAL_PROMPT=0 git clone -b "$branch" --single-branch --recursive "$plugin" >/dev/null 2>&1
	else
		GIT_TERMINAL_PROMPT=0 git clone --single-branch --recursive "$plugin" >/dev/null 2>&1
	fi
}

clone_plugin(){
	local directory="$1"
	local plugin="$2"
	local branch="$3"
	clone "$directory" "$plugin" "$branch" || # echo "gg"
		clone "$directory" "${install_url%/}/$plugin" "$branch"
}

# For testing: 
# clone_plugin "$PWD/abc" sbugzu/gruvbox-zsh 
