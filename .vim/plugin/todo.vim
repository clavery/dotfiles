
if exists("g:loaded_todo") || &cp
  finish
endif
let g:loaded_todo = 1


function! todo#journal()
  let folder=strftime("%Y-%m")

  if exists("g:todo_journal_base")
    let folder=expand(g:todo_journal_base) . "/" . folder
  endif

  let fname=strftime("%Y-%m-%d-%a") . ".md"
  let filename=folder . "/" . fname
  let header=strftime("# %A, %B %d, %Y")

  if !isdirectory("" . folder)
    call mkdir("".folder, "p")
  endif

  if filereadable("" . filename)
    exec "edit " . filename
  else
    exec "edit " . filename
    call append(line('$'), [header, "", ""])
    norm ggddG
  endif
endfunction

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


command! Journal call todo#journal()
