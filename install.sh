#!/bin/bash

HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
VERBOSE=

function info() {
  >&2 echo "$@"
}

function info_v() {
  [ -n "$VERBOSE" ] && info "$@"
}

function error() {
  >&2 echo -e "\033[31m$*\033[0m"
}

function run() {
  "$@"
  local status=$?
  if [[ $status -ne 0 ]]; then
    error "Command failed:" "$@"
  fi
}

function yes_or_no {
  local QUESTION=$1
  local DEFAULT=$2
  local RESPONSE

  if [ "$DEFAULT" = true ]; then
    OPTIONS="[Y/n]"
    DEFAULT="y"
  else
    OPTIONS="[y/N]"
    DEFAULT="n"
  fi

  while true; do
    read -p "$QUESTION $OPTIONS " -n 1 -s -r RESPONSE
    RESPONSE=${RESPONSE:-${DEFAULT}}
    >&2 echo "$RESPONSE"
    case $RESPONSE in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
    esac
  done
}

function link_to() {
  if [ $# -ne 2 ]; then
    info "Usage: $0 <src> <dst>"
    return 1
  fi

  # shellcheck disable=SC2155
  local src=$(realpath "$1")
  local dst=$2

  if [ -e "$dst" ]; then
    if [ -L "$dst" ]; then
      if [ "$(readlink -f -- "$dst")" = "$src" ]; then
        info_v "[SKIPPED] ln -sT \"$src\" \"$dst\""
        return 0
      else
        run ln -sfT "$src" "$dst"
      fi
    else
      error "[SKIPPED] ln -sT \"$src\" \"$dst\" (target already exists)"
      return 1
    fi
  else
    run ln -sT "$src" "$dst"
  fi
}

function install_bash_plugins() {
  info "Generating $HERE/bash/rc.sh"

  local BASH_DIR=$HERE/bash
  local BASH_RC_FILE=$HERE/bash/rc.sh

  if [ -e "$HERE/bash/plugins.custom.txt" ]; then
    local BASH_PLUGINS_LIST="$HERE/bash/plugins.custom.txt"
  else
    local BASH_PLUGINS_LIST="$HERE/bash/plugins.txt"
  fi

  {
    local plugin_name
    while read -r plugin_name; do
      if grep -q "^$plugin_name\$" "$BASH_PLUGINS_LIST"; then
        local plugin_script=$BASH_DIR/$plugin_name.sh
        if [[ -r "$plugin_script" ]]; then
          info -e "\t[x] $plugin_script"
          echo source "\"$plugin_script\""
        else
          error "\t[ ] $plugin_script (file does not exists)"
        fi
      else
        info -e "\t[ ] $plugin_script"
      fi
    done < "$HERE/bash/plugins.txt"
  } > "$BASH_RC_FILE"

  local register_bashrc_command="source \"$BASH_RC_FILE\""
  if grep -q -F "$register_bashrc_command" ~/.bashrc 2> /dev/null; then
    info_v "[SKIPPED] ~/.bashrc registration"
  else
    info "echo \"$register_bashrc_command\" >> ~/.bashrc"
    echo "$register_bashrc_command" >> ~/.bashrc
  fi
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
  esac
done

link_to "$HERE/vim/.vim" ~/.vim
link_to "$HERE/vim/.vimrc" ~/.vimrc

link_to "$HERE/git/.gitconfig" ~/.gitconfig

install_bash_plugins
