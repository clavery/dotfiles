export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PAGER=less
export MANPAGER=$PAGER
export LC_CTYPE=en_US.UTF-8

export PS1="\[\033[01;31m\]\[\033[m\]\[\033[01;32m\]\[\033[01;34m\]\[\e[34m\] \w \$ \[\033[00m\]"
alias ls="ls -GF"

# Check the window size after every command to ensure it is correct
shopt -s checkwinsize

# Minor errors in directory names are fixed
shopt -s cdspell

# Append to history file rather than overwriting it
shopt -s histappend

# fix vim crontab issue
alias crontab="VIM_CRONTAB=true crontab"

function strip_diff_leading_symbols(){
  color_code_regex="(\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K])"

  # simplify the unified patch diff header
  gsed -r "s/^($color_code_regex)diff --git .*$//g" | \
    gsed -r "s/^($color_code_regex)index .*$/\n\1$(rule)/g" | \
    gsed -r "s/^($color_code_regex)\+\+\+(.*)$/\1+++\5\n\1$(rule)\x1B\[m/g" |\

    # actually strips the leading symbols
  gsed -r "s/^($color_code_regex)[\+\-]/\1 /g"
}

## Print a horizontal rule
rule () {
  printf "%$(tput cols)s\n"|tr " " "─"}}
}
