
setlocal textwidth=100
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4 autoindent

"setlocal keywordprg=dash\ py

"nno <buffer> <silent> K :exe 'silent !open dash://py:'.expand("<cword>")<cr>

setlocal formatprg=yapf\ --style='{COLUMN_LIMIT:100}'
let b:runner_command = 'python'
setlocal errorformat=%f:%l:%c:\ %t%n\ %m
setlocal makeprg=flake8
