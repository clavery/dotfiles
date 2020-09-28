
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

function! todo#allTags()
  exec "Rg " . shellescape("\\[T_") . "~/Nextcloud/todo/**/*<CR>:cw<CR>"
endfunction
noremap <Leader>ta :call todo#allTags()<cr>

function! todo#openJiraTicket()
  let currentWord = expand("<cWORD>")
  if match(currentWord, '\v\w\w\w-\d{1,4}') != -1
    let ticket = substitute(currentWord, '\v.*(\w\w\w-\d{1,4}).*', '\1', "g")
    exec "!open https://ross-simons.atlassian.net/browse/" . ticket
  endif
endfunction
noremap <Leader>to :call todo#openJiraTicket()<cr>


function! todo#ToggleCB() range

  for lineno in range(a:firstline, a:lastline)
    let line = getline(lineno)

    if(match(line, "\\[ \\]") != -1)
      let line = substitute(line, "\\[ \\]", "[✓]", "")
    elseif(match(line, "\\[✓\\]") != -1)
      let line = substitute(line, "\\[✓\\]", "[ ]", "")
    else
      let line = substitute(line, "^\\(\\s*\\(-\\|\\*\\)\\)\\s", "\\1 [ ] ", "")
    endif

    call setline(lineno, line)
  endfor
endfunction
command! -range ToggleCB <line1>,<line2>call todo#ToggleCB()
vnoremap <silent> <leader>tt :ToggleCB<cr>
nnoremap <silent> <leader>tt :ToggleCB<cr>

command! Journal call todo#journal()
