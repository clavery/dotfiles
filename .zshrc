## .zshrc
## Charles Lavery
## charles.lavery@gmail.com

# System info
HOSTNAME=`hostname -s`
HOST_OS=`uname|tr '[:upper:]' '[:lower:]'`

stty stop undef

export HISTSIZE=1000
export EDITOR=vim

export PROMPT_EOL_MARK=''

######## Load Modules ########

autoload colors; colors;
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload -U add-zsh-hook

######## Options #########
unsetopt AUTO_CD
setopt interactivecomments
setopt ALWAYSLASTPROMPT
setopt APPENDHISTORY
setopt EQUALS
setopt EXTENDEDHISTORY
setopt FUNCTIONARGZERO
setopt HISTIGNOREDUPS
setopt HISTIGNORESPACE
setopt LONGLISTJOBS
setopt MULTIOS
setopt PRINTEIGHTBIT 
setopt RMSTARSILENT 
setopt SHORTLOOPS  
setopt CLOBBER
unsetopt CORRECT

# enable prompt substitution
setopt prompt_subst

# directory stack
unsetopt AUTO_NAME_DIRS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# use bash style backward kill word
autoload -U select-word-style
select-word-style bash

# emacs mode
bindkey -e

# better for gnu screen
bindkey "^B" backward-word
bindkey "^F" forward-word

# edit command line in vi with Ctrl-x Ctrl-e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

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
export LESS="--ignore-case -r"

# cross-platform color ls
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
export CLICOLORS=1
# bsd
export LSCOLORS=exfxcxdxbxegedabagacad
# gnu
export LS_COLORS="di=34:ex=31:no=00:or=90;43:ln=target:ow=00;46"

########## PATHS ##########

export PATH=~/bin:/usr/local/bin:/usr/local/sbin:$PATH

case $HOST_OS in
  darwin)
    export MANPATH=/usr/local/share/man:/Applications/Xcode.app/Contents/Developer/usr/share/man:$MANPATH
    export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
  ;;
  linux)
    export JAVA_HOME="/usr/java"
  ;;
esac

######### Functions #########

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' stagedstr '%F{green}●%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●%f'
zstyle ':vcs_info:*' actionformats '<%b%F{3}%c%u%F{1}> %F{003}%a '
zstyle ':vcs_info:*' formats '<%b%F{3}%c%u%F{1}> '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r%f%F{1}'

cmd_exec_time() {
    local stop=$(date +%s)
    local start=${cmd_timestamp:-$stop}
    integer elapsed=$stop-$start
    (($elapsed > 5)) && print -P '%F{yellow}${elapsed}s%f'
}

# are we in a git repo? helper function
# git branch is fast
in_git() {
  git branch > /dev/null 2>&1
  if [[ $? == 0 ]] {
    IN_GIT_REPO=1
  } else {
    IN_GIT_REPO=0
  }
}

preexec() {
  cmd_timestamp=$(date +%s)
}

# Call in_git at shell start
in_git

# Run everytime the working dir changes
chpwd() {
  in_git
}

precmd() {
  if [[ $IN_GIT_REPO == 1 ]] {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
      zstyle ':vcs_info:*' formats '<%b%F{3}%c%u%F{1}> '
    } else {
      # add circle for untracked files
      zstyle ':vcs_info:*' formats '<%b%F{3}%c%u%F{red}●%F{1}> '
    }
  }
  if [[ $VIRTUAL_ENV:t == "default" ]] {
    _VENV="⭑ "
  } elif [[ -n "$VIRTUAL_ENV" ]] {
    _VENV="${VIRTUAL_ENV:t} "
  } else {
    _VENV=""
  }
  vcs_info
  cmd_exec_time
  unset cmd_timestamp
}

list_colors() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}test%f"
  done
}

PROMPT=''
case $HOSTNAME in
  meeples|beast|dasbook|gamma)
    #export PROMPT='%F{005}${_VENV}%F{red}${vcs_info_msg_0_}%F{blue}%3c %(?.%F{blue}.%F{red})$%f '
    export PROMPT='%F{red}${vcs_info_msg_0_}%F{blue}%3c %(?.%F{blue}.%F{red})$%f '
  ;;
  *)
    # show username/hostname for all other hosts
    export PROMPT='%{$fg[green]%}%n@%m%f %{$fg[red]%}${vcs_info_msg_0_} %{$fg[blue]%}%3c $%{%f%} '
  ;;
esac

export RPROMPT=""
export PS2="%_ > "

######### Aliases #########

alias g=git
alias gpush="git add . && git commit -a -m 'quick commit' && git push"
alias git-not-mod='git ls-files -mo | xargs -n1 echo -not -path | xargs find *'

alias tmux="tmux -2 -u"
alias attach="tmux -2 -u attach"
alias ag="ag --pager less"

# vim crontab fix
alias crontab="VIM_CRONTAB=true crontab"

alias history='fc -l 1'
alias dirs='dirs -vp'

# use macvim if avaliable
if [[ -x `which mvim` ]] {
  alias vim="mvim -v"
  alias vi="mvim -v"
  export EDITOR="mvim -v"
}

if [[ $HOST_OS == 'linux' ]] {
  alias vi=vim
}

######### Completion #########
unsetopt flowcontrol
# show completion menu on succesive tab press
setopt auto_menu
setopt complete_in_word
setopt always_to_end

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

# Quick password generation functions
function genpass() {
  LC_ALL=C tr -dc 'A-Za-z0-9_?$%\\%!#+=-' < /dev/urandom | head -c $1; echo
}
function genpass2() {
  LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $1; echo
}

# GPG-agent for linux only (use MacGPG on OSX)
export GPG_TTY=$(tty)

if [[ $HOST_OS == 'linux' ]]; then
  if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
  fi

  gpg-agent > /dev/null 2>&1
  if [[ $? != 0 ]]; then
    gpg-agent --enable-ssh-support --daemon --write-env-file "${HOME}/.gpg-agent-info" > /dev/null 2>&1
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
  fi
fi

# git completion fixes
__git_files () { 
  _wanted files expl 'local files' _files     
}

# debian development
export DEBFULLNAME="Charles Lavery"
export DEBEMAIL="charles.lavery@gmail.com"

#### Python ####
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WORKON_HOME=$HOME/.venv
if [ -f /usr/bin/virtualenvwrapper.sh ]
then
  . /usr/bin/virtualenvwrapper.sh

  if [ -d /Users/chuck/.venv/default ]
  then
    workon default
  fi
  if [ -d /Users/clavery/.venv/default ]
  then
    workon default
  fi
fi
if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
  . /usr/local/bin/virtualenvwrapper.sh

  if [ -d /Users/chuck/.venv/default ]
  then
    workon default
  fi
  if [ -d /Users/clavery/.venv/default ]
  then
    workon default
  fi
fi
# serves directory on localhost:8000
alias shs="python -m SimpleHTTPServer"
# simple smtp server on port 1025, outputs to stdout
alias sss="python -m smtpd -n -c DebuggingServer localhost:1025"
export PYTHONDONTWRITEBYTECODE=1
case $HOST_OS in
  darwin)
    export CFLAGS=-Qunused-arguments
    export CPPFLAGS=-Qunused-arguments
  ;;
esac

#### ruby ####
if [ -d /usr/local/opt/ruby/bin ]
then
  export PATH=$PATH:/usr/local/opt/ruby/bin
fi

#### postgres ####
if [ -d /Applications/Postgres93.app/Contents/MacOS/bin ]
then
  export PATH=$PATH:/Applications/Postgres93.app/Contents/MacOS/bin
fi


#### golang ####
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=${HOME}/code/go
if [ -f /usr/local/share/zsh/site-functions/go ]
then
  source /usr/local/share/zsh/site-functions/go
fi

#### ledger ####
case $HOSTNAME in
  dasbook)
    export LEDGER_FILE=~/Documents/ledger/main.ledger
    export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
    export LEDGER_PRICE_DB=~/Documents/ledger/prices.db
  ;;
  *)
  ;;
esac
alias l="ledger"


#marks
export MARKPATH=$HOME/.marks
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
    rm "$MARKPATH/$1"
}
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}
function _completemarks {
  reply=($(ls $MARKPATH))
}

compctl -K _completemarks jump
compctl -K _completemarks unmark

# ec2
function ec2_waitforinstance() {
 aws ec2 get-console-output --instance-id $1 --output text | grep -i ready
 while [ $? != "0" ]; do
   sleep 10
   aws ec2 get-console-output --instance-id $1 --output text | grep -i ready
 done 
 terminal-notifier -message "$1 is ready" -activate com.apple.Terminal
}

# fzf
export FZF_DEFAULT_COMMAND="ag -l --hidden -g '' --ignore .git"
source ~/.fzf.zsh
