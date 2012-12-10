setlocal keywordprg=:help
setlocal makeprg=jshint\ %\\\|sed\ '/^$/d'\\\|sed\ '/^[0-9]\ /d'
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
inoremap <buffer> {<cr> {}<left><cr><space><space>.<cr><esc>kA<bs>
