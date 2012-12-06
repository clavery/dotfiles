#!/usr/bin/env sh

HOSTNAME=`hostname -s`
HOST_OS=`uname|tr '[:upper:]' '[:lower:]'`

find .* -maxdepth 0 -not \( -name '.' -or -name '..' -or -name '.git' -or -name '.gitmodules' \) -print -exec ln -fs $(pwd)/{} $HOME \;

case $HOST_OS in
  darwin)
    rm -f $HOME/.tmux-linux.conf
  ;;
  linux)
    rm -f $HOME/.tmux-osx.conf
    rm -f $HOME/.osx
  ;;
esac
