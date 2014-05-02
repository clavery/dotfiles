
" simple auto braces
inoremap <buffer> {<cr> {}<left><cr><space><space>.<cr><esc>kA<bs>

" Function text object (does not wor correctly  in visual mode)
onoremap if :<c-u>execute "normal! $?function\r:nohl\rf{v%"<cr>
onoremap af :<c-u>execute "normal! $?function\r:nohl\rvf{%"<cr>

let g:used_javascript_libs = 'underscore,angularjs,jquery'

