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
