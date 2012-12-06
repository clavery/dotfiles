" .vimrc
" Charles Lavery

call pathogen#infect()

set nocompatible
set t_Co=256

let mapleader = ","

" allow backspacing over everything in insert mode
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
set hlsearch
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set number
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
set textwidth=100
set wildmenu
set wildmode=list:longest
set smartindent
set laststatus=2
set foldlevelstart=0
set splitright
set nobackup
set nowritebackup
set noswapfile
set listchars=tab:▸\ ,eol:¬,trail:·,nbsp:⌧,extends:…,precedes:…
set nrformats=
set esckeys
set diffopt=filler,iwhite
set foldlevelstart=99

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
  set wildignore+=*/lib/*
  set wildignore+=*/build/*
  set wildignore+=*/.git/*
  set wildignore+=*/.svn/*
  set wildignore+=*/.sass-cache/*
  set wildignore+=*/lib/*
endif

" cursor line in normal mode only
set cursorline
augroup cline
  au!
  au WinLeave,InsertEnter * set nocursorline
  au WinEnter,InsertLeave * set cursorline
augroup END

augroup quickfix
  au!
  au Filetype qf setlocal nolist nowrap
augroup END

" disable mouse
if has('mouse')
  set mouse=n
endif

" Scroll in diffs
if &diff
  set scrollbind
endif

" fix crontab -e
if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif

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

syntax on
filetype plugin indent on

let g:explHideFiles='^\.,.*\.pyc$'
"let g:netrw_browsex_viewer=
let g:netrw_liststyle=3
let g:netrw_banner=0

""" AutoCommands

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=80
  autocmd FileType text setlocal formatoptions=qa
  autocmd FileType html setlocal textwidth=0
  autocmd FileType cf setlocal textwidth=0

  " Don't use undofile or backup/swp for *.aes and *.secure
  au BufRead *.aes setlocal noundofile
  au BufRead *.aes setlocal nobackup
  au BufRead *.aes setlocal viminfo=
  au BufRead *.secure setlocal noundofile
  au BufRead *.secure setlocal nobackup
  au BufRead *.secure setlocal viminfo=

  au BufWinLeave *.txt mkview
  au BufWinEnter *.txt silent loadview

  " Format text automagically
  au BufRead *.txt setf text
  au FileType text setlocal formatoptions=qtn
  au FileType text set ai

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  au FocusLost * nested :silent! wa

  " Use green status line in insert mode
  au InsertEnter * hi StatusLine term=reverse ctermbg=0 ctermfg=DarkGreen guibg=#A8FF60 guifg=#202020
  au InsertLeave,BufLeave,BufEnter * hi StatusLine guifg=#CCCCCC     guibg=#404040     gui=NONE    ctermfg=white       ctermbg=8    cterm=NONE

  " Red status bar when readonly buffer
  au BufNew,BufAdd,BufWrite,BufNewFile,BufRead,BufEnter,FileChangedRO * :if &ro | hi StatusLine guibg=#CD321D ctermbg=red | endif

  " Resize splits on window resize
  au VimResized * exe "normal! \<c-w>="
augroup END

""" Maps

nnoremap  <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a

" reload .vimrc
if has("win32")
  map <leader>r :source ~/_vimrc<cr>
else
  map <leader>r :source ~/.vimrc<cr>
endif

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

set pastetoggle=<F2>

" quickfix next previous shortcut
noremap <silent> <leader>n :cn<cr>
noremap <silent> <leader>p :cp<cr>
noremap <silent> <leader>o :bot cw<cr>

" Capitals save/quit too
command! W :w
command! Q :q
command! Wq :wq
command! WQ :wq

cnoremap w!! w !sudo tee % >/dev/null

" Run makeprg and open quickfix
nmap <F4> :w<cr>:make<cr><cr>:cw<cr>

" Better up and down movement
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap <DOWN> gj
noremap <UP> gk

" Folding
nnoremap <Space> za
vnoremap <Space> za

nnoremap <leader>/ :nohl<cr>
nnoremap <leader>l :set list!<cr>
nnoremap <leader>w :set wrap!<cr>

nnoremap <leader>` "=strftime("%a %d %b %Y %X")<cr>P

cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Make block level tags select nicer
nnoremap viT vitVkoj
nnoremap vaT vatV

""" Highlighting

set background=dark
colorscheme molokai

set guifont=Inconsolata-g:h14
if has("win32")
  set guifont=Consolas:h14:cANSI
endif

hi StatusLine guifg=#CCCCCC guibg=#404040 gui=NONE ctermfg=white ctermbg=8 cterm=NONE
hi StatusLineNC guifg=#606060
hi Search ctermbg=55

if has("gui")
  highlight SignColumn guibg=#232526 guifg=white
endif

" Highlight VCS markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

""" Status Line

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

""" Plugins

" Folding
function! MyFoldText() " {{{
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
endfunction " }}}
set foldtext=MyFoldText()

" Gundo
nmap <silent> <leader>u :GundoToggle<cr>

" Ack
map <leader>a :Ack 

"CtrlP
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_height = 18
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_regexp = 1
let g:ctrlp_switch_buffer = 0
nnoremap <silent> <c-e> :CtrlPBuffer<cr>

au FileType vim set keywordprg=:help

" PHP
au FileType php set keywordprg=:help
let g:syntastic_phpcs_conf="-n --standard=Squiz"
au FileType php set omnifunc=phpcomplete#CompletePHP

" SQL
let g:sql_type_default = 'mysql'

"Ledger
au BufRead *.ledger setlocal filetype=ledger

command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

nnoremap <c-w><right> :vertical res -10<cr>
nnoremap <c-w><left> :vertical res +10<cr>
nnoremap <c-w><up> :res +5<cr>
nnoremap <c-w><down> :res -5<cr>

set fillchars=vert:\ 
high VertSplit guibg=#555555

" PYTHON
set wildignore+=*.pyc
set completeopt=menuone,longest,preview
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
let g:pydoc_open_cmd = 'vsplit'
au FileType python setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4 autoindent
let g:pymode_lint_write = 0
let g:pymode_folding = 0

" Supertab
function! g:MyFunction()
  py km_from_string("")
  call SuperTabChain(&completefunc, "<c-x><c-n>") |
  call SuperTabSetDefaultCompletionType("<c-x><c-u>")
endfunction
let g:snipMateAllowMatchingDot = 0
command! IPy call g:MyFunction()

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Javascript
set wildignore+=*.min.js
au FileType javascript set keywordprg=:help
au FileType javascript setlocal makeprg=jshint\ %\\\|sed\ '/^$/d'\\\|sed\ '/^[0-9]\ /d'
au FileType javascript setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
au Filetype javascript inoremap <buffer> {<cr> {}<left><cr><space><space>.<cr><esc>kA<bs>

" vitality
let g:vitality_fix_focus = 0

"matchit
runtime macros/matchit.vim
map <tab> %
