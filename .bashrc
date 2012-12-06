export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PAGER=less
export MANPAGER=$PAGER
export LC_CTYPE=en_US.UTF-8

export PS1="\[\033[01;31m\]\[\033[m\]\[\033[01;32m\]@\h\[\033[01;34m\]\[\e[34m\] \$ \[\033[00m\]"
alias ls="ls -GF"

# Check the window size after every command to ensure it is correct
shopt -s checkwinsize

# Minor errors in directory names are fixed
shopt -s cdspell

# Append to history file rather than overwriting it
shopt -s histappend

# fix vim crontab issue
alias crontab="VIM_CRONTAB=true crontab"
