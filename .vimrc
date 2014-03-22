" .vimrc
" Charles Lavery

filetype off

call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on
syntax on

set nocompatible
set t_Co=256

let mapleader = "\<Space>"

" Vim Settings {{{

" allow backspacing over everything in insert mode
set noshowmode
set encoding=utf-8
set fileencodings=utf-8,latin1,default
set autoread
set lazyredraw
set backspace=indent,eol,start
set notimeout
set ttimeout
set ttimeoutlen=10
set nojoinspaces
set backup
set backupdir=~/.backup//
set directory=~/.swp//
set viewdir=~/.views//
set history=1000
set ruler
set showcmd
set incsearch
set scrolloff=4
set synmaxcol=500
set nohlsearch
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set number
set relativenumber
set numberwidth=3
set hidden
set showmatch
set matchtime=2 " show paren matches quickly
set shortmess=lmnrxoOItTA
set ignorecase
set smartcase
set ttyfast
set gdefault " change behavior of /g option
set linebreak " break on word
set formatoptions+=c
set formatoptions+=q
set textwidth=0
set wildmenu
set wildmode=list:longest
set smartindent
set laststatus=2
set foldlevelstart=0
set splitbelow
set splitright
set nobackup
set nowritebackup
set noswapfile
set listchars=tab:▸\ ,trail:•,nbsp:␣,extends:…,precedes:…
set nrformats=
set esckeys
set diffopt=filler,iwhite
set foldlevelstart=99
set completeopt=menuone,longest

if version >= 703
  set cryptmethod=blowfish
endif

" Turn off sounds
set noerrorbells
set visualbell
set t_vb=

" Ignored folders
if has("Win32")
  set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*\\_svn\\*,*\\build\\*,*\\lib\\*
else
  set wildignore+=*/WEB-INF/*
  set wildignore+=*/venv/*
  set wildignore+=*/node_modules/*
  set wildignore+=*/bower_components/*
  set wildignore+=*/.svn/*
  set wildignore+=*/.sass-cache/*
  set wildignore+=*.min.js
  set wildignore+=*.pyc
  set wildignore+=*/tmp/*
endif

" disable mouse
if has('mouse')
  set mouse=
endif

" fix crontab -e
if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif
au BufEnter /private/tmp/crontab.* setl backupcopy=yes

if version >= 703
  set undodir=~/.undo
  if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
  endif
  set undofile
endif

if has("gui_running")
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  set guioptions-=R
  set guioptions-=r
  set mouse+=a
endif

augroup vimrcEx
  au!
  " jump to last position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Resize splits on window resize
  au VimResized * exe "normal! \<c-w>="
augroup END
if &diff
else
  augroup autosave
    au!
    " autosave
    au FocusLost * nested :silent! wa
  augroup END
endif


" }}}

" Mappings {{{

" reload .vimrc
map <leader>r :source $MYVIMRC<cr>

" toggle spell check
map <leader>s :setlocal spell!<cr>

" Ctrl-move for Window Movement
nmap <silent> <C-Up> :wincmd k<cr>
nmap <silent> <C-Down> :wincmd j<cr>
nmap <silent> <C-Left> :wincmd h<cr>
nmap <silent> <C-Right> :wincmd l<cr>
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <right> :silent vertical resize +5<cr>
nnoremap <left> :silent vertical resize -5<cr>
nnoremap <up> :silent resize +5<cr>
nnoremap <down> :silent resize -5<cr>

set pastetoggle=<F2>

nnoremap <F4> :silent make <cr>

" quickfix next previous shortcut
noremap <silent> <leader>n :cn<cr>
noremap <silent> <leader>m :cp<cr>

" Capitals save/quit too
command! W :w
command! Q :q
command! Wq :wq
command! WQ :wq

" open external programs easier
command! -nargs=1 Silent
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

cnoremap w!! w !sudo tee % >/dev/null

nnoremap <leader>/ :set hlsearch!<cr>
nnoremap <leader>l :set list!<cr>
nnoremap <leader>w :set wrap!<cr>

nnoremap <leader>` "=strftime("%a %d %b %Y %X")<cr>P

nnoremap <c-w><right> :vertical res -10<cr>
nnoremap <c-w><left> :vertical res +10<cr>
nnoremap <c-w><up> :res +5<cr>
nnoremap <c-w><down> :res -5<cr>

" }}}

" Highlighting {{{

colorscheme molokai

command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

if has("linux")
  set guifont=DejaVu\ Sans\ Mono\ 13
endif
if has("mac")
  set guifont=Source\ Code\ Pro\ Medium:h15
endif
if has("win32")
  set guifont=Consolas:h13:cANSI
endif

augroup statusLines
  au!
  au InsertEnter * hi StatusLine term=reverse ctermbg=0 ctermfg=DarkGreen guibg=#A8FF60 guifg=#202020
  au InsertLeave,BufLeave,BufEnter * hi StatusLine guifg=#CCCCCC guibg=#404040 gui=NONE ctermfg=white ctermbg=8 cterm=NONE
  au BufNew,BufAdd,BufWrite,BufNewFile,BufRead,BufEnter,FileChangedRO * :if &ro | hi StatusLine guibg=#CD321D ctermbg=red | endif
augroup END

hi StatusLine guifg=#CCCCCC guibg=#404040 gui=NONE ctermfg=white ctermbg=8 cterm=NONE
hi StatusLineNC guifg=#606060
hi Search ctermbg=55

if has("gui")
  highlight SignColumn guibg=#232526 guifg=#ffffff
  highlight SpecialKey guifg=red
  highlight Normal guibg=#303030

  hi LineNr guifg=#999999 guibg=#555555
  hi Visual guibg=#b3d4fc guifg=#000000 ctermbg=240
  " hot pink
  hi Search guibg=#fe57a1 guifg=#000000
  hi IncSearch guifg=#fe57a1 guibg=#000000
endif

highlight PmenuSel ctermbg=16 ctermfg=13
set pumheight=8

" highlight VCS markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set fillchars=vert:\ ,diff:-
high VertSplit guibg=#555555

hi DiffAdd         guifg=#A6E22E guibg=NONE ctermbg=NONE ctermfg=2
hi DiffChange      guifg=#89807D guibg=NONE gui=italic,bold ctermbg=NONE ctermfg=4
hi DiffDelete      guifg=#465457 guibg=NONE ctermbg=NONE ctermfg=1
hi DiffText        guifg=#66D9EF guibg=NONE gui=italic,bold cterm=bold ctermfg=5 ctermbg=NONE
if &diff
  set scrollbind

  nmap dh :diffget //2<CR>
  nmap dl :diffget //3<CR>
  nmap du :diffup<CR>

  set foldlevel=99
  set norelativenumber
  syntax off
  hi Normal ctermfg=240 guibg=#888888
endif


" }}}

" Status Line {{{

set statusline=%f    " Path.
set statusline+=%m   " Modified flag
set statusline+=%r   " Readonly flag.
set statusline+=%w   " Preview window flag.
set statusline+=%h   " Preview window flag.
set statusline+=\    " Space.
set statusline+=%=   " Right align.
" File format, encoding and type.  Ex: "(unix/utf-8/python)"
set statusline+=(
set statusline+=%{&ff}                        " Format (unix/DOS).
set statusline+=/
set statusline+=%{strlen(&fenc)?&fenc:&enc}   " Encoding (utf-8).
set statusline+=/
set statusline+=%{&ft}                        " Type (python).
set statusline+=)
" Line and column position and counts.
set statusline+=\ (%l\/%L,\ %03c,\ %03b)

" }}}

" Folding {{{

nnoremap <Space> za
vnoremap <Space> za

function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()

" }}}

" Gundo {{{

nmap <silent> <leader>u :GundoToggle<cr>

" }}}

" Ultisnips {{{
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsExpandTrigger="<c-j>"
" }}}

" vitality {{{
let g:vitality_fix_focus = 0
" }}}

" matchit {{{
runtime macros/matchit.vim
" }}}

" netrw {{{
let g:explHideFiles='^\.,.*\.pyc$'
"let g:netrw_browsex_viewer=
let g:netrw_liststyle=3
let g:netrw_banner=0
" }}}

" File types overrides {{{
augroup filetypes
  au!

  au BufRead *.md setlocal ft=markdown
  au BufRead *.ledger setlocal filetype=ledger
  au BufRead *.txt setlocal filetype=text
  au BufRead,BufNewFile *.scss set filetype=scss

  au BufRead *.aes setlocal noundofile
  au BufRead *.aes setlocal nobackup
  au BufRead *.aes setlocal viminfo=
  au BufRead *.secure setlocal noundofile
  au BufRead *.secure setlocal nobackup
  au BufRead *.secure setlocal viminfo=

  au Filetype qf setlocal nolist nowrap
augroup END
" }}}

" Quickfix Window {{{
nnoremap <leader>o :call QuickfixToggle()<cr>
let g:quickfix_is_open = 0

function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
" }}}

" Omnicomplettion

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType rst setlocal suffixesadd=.rst
autocmd FileType org setlocal suffixesadd=.rst,.org

" Filetypes {{{

"Jinja2
au BufRead *.j2 set ft=jinja

" }}}

" CTRLP {{{

let g:ctrlp_map = '<c-p>'
nnoremap <C-e> :CtrlPBuffer<cr>
" just use CWD
let g:ctrlp_working_path_mode = ''
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_match_window = 'bottom,btt,min:1,max:16'

" }}}

" You Complete Me {{{

let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']

" }}} "

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

let g:riv_global_leader="<c-z>"

"emacs begin/end
inoremap <c-a> <Home>
inoremap <c-e> <End>

" allows incsearch highlighting for range commands
cnoremap $t <CR>:t''<CR>
cnoremap <C-t> <CR>:t''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap <C-j> <CR>:m''<CR>
cnoremap $d <CR>:d<CR>``

"" Python
let g:pydoc_open_cmd = 'vsplit'
let g:pymode_warnings = 1
let g:pymode_lint_write = 0
let g:pymode_lint_on_write = 0
let g:pymode_folding = 0
let g:pymode_indent = 1
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_syntax_slow_sync = 0
let g:pymode_rope_goto_definition_cmd = 'e'
let g:pymode_rope_completion_bind = ''

" vim-signcolor
nnoremap <silent> <leader>q :call signcolor#toggle_signs_for_colors_in_buffer()<CR>

" airline
let g:airline#extensions#tabline#show_tab_type = 0
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 88,
    \ 'x': 60,
    \ 'y': 88,
    \ 'z': 45,
    \ }

" Load local overrides
silent! source ~/.vimrc-local

" vim:foldmethod=marker foldlevel=0
