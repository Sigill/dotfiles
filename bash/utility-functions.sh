# https://unix.stackexchange.com/a/291611
function path_remove() { # $1 directory to remove.
  # Delete path by parts so we can never accidentally remove sub paths
  if [[ "$PATH" == "$1" ]]; then
    export PATH=""
  fi
  export PATH=${PATH//":$1:"/":"} # delete any instances in the middle
  export PATH=${PATH/#"$1:"/} # delete any instance at the beginning
  export PATH=${PATH/%":$1"/} # delete any instance in the at the end
}

function path_prepend() { # $1 directory to prepend.
  path_remove "$1"

  if [[ -z "$PATH" ]]; then
    export PATH=$1
  else
    export PATH=$1:$PATH
  fi
}
