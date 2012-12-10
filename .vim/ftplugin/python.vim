autocmd InsertLeave * if pumvisible() == 0|pclose|endif
let g:pydoc_open_cmd = 'vsplit'
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4 autoindent
let g:pymode_lint_write = 0
let g:pymode_folding = 0
