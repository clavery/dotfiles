
setlocal textwidth=100
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4 autoindent

"setlocal keywordprg=dash\ py

"nno <buffer> <silent> K :exe 'silent !open dash://py:'.expand("<cword>")<cr>

setlocal formatprg=yapf\ --style='{COLUMN_LIMIT:100}'

setlocal errorformat=%f:%l:\ %m
setlocal makeprg=pylint\ --reports=n\ --output-format=parseable
