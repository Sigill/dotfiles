#!/bin/bash

HERE=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
VERBOSE=

function yes_or_no {
  local QUESTION=$1
  local DEFAULT=$2
  local INPUT

  if [ "$DEFAULT" = true ]; then
    OPTIONS="[Y/n]"
    DEFAULT="y"
  else
    OPTIONS="[y/N]"
    DEFAULT="n"
  fi

  while true; do
    read -p "$QUESTION $OPTIONS " -n 1 -s -r INPUT
    INPUT=${INPUT:-${DEFAULT}}
    echo $INPUT
    case $INPUT in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
    esac
  done
}

function link_to() {
  if [ $# -ne 2 ]; then
    >&2 echo "Usage: $0 <src> <dst>"
    return -1
  fi

  local src=$(realpath "$1")
  local dst=$2

  if [ -e "$dst" ]; then
    if [ -L "$dst" ]; then
      if [ "$(readlink -f -- "$dst")" = "$src" ]; then
        [ -n "$VERBOSE" ] && >&2 echo "Skipping $dst -> $src"
        return 0
      else
        >&2 echo "Updating $dst -> $src"
        ln -sfT "$src" "$dst"
      fi
    else
      >&2 echo "Aborting $dst -> $src (already exists)"
      return -1
    fi
  else
    >&2 echo "Creating $dst -> $src"
    ln -sT "$src" "$dst"
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

link_to $HERE/vim/.vim ~/.vim
link_to $HERE/vim/.vimrc ~/.vimrc

link_to $HERE/git/.gitconfig ~/.gitconfig
