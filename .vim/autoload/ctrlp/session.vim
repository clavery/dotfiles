
if ( exists('g:loaded_ctrlp_session') && g:loaded_ctrlp_session )
      \ || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_session = 1

let s:session_var = {
      \ 'init': 'ctrlp#session#init()',
      \ 'accept': 'ctrlp#session#accept',
      \ 'lname': 'session',
      \ 'sname': 'sess',
      \ 'type': 'line',
      \ 'sort': 0,
      \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:session_var)
else
  let g:ctrlp_ext_vars = [s:session_var]
endif

function! ctrlp#session#init()
  let type = 'cmd'
  let sessions = glob("~/.vim/sessions/*.vim", 0, 1)
  let cleaned = map(sessions, 'substitute(v:val,  "\.\\{-\\}\\([0-9A-Za-z_-]\\+\\)\.vim$", "\\1", "")')
  let list = filter(cleaned, '!empty(v:val)')
  return list
endfunction

func! ctrlp#session#accept(mode, str)
  call ctrlp#exit()
  wall
  execute "source " . expand('~/.vim/sessions/' . a:str . '.vim')
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#session#id()
  return s:id
endfunction
