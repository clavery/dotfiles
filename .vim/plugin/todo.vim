
if exists("g:loaded_todo") || &cp
  finish
endif
let g:loaded_todo = 1


function! todo#refile()
  if bufwinnr(bufnr("__REFILE__")) == -1
    botright 14split __OUT__
    execute "setlocal filetype=" . filetype
    execute "setlocal nonumber"
    execute "setlocal norelativenumber"
  else
    exe bufwinnr(bufnr("__REFILE__")) . "wincmd w"
  endif
endfunction
