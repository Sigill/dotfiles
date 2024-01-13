case $TERM in
xterm*|rxvt*)
    PS1_TITLEBAR="\[\033]0;\u@\h: \w\007\]"
    ;;
*)
    PS1_TITLEBAR=""
    ;;
esac

my_prompt_command() {
    local prev_command_status=$?

    # Print status of previously executed command.
    if [[ "$TERM_PROGRAM" != vscode ]]; then # VSCode already has a similar feature, so skip it.
        if [[ $prev_command_status -eq 0 ]]; then
            local status_last_command="\[\033[34m\]●\[\033[0m\] "
        else
            local status_last_command="\[\033[31m\]●\[\033[0m\] "
        fi
    fi

    __git_ps1 "${PS1_TITLEBAR}${status_last_command}\t \[\033[01;33m\]\u\[\033[0m\]@\[\033[01;32m\]\h\[\033[0m\] \[\033[01;34m\]\w\[\033[0m\]" "\$ " " [%s]"
}

# See https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_STATESEPARATOR=" "
export GIT_PS1_OMITSPARSESTATE=1
export GIT_PS1_SHOWCONFLICTSTATE=yes
export GIT_PS1_SHOWCOLORHINTS=true

PROMPT_COMMAND=my_prompt_command
