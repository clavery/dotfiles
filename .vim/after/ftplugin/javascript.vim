let b:runner_command = 'node'
let b:runner_ft = 'text'

" Function text object (does not wor correctly  in visual mode)
onoremap if :<c-u>execute "normal! $?function\r:nohl\rf{v%"<cr>
onoremap af :<c-u>execute "normal! $?function\r:nohl\rvf{%"<cr>

let g:used_javascript_libs = 'underscore,angularjs,jquery'

vnoremap <buffer> <silent> <leader>s :Runner<cr>
nnoremap <buffer> <silent> <leader>s :Runner<cr>

nnoremap <buffer> <leader>td :TernDoc<cr>
nnoremap <buffer> <leader>tp :TernDefPreview<cr>
nnoremap <buffer> <leader>tg :TernDef<cr>

nno <buffer> <silent> K :exe 'silent !open dash://js:'.expand("<cword>")<cr>
