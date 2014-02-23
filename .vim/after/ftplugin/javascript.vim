
setlocal keywordprg=:help
setlocal makeprg=jshint\ %\\\|sed\ '/^$/d'\\\|sed\ '/^[0-9]\ /d'
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m

" simple auto braces
inoremap <buffer> {<cr> {}<left><cr><space><space>.<cr><esc>kA<bs>

" Function text object (does not wor correctly  in visual mode)
onoremap if :<c-u>execute "normal! $?function\r:nohl\rf{v%"<cr>
onoremap af :<c-u>execute "normal! $?function\r:nohl\rvf{%"<cr>

setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2 autoindent

let g:used_javascript_libs = 'underscore,angularjs,jquery'

