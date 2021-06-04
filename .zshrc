## .zshrc
## Charles Lavery
## charles.lavery@gmail.com

# System info
HOSTNAME=`hostname -s`
HOST_OS=`uname|tr '[:upper:]' '[:lower:]'`

if [ -f ~/.vars ]; then
  source ~/.vars
fi

stty stop undef

export HISTSIZE=1000
export EDITOR=vim
export BROWSER=open
export TERM=screen-256color

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
export LESS="--ignore-case -r -X -F"

# cross-platform color ls
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || true
export CLICOLOR=1
# bsd
export LSCOLORS=exfxcxdxbxegedabagacad
# gnu
export LS_COLORS="di=34:ex=31:no=00:or=90;43:ln=target:ow=00;46"

alias ll="ls -Alhtr"

########## PATHS ##########

fpath=($HOME/dotfiles/.completions/src/ $fpath)

export PATH=~/.local/bin:~/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=/Library/TeX/texbin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH

function setjdk() {
  if [ $# -ne 0 ]; then
    removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
    if [ -n "${JAVA_HOME+x}" ]; then
      removeFromPath $JAVA_HOME
    fi
    export JAVA_HOME=`/usr/libexec/java_home -v $@`
    export PATH=$JAVA_HOME/bin:$PATH
  fi
}
function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

case $HOST_OS in
  darwin)
    export MANPATH=/usr/local/share/man:/Applications/Xcode.app/Contents/Developer/usr/share/man:$MANPATH
    # setjdk 8
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/
    export PATH=${JAVA_HOME}bin:$PATH
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
    (($elapsed > 5)) && print -P '%F{yellow}${elapsed}s%f' && print -n "\a"
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
    # • ○ ± ☿ ⭑  ☉
    _VENV="○"
  } elif [[ -n "$VIRTUAL_ENV" ]] {
    _V=$(dirname $VIRTUAL_ENV)
    _VENV="${_V:t} "
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
case $HOST_OS in
  darwin)
    export PROMPT='%F{red}${vcs_info_msg_0_}%F{blue}%3c %(?.%F{blue}.%F{red})$%f '
    export RPROMPT='%F{237}${_VENV}%f'
    #export RPROMPT=""
    #export PROMPT='%F{red}${vcs_info_msg_0_}%F{blue}%3c %(?.%F{blue}.%F{red})$%f '
  ;;
  *)
    # show username/hostname for all other hosts
    export RPROMPT=""
    export PROMPT='%{$fg[green]%}%n@%m%f %{$fg[red]%}${vcs_info_msg_0_} %{$fg[blue]%}%3c $%{%f%} '
  ;;
esac

export PS2="%_ > "

######### Aliases #########

alias g=git
alias gtop='cd $(git rev-parse --show-toplevel)'
alias git-not-mod='git ls-files -mo | xargs -n1 echo -not -path | xargs find *'

alias tmux="tmux -2 -u"
alias attach="tmux -2 -u attach"
alias ag="ag --pager less"

alias ltail="less -Ri +F"

# vim crontab fix
alias crontab="VIM_CRONTAB=true crontab"

alias history='fc -l 1'
alias dirs='dirs -vp | sort -nr'

# don't send screen...
alias ssh='TERM=xterm-256color ssh'

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
autoload -U zmv

zstyle ':completion:*:*:*:*:*' menu select

#grouping
zstyle ':completion:*:descriptions' format ''
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
[ -r ~/.ssh/config ] && _ssh_config=($(cat ~/.ssh/config | grep -e 'Host ' | sed 's/Host //' | paste -sd " " -)) || _ssh_config=()
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_config[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

zstyle ':completion:*' verbose yes

# completion file-patterns
zstyle ':completion:*:*:perl:*' file-patterns '*.pl:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:python:*' file-patterns '*.py:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:coffee:*' file-patterns '*.coffee:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:node:*' file-patterns '*.js:globbed-files *(-/):directories' '*:all-files'
zstyle ':completion:*:*:ruby:*' file-patterns '*.rb:globbed-files *(-/):directories' '*:all-files'

# grep
export GREP_COLOR='1;32'

# Quick password generation functions
function genpass() {
  LC_ALL=C tr -dc 'A-Za-z0-9_?$%\\%!#+=-' < /dev/urandom | head -c $1; echo
}
function genpass2() {
  LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $1; echo
}
function genpass3() {
  echo -n "$(LC_ALL=C tr -dc 'a-z' < /dev/urandom | head -c 5) "
  echo -n "$(LC_ALL=C tr -dc 'a-z' < /dev/urandom | head -c 5) "
  echo -n "$(LC_ALL=C tr -dc 'a-z' < /dev/urandom | head -c 5) "
  LC_ALL=C tr -dc 'a-z' < /dev/urandom | head -c 5; echo
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
    if [ -f "${HOME}/.gpg-agent-info" ]; then
      . "${HOME}/.gpg-agent-info"
    fi
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

function venv {
  if [ -n "$1" ]; then
    . $HOME/.venv/$1/bin/activate
    return
  fi
  if [ -f env/bin/activate ]; then
    . env/bin/activate
  else
    echo "No venv found"
  fi
}


# serves directory on localhost:8000
alias shs="python -m SimpleHTTPServer"
# simple smtp server on port 1025, outputs to stdout
alias sss="python -m smtpd -n -c DebuggingServer localhost:1025"
export PYTHONDONTWRITEBYTECODE=1
export PYTHONIOENCODING='utf8:ignore'
case $HOST_OS in
  darwin)
    export CFLAGS=-Qunused-arguments
    export CPPFLAGS=-Qunused-arguments
  ;;
esac

#### ledger ####
case $HOSTNAME in
  dasbook)
    export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
    export LEDGER_FILE=/Volumes/Chucks/ledger/main.ledger
    export LEDGER_PRICE_DB=/Volumes/Chucks/ledger/prices.db
  ;;
  chucks)
    export LEDGER_FILE=/Volumes/Chucks/ledger/main.ledger
    export LEDGER_PRICE_DB=/Volumes/Chucks/ledger/prices.db
  ;;
  *)
  ;;
esac
function l {
  if [ $# -gt 0 ] && [ -f "scripts/$1" ]; then
    script=$1
    shift
    scripts/$script "$@"
  else
    ledger $@
  fi
}
function _completeledger {
  reply=("emergency" "cash_on_hand" "savings_rate" "balance" "register" "accounts" "updateprices")
}
compctl -K _completeledger l


#marks
export MARKPATH=$HOME/.marks
function jump { 
  if [ "$1" = "" ]; then
    return
  fi
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
alias j=jump
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function markprint {
    readlink "$MARKPATH/$1"
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
compctl -K _completemarks markprint
compctl -K _completemarks unmark

#templates
export _TEMPLATE_PATH=$HOME/code/templates
alias template="${_TEMPLATE_PATH}/template"
function _completetemplate {
  reply=($(find $_TEMPLATE_PATH -type d -depth 1 -not -name ".git" -exec basename {} \;))
}
compctl -K _completetemplate template

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
if [ -x /usr/local/bin/fzf ]; then
  source ~/.fzf.zsh
fi

function fkill {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

alias uuid4="python -c 'import uuid; import sys; print(str(uuid.uuid4()))'"

function vault {
  aws-vault exec default -- $@
}
function cs {
  echo -n $(vault dwre cred get $(vault dwre cred list | fzf)) | tee >(pbcopy)
}
function aws {
  (
  AWS_PROFILE="${AWS_PROFILE:-default}"
  aws-vault exec "$AWS_PROFILE" -- command aws "$@"
  )
}

# example from man pages
eg() {
  MAN_KEEP_FORMATTING=1 man "$@" 2>/dev/null \
    | gsed --quiet --expression='/^E\(\x08.\)X\(\x08.\)\?A\(\x08.\)\?M\(\x08.\)\?P\(\x08.\)\?L\(\x08.\)\?E/{:a;p;n;/^[^ ]/q;ba}' \
    | ${MANPAGER:-${PAGER:-pager -s}}
}

alias iso8601="echo $(date +\"%Y%m%dT%H%M%S\")"

function todo {
  if [ -d ~/Nextcloud/Todo ]; then
    cd ~/Nextcloud/Todo && mvim personal.txt;
  fi
  if [ -d ~/Documents/todo ]; then
    cd ~/Documents/todo && mvim work.md;
  fi
  cd -
}

function gist {
  pbpaste | command gist -p -f $1 -d "$(echo ${@:2})" | tee >(pbcopy) | cat
}

function review() {
  if [ -d "../branches/$1" ]; then
    cd "../branches/$1";
    return;
  fi

  git branch $1 origin/$1
  git worktree add "../branches/$1" $1
  cd "../branches/$1";
  if [ -f "$OLDPWD/.custignore" ]; then
    cp "$OLDPWD/.custignore" .
  fi
  if [ -f "$OLDPWD/.custignore" ]; then
    cp "$OLDPWD/.agignore" .
  fi
  print -S "yarn install && dwre sync -d && yarn start"
}
function _completereview {
  reply=($(git branch -r | grep origin | sed 's/origin\///'))
}
compctl -K _completereview review


# usage = `any gulp` to search for running procs
function any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

function defi() {
  if [[ $# -ge 2 ]] then
    echo "defi: too many arguments" >&2
    return 1
  else
    curl "dict://dict.org/d:$1" | less
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -f "$NVM_DIR/nvm.sh" ] && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -f "$NVM_DIR/bash_completion" ] && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# support encrypted netrc

# git management
git_create_repo() {
  curl -q ${GIT_URL}/api/v1/user/repos -XPOST --data "name=$1&private=true" 2>/dev/null | jq -r .ssh_url | xargs echo "git remote add origin" | tee /dev/tty | print -S
}
git_create_repo_org() {
  curl -q ${GIT_URL}/api/v1/org/$1/repos -XPOST --data "name=$2&private=true" 2>/dev/null | jq -r .ssh_url | xargs echo "git remote add origin" | tee /dev/tty | print -S
}

# fix high sierra bullshit
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

export GOPATH=$HOME/code/go

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/charleslavery/code/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/charleslavery/code/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/charleslavery/code/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/charleslavery/code/google-cloud-sdk/completion.zsh.inc'; fi


# plugins
if [ -f '~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' ]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi


_pwdstore-files() {
  find $HOME/.password-store -type f \
    | sed 's/.*\(\.password-store\/.*\)/\1/' \
    | grep -v '/\.' \
    | cut -d / -f2- \
    | rev \
    | cut -d . -f2- \
    | rev
}

# pass copy
pw() {
  local files pwdstore_file
  files=$(_pwdstore-files)
  pwdstore_file=$(echo $files | fzf)
  pass -c "$(echo "$pwdstore_file")"
}

# pass copy
totp() {
  local files pwdstore_file
  files=$(_pwdstore-files)
  pwdstore_file=$(echo $files | fzf)
  pass otp "$(echo "$pwdstore_file")"
}

# pass show
pd() {
  local files pwdstore_file
  files=$(_pwdstore-files)
  pwdstore_file=$(echo $files | fzf)
  pass show "$(echo "$pwdstore_file")"
}

# pass edit
pe() {
  local files pwdstore_file
  files=$(_pwdstore-files)
  pwdstore_file=$(echo $files | fzf)
  pass edit "$(echo "$pwdstore_file")"
}

passpush() {
  pushd ~/.password-store
  git push
  popd
}

# single commit to the current branch then cherry pick to the given
# maintenance branch, tag, push and trigger a build
# $1 = version to hotfix (i.e. 1.9.2 will cherry pick to 1.9.x branch)
# $2 commit message
hotfix() {
  git commit -am $2
  _hash=$(git log --format="%H" -n 1)
  major=$(echo $1 | cut -d. -f1)
  minor=$(echo $1 | cut -d. -f2)
  patch=$(echo $1 | cut -d. -f2)
  pushd "../$major.$minor.x"
  git cherry-pick $_hash
  git tag $1
  git push --follow-tags
  popd
}
export ANDROID_HOME=/Users/charleslavery/Library/Android/sdk/
