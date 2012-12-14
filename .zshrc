## .zshrc
## Charles Lavery
## charles.lavery@gmail.com

# System info
HOSTNAME=`hostname -s`
HOST_OS=`uname|tr '[:upper:]' '[:lower:]'`

export HISTSIZE=1000
export EDITOR=vim

######## Load Modules ########

autoload colors; colors;
# zsh move
autoload -U zmv
autoload -U zcalc
zmodload zsh/stat
## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic


######## Options #########
unsetopt AUTO_CD
setopt ALWAYSLASTPROMPT # try to return to the last prompt if given no numeric argument.
setopt APPENDHISTORY    # zsh sessions will append their history  list  to the  history file, rather than overwrite it.
setopt EQUALS                   # Perform = filename expansion.
setopt EXTENDEDHISTORY  # Save  each  command's  beginning timestamp
setopt FUNCTIONARGZERO  # When  executing  a  shell  function or sourcing a script, set $0 temporarily to the name of the function/script.
setopt HISTIGNOREDUPS   # Do not enter command lines into the history  list  if  they  are duplicates of the previous event.
setopt HISTIGNORESPACE  # Remove  command lines from the history list when the first character on the line is a  space.
setopt LONGLISTJOBS     # List jobs in the long format by default.
setopt MULTIOS                  # Perform implicit tees or cats  when  multiple  redirections  are attempted
setopt PRINTEIGHTBIT    # Print eight bit characters literally in completion  lists
setopt RMSTARSILENT     # Do not query the user before executing `rm *' or `rm path/*'.
setopt SHORTLOOPS               # Allow the short forms of for,  select,  if,  and  function  constructs.
setopt CLOBBER
unsetopt CORRECT

# directory stack
unsetopt AUTO_NAME_DIRS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

######## Key bindings #######

# emacs mode
bindkey -e

# better for gnu screen
bindkey "^B" beginning-of-line

# edit command line in vi with Ctrl-x Ctrl-e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

######## PAGER ###########

# less colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export PAGER=less
export MANPAGER=less

# less options
export LESS="--ignore-case"

# less open scripts if avaliable
[ -x ~/bin/lessopen.sh ] && export LESSOPEN="| ~/bin/lessopen.sh %s"

######## ls colors ########

# cross-platform color ls
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

export CLICOLORS=1
# bsd
export LSCOLORS=exfxcxdxbxegedabagacad
# gnu
export LS_COLORS="di=34:ex=31:no=00:ow=90;43:"

########## PATHS ##########

export PATH=~/bin:/usr/local/bin:/usr/local/sbin:$PATH

case $HOST_OS in
  darwin)
    export PATH=/usr/local/share/npm/bin:$PATH
    export NODE_PATH=/usr/local/lib/node_modules

    export MANPATH=/usr/local/share/man:$MANPATH

    export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
  ;;
  linux)
    export JAVA_HOME="/usr/java"
  ;;
esac

######### Functions #########

# number of minutes since last commit
minutes_since_last_commit() {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}

# are we in a git repo? helper function
# git branch is fast
in_git() {
  git branch > /dev/null 2>&1
  if [[ $? == 0 ]] {
    IN_GIT_REPO=true
  } else {
    IN_GIT_REPO=false
  }
}

# Find .env file in current dir or parent dirs and source it
# run 'unmagic' function when leaving directory tree.
_MAGIC_FILE=".env"
_LAST_DIRECTORY=""
check_magic() {
  FOUND=""

  # Ugly directory search. previous code "walked" up directories
  # but was breaking directory stack in strange ways
  p="."
  path_exp=`echo $p(:A)`
  while [[ ( "$path_exp" != "`echo ~(:A)`" ) && ( "$path_exp" != "/" ) ]];
  do
    # zsh path expansion
    path_exp=`echo $p(:A)`
    if [ -f "$path_exp/$_MAGIC_FILE" ]; then
      FOUND="$path_exp"
      break
    fi
    p=${p}/..
  done

  if [[ -z $FOUND ]]; then
    if [[ ! -z $functions[unmagic] ]]; then
      unmagic
      unset -f unmagic
    fi
  else
    if [[ "$FOUND" != "$PWD" ]]; then
      builtin cd -q $FOUND
      source "$_MAGIC_FILE"
      builtin cd -q $OLDPWD
    else
      source "$_MAGIC_FILE"
    fi
  fi
}

########## Version Control Info Module ##########

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
# string to print when something is in the index
zstyle ':vcs_info:*' stagedstr '%F{green}●%f'
# string to print when changes but not in index
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●%f'
zstyle ':vcs_info:*' actionformats '<%b%F{3}%c%u%F{1}> %a'
zstyle ':vcs_info:*' formats '<%b%F{3}%c%u%F{1}>'
# show branch name and revision in svn
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r%f%F{1}'

######## PROMPT #########

# enable prompt substitution
setopt prompt_subst

# Run everytime the working dir changes
chpwd() {
  in_git
  check_magic
}


# run before every shell line
precmd() {
  if [[ $IN_GIT_REPO == "true" ]] {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
      zstyle ':vcs_info:*' formats '<%b%F{3}%c%u%F{1}>'
    } else {
      # add circle for untracked files
      zstyle ':vcs_info:*' formats '<%b%F{3}%c%u%F{red}●%F{1}>'
    }

    export RPROMPT='%F{red}$(minutes_since_last_commit)m%f'
  } else {
    export RPROMPT=''
  }

  # this should be quick if not in a repo
  vcs_info
}

PROMPT=''
case $HOSTNAME in
  sagan)
    export PROMPT='%{$fg[red]%}${vcs_info_msg_0_} %{$fg[blue]%}%3c $%{%f%} '
  ;;
  *)
    # show username/hostname for all other hosts
    export PROMPT='%{$fg[green]%}%n@%m%f %{$fg[red]%}${vcs_info_msg_0_} %{$fg[blue]%}%3c $%{%f%} '
  ;;
esac

export RPROMPT=""
export PS2="%_ > "

######### Aliases #########

alias gpush="git add . && git commit -a -m 'quick commit' && git push"
alias g=git
# serves directory on localhost:8000
alias shs="python -m SimpleHTTPServer"
# simple smtp server on port 1025, outputs to stdout
alias sss="python -m smtpd -n -c DebuggingServer localhost:1025"
alias tmux="TERM=xterm-256color tmux"
# use macvim if avaliable
if [[ $HOST_OS == 'darwin' && -x `which mvim` ]] {
  alias vim="mvim -v"
  alias vi="mvim -v"
}
# vim crontab fix
alias crontab="VIM_CRONTAB=true crontab"
alias sl=ls # often screw this up
alias history='fc -l 1'
alias lsless='CLICOLOR_FORCE=true ls -al | less -r'

# Amazon AMI tools, etc
if [[ $HOSTNAME == 'sagan' ]] {
  export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.3-45758/jars"
  export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.5.2.5/jars"
}

######### Completion #########
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
#
autoload -U compinit
compinit -i
autoload -U bashcompinit
bashcompinit -i
zmodload -i zsh/complist

zstyle ':completion:*:*:*:*:*' menu select

#grouping
zstyle ':completion:*:descriptions' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:-command-' group-order commands aliases builtins functions suffix-aliases reserved-words jobs parameters

# case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# default list colors copy GNU ls colors above
export ZLSCOLORS="${LS_COLORS}"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# highlight process/job numbers red
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:*:*:jobs' list-colors '=(#b) #(%[0-9]#)*=0=01;31'

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# completion file-patterns
zstyle ':completion:*:*:perl:*' file-patterns '*.pl:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:python:*' file-patterns '*.py:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:coffee:*' file-patterns '*.coffee:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:node:*' file-patterns '*.js:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:ruby:*' file-patterns '*.rb:globbed-files *(-/):directories' '*:all-files'

# grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export ACK_COLOR_MATCH='green'
export ACK_PAGER='less -r'

#ledger
case $HOSTNAME in
  beaker)
    export LEDGER_FILE=~/Documents/ledger/main.ledger
    export SSL_CERT_FILE=/usr/local/etc/openssl/cacert.pem
  ;;
  *)
  ;;
esac
alias l="ledger"

# check if ec2 instance is ready
function ec2-check-ready() {
  test=1
  while [[ $test -gt 0 ]] ; do
    sleep 20
    ec2-get-console-output $1 | grep Meta &> /dev/null
    test=$?
  done
  growlnotify -m "console output ready $1" -s EC2
}

function genpass() {
  LC_ALL=C tr -dc 'A-Za-z0-9_?$%\\%!#+=-' < /dev/urandom | head -c $1; echo
}
function genpass2() {
  LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $1; echo
}

# Call in_git at shell start
in_git

export GPG_TTY=$(tty)

if [[ $HOSTOS == 'linux' ]]; then
  if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
  fi

  gpg-agent > /dev/null 2>&1
  if [[ $? != 0 ]]; then
    gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info" > /dev/null 2>&1
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
  fi
fi

# Google Calendar/Contacts stuff
function contacts
{
  google contacts list $1 --fields name,phone,email
}

function today
{
  google calendar list --date 'today' --fields when,title --delimiter '   '
}

function week
{
  today=$(date '+%a')
  case $today in
    Mon|Sun|Sat)
      first=$(date --date 'Monday' '+%Y-%m-%d')
      ;;
    *)
      first=$(date --date 'last Monday' '+%Y-%m-%d')
      ;;
  esac
  last=$(date --date 'friday' '+%Y-%m-%d')

  google calendar list --date "$first,$last" --fields when,title --delimiter '   '
}

## rbenv
if [[ -d "$HOME/.rbenv" ]]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$($HOME/.rbenv/bin/rbenv init -)"
fi

stty stop undef

# git completion fixes
__git_files () { 
  _wanted files expl 'local files' _files     
}

# reset
if [[ $TERM == 'rxvt-256color' ]]; then
  export TERM=xterm-256color
fi
