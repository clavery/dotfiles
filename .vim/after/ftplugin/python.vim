
setlocal textwidth=100
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4 autoindent

"setlocal keywordprg=dash\ py

nno <buffer> <silent> K :exe 'silent !open dash://py:'.expand("<cword>")<cr>
