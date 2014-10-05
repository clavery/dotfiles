setlocal ts=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal conceallevel=2

setlocal formatoptions+=t
"setlocal formatoptions+=a

setlocal textwidth=80
setlocal suffixesadd=.md,.rst,.txt

fu! markdown#ToggleCB() range

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
endf

command! -range ToggleCB <line1>,<line2>call markdown#ToggleCB()

vnoremap <silent> <buffer> <leader>t :ToggleCB<cr>
nnoremap <silent> <buffer> <leader>t :ToggleCB<cr>

