setlocal keywordprg=:help
setlocal makeprg=jshint\ %\\\|sed\ '/^$/d'\\\|sed\ '/^[0-9]\ /d'
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
inoremap <buffer> {<cr> {}<left><cr><space><space>.<cr><esc>kA<bs>

onoremap if :<c-u>execute "normal! $?function\r:nohl\rf{v%"<cr>
onoremap af :<c-u>execute "normal! $?function\r:nohl\rvf{%"<cr>
