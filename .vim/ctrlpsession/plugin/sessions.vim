if exists("g:loaded_session_autosave") || v:version < 700 || &cp
  finish
endif
let g:loaded_session_autosave = 1

function! s:persist()
  if exists('v:this_session') && !empty(v:this_session) && !g:sourcing_session
    try
      execute 'mksession! '.fnameescape(v:this_session)
    catch
      return 'echoerr '.string(v:exception)
    endtry
  endif
  return ''
endfunction

augroup session_autosave
  autocmd!
  autocmd BufEnter,VimLeavePre * exe s:persist()
augroup END

