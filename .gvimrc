if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
endif
set t_vb=
set guioptions+=c
set guioptions-=m
set guioptions-=e

highlight TabLineFill guifg=#293739 guibg=#ffffff
highlight TabLine guibg=#232526 gui=None
highlight TabLineSel guifg=#ef5939
highlight Cursor guibg=#FFFF00

function! TitleLabel()
  if !empty(v:this_session)
    return '['.ctrlp#session#name_from_file(v:this_session).']'
  else
    return fnamemodify(getcwd(), ":~:s?/code/?/c/?")
  endif
endfunction
set title
set titlestring=%{TitleLabel()}
