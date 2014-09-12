
if ( exists('g:loaded_ctrlp_snippets') && g:loaded_ctrlp_snippets )
      \ || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_snippets = 1

let s:snippets_var = {
      \ 'init': 'ctrlp#snippets#init()',
      \ 'accept': 'ctrlp#snippets#accept',
      \ 'lname': 'snippets',
      \ 'sname': 'snip',
      \ 'type': 'tabe',
      \ 'sort': 0,
      \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:snippets_var)
else
  let g:ctrlp_ext_vars = [s:snippets_var]
endif

function! ctrlp#snippets#init()
  let snippets = UltiSnips#SnippetsInCurrentScope()
  py from UltiSnips import UltiSnips_Manager
  py rawsnips = UltiSnips_Manager._snips( '', 1 )
  py curline = vim.current.buffer.name
  py snippets = [ "{0} : {1}".format(x.trigger, x.description) for x in rawsnips ]
  py snippets = [curline]
  let result = pyeval('snippets')
  return result
endfunction

func! ctrlp#snippets#accept(mode, str)
  call ctrlp#exit()
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#snippets#id()
  return s:id
endfunction
