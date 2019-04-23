if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  macmenu &File.Print key=<Nop>
  map <D-p> <C-P>
endif

set t_vb=
set guioptions+=c
set guioptions-=m
set guioptions-=e

function! TitleLabel()
  if !empty(v:this_session)
    return '['.ctrlp#session#name_from_file(v:this_session).']'
  else
    return fnamemodify(getcwd(), ":~:s?/code/?/c/?")
  endif
endfunction
set title
set titlestring=%{TitleLabel()}
