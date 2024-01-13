if [ -x /usr/bin/dircolors ]; then
  # shellcheck disable=SC2015
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

alias l='ls -CF'
alias ll='ls -hlF'
alias lll='ll --block-size=1' # Print in bytes.
