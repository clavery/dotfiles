" .vimrc
" Charles Lavery

filetype off

call pathogen#infect()

filetype plugin indent on
syntax on

set nocompatible
set t_Co=256

let mapleader = "\<Space>"
nnoremap <space> <nop>

if has('mac')
  set macmeta
endif

set exrc
set secure
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
set noshowmatch
set matchtime=2 " show paren matches quickly
set shortmess=lmnrxoOItTA
set ignorecase
set smartcase
set ttyfast
set gdefault " change behavior of /g option
set linebreak " break on word
set formatoptions=c,r,q,l
set textwidth=100
set colorcolumn=+1
set showbreak=↪
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
set list
set listchars=tab:▸\ ,trail:•,nbsp:␣,extends:…,precedes:…
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:•
    au InsertLeave * :set listchars+=trail:•
augroup END
"augroup tabonoff
"  " remove tab from listchars if using tab indent style
"  au!
"  au BufReadPost * :if &expandtab == 'noexpandtab' | setlocal listchars+=tab:\ \ | endif
"augroup END
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
  set wildignore+=.hg,.git,.svn
  set wildignore+=*/WEB-INF/*
  set wildignore+=*/node_modules/*
  set wildignore+=*/bower_components/*
  set wildignore+=.sass-cache
  set wildignore+=*.min.js
  set wildignore+=*.pyc
  set wildignore+=*/tmp/*
  set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
  set wildignore+=*.DS_Store
  set wildignore+=lib
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

if !has("gui_running")
  let g:loaded_airline = 1
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


" MAPPINGS


" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

nnoremap <c-o> <c-o>zz
noremap  <F1> :checktime<cr>
inoremap <F1> <esc>:checktime<cr>

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

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" quickfix next previous shortcut
noremap <silent> <leader>n :cn<cr>
noremap <silent> <leader>m :cp<cr>
noremap <silent> <leader>j :lnext<cr>
noremap <silent> <leader>k :lprev<cr>

" Capitals save/quit too
command! W :w
command! Q :q
command! Wq :wq
command! WQ :wq

cnoremap w!! w !sudo tee % >/dev/null

nnoremap <silent> <leader>/ :set hlsearch!<cr>
nnoremap <silent> <leader>l :set list!<cr>
nnoremap <silent> <leader>w :set wrap!<cr>

nnoremap <leader>` "=strftime("%a %d %b %Y %X")<cr>P

nnoremap <c-w><right> :vertical res -10<cr>
nnoremap <c-w><left> :vertical res +10<cr>
nnoremap <c-w><up> :res +5<cr>
nnoremap <c-w><down> :res -5<cr>

"emacs begin/end
inoremap <c-a> <Home>
inoremap <c-e> <End>

" allows incsearch highlighting for range commands
cnoremap $t <CR>:t''<CR>
cnoremap <C-t> <CR>:t''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap <C-j> <CR>:m''<CR>
cnoremap $d <CR>:d<CR>``


" HIGHLIGHTING

colorscheme molokai

" show syntax group under cursor
command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

if has("linux")
  set guifont=DejaVu\ Sans\ Mono\ 13
endif
if has("mac")
  set guifont=Source\ Code\ Pro:h14
  set guifont=Sauce\ Code\ Powerline:h14
endif
if has("win32")
  set guifont=Consolas:h13:cANSI
endif

hi Search ctermbg=55

if has("gui")
  highlight SignColumn guibg=#232526 guifg=#ffffff
  highlight SpecialKey guifg=red
  highlight Normal guibg=#303030

  hi LineNr guifg=#999999 guibg=#555555
  hi Visual guibg=#b3d4fc guifg=#000000 ctermbg=240
  hi CursorLine guibg=#E6FFFF guifg=#000000 ctermbg=240
  " hot pink
  hi Search guibg=#fe57a1 guifg=#000000
  hi IncSearch guifg=#fe57a1 guibg=#000000
endif

highlight PmenuSel ctermbg=16 ctermfg=13

hi ColorColumn ctermbg=lightgrey guibg=#343434
set pumheight=8

" highlight VCS markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set fillchars=vert:\ ,diff:-
high VertSplit guibg=#555555

" Override diff colors
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


" FILETYPES

" File types overrides
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

" File jump suffixes
autocmd FileType rst setlocal suffixesadd=.rst
autocmd FileType org setlocal suffixesadd=.rst,.org

" Jinja2
au BufRead *.j2 set ft=jinja

" Org
au BufRead *.org set ft=org

" html
let g:html_exclude_tags = ['html']


augroup ft_quickfix
    au!
    au Filetype qf setlocal norelativenumber colorcolumn=0 nolist cursorline nowrap tw=0
augroup END

" PLUGINS

" emmet
let g:user_emmet_install_global = 0
autocmd FileType html,jinja,css,scss EmmetInstall

" gpg
let g:GPGPreferArmor = 1
let g:GPGDefaultRecipients = ['9B5B4181']

" syntastic
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '~'
let g:syntastic_style_error_symbol = 'x'
let g:syntastic_style_warning_symbol = '➧'

" Gundo
nmap <silent> <leader>u :GundoToggle<cr>

" Ultisnips
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsExpandTrigger="<c-j>"

" matchit
runtime macros/matchit.vim

" netrw
let g:explHideFiles='^\.,.*\.pyc$'
let g:netrw_liststyle=3
let g:netrw_banner=0

" CTRLP
let g:ctrlp_map = '<c-p>'
nnoremap <C-e> :CtrlPBuffer<cr>
" just use CWD
let g:ctrlp_working_path_mode = ''
let g:ctrlp_user_command = ['.git', '_D=$(pwd); cd %s && git ls-files . -co --exclude-standard | ([ -f ~/.custignore ] && grep -E -v -f ~/.custignore || grep .) | ([ -f $_D/.custignore ] && grep -E -v -f $_D/.custignore || grep .)', '_D=$(pwd); find %s -type f | ([ -f ~/.custignore ] && grep -E -v -f ~/.custignore || grep .) | ([ -f $_D/.custignore ] && grep -E -v -f $_D/.custignore || grep .)']
let g:ctrlp_match_window = 'bottom,btt,min:1,max:16'

" You Complete Me
let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']

" Gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_enabled = 0
let g:gitgutter_highlight_lines = 1
nnoremap <leader>g :GitGutterToggle<cr>

" Airline
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1

let g:riv_global_leader="<c-z>"

" Pymode
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
nnoremap <silent><Leader>pa <Esc>:PymodeLintAuto<CR>

" vim-signcolor
nnoremap <silent> <leader>q :call signcolor#toggle_signs_for_colors_in_buffer()<CR>

" syntastic
nnoremap <silent> <leader>e :Errors<cr>

" airline
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
let g:airline#extensions#tabline#show_tab_type = 0


" FUNCTIONS

" Quickfix Window Toggle
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

" Shell execution
function! s:get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  return join(lines, " ")
endfunction

let g:shell_filetype = "text"
vnoremap <leader>s :<c-u>call SplitShellCmd()<cr>
nnoremap <leader>s :<c-u>call SplitShellCmdP()<cr>
function! SplitShellCmdP()
  normal! mx
  normal! vap
  call SplitShellCmd()
  normal! `x
endfunction
function! SplitShellCmd()
  let cmd = s:get_visual_selection()
  let result = system(cmd)

  if bufwinnr(bufnr("__CMD_SCRATCH__")) == -1
    " Open a new split and set it up.
    top split __CMD_SCRATCH__
    execute "setlocal filetype=".g:shell_filetype
    setlocal buftype=nofile
  else
    exe bufwinnr(bufnr("__CMD_SCRATCH__")) . "wincmd w"
  endif

  normal! ggdG
  call append(line('$'), split(result, '\v\n'))
  exe "wincmd w"
endfunction

" Pytest in a split
" TODO generalize by filetype
nnoremap <leader>t :call SplitShellPytest()<cr>
function! SplitShellPytest()
  write
  let cmd = "py.test --tb=short -v " . expand("%")
  let result = system(cmd)

  if bufwinnr(bufnr("__PYTEST__")) == -1
    " Open a new split and set it up.
    botright 14split __PYTEST__
    execute "setlocal filetype=pytest"
    execute "setlocal nonumber"
    execute "setlocal norelativenumber"
    setlocal buftype=nofile
  else
    exe bufwinnr(bufnr("__PYTEST__")) . "wincmd w"
  endif

  execute "setlocal noreadonly"
  normal! ggdG
  call append(line('$'), split(result, '\v\n'))
  execute "setlocal readonly"
  exe "wincmd w"
endfunction

" Show git log in balloon
function! GitLogBalloonExpr()
  let fname = bufname(v:beval_bufnr)
  let result = system("git log --format='%h <%an @ %aD> %s' -L " . v:beval_lnum . "," . v:beval_lnum . ":" . fname . " | head -n 1")
  if v:shell_error == 0
    return result
  endif
endfunction
if has("balloon_eval")
  set bexpr=GitLogBalloonExpr()
  set ballooneval
endif

function! HiInterestingWord(n)
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction
nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

nnoremap <leader>\ :MultipleCursorsFind <c-r>/<cr>

" Load local overrides
silent! source ~/.vimrc-local

" vim:foldmethod=marker foldlevel=0
