#!/usr/bin/env bash


tmux new-window -n 'ipy'


WINNUM=$(tmux display-message -p '#I')

tmux split-window -h -t 'ipy'
tmux select-pane -t ipy.0
tmux send-keys -t ipy.0 "vim -c \"set ft=python|let b:slime_config={'target_pane': ':ipy.1', 'socket_name': 'default'}\"" C-m
tmux select-pane -t ipy.1
tmux send-keys -t ipy.1 "ipython --no-confirm-exit --no-banner" C-m
tmux select-pane -t ipy.0
tmux send-keys -t ipy.0 ":r~/code/ipy.py" C-m

tmux select-window -t 'ipy'
