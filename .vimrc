" .vimrc
" Charles Lavery

filetype off

call plug#begin('~/.vim/plugins')

Plug 'sudar/vim-arduino-syntax'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-pandoc-after'
Plug 'jpalardy/vim-slime'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'editorconfig/editorconfig-vim'
Plug 'jamessan/vim-gnupg'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'altercation/vim-colors-solarized'
Plug 'ledger/vim-ledger'
Plug 'hynek/vim-python-pep8-indent'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'robbles/logstash.vim'
Plug 'junegunn/fzf'
Plug 'tpope/vim-dadbod'
Plug 'vim-python/python-syntax'

"Plug 'ternjs/tern_for_vim'
Plug 'mbbill/undotree', { 'on':  ['UndotreeToggle'] }
Plug 'ctrlpvim/ctrlp.vim', { 'on' : ['CtrlP', 'CtrlPBuffer'] }
"Plug 'w0rp/ale', { 'branch' : 'v1.0.x' }
Plug 'clavery/ale'
Plug 'epmatsw/ag.vim', { 'on':  'Ag' }

" Plug 'leafgarland/typescript-vim'
" Plug 'ianks/vim-tsx'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'clavery/vim-dwre'
Plug 'posva/vim-vue'
" Plug 'cakebaker/scss-syntax.vim'
" Plug 'hail2u/vim-css3-syntax'
" Plug 'elzr/vim-json'
Plug 'clavery/vim-styled-components', {'branch': 'rewrite'}
" Plug 'styled-components/vim-styled-components', {'branch': 'rewrite'}
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'neowit/vim-force.com'
Plug 'mhartington/oceanic-next'

call plug#end()

filetype plugin indent on
syntax on

set nocompatible
set t_Co=256

if $TERM == 'xterm-256color'
  if (has("termguicolors"))
    set termguicolors
  endif
endif

let mapleader = "\<Space>"
nnoremap <space> <nop>

" ctrl-a/x scary
nnoremap g<C-A> <C-A>
nnoremap <C-A> <nop>
nnoremap g<C-X> <C-X>
nnoremap <C-X> <nop>

nnoremap Q <nop>

set autowrite
set sessionoptions=blank,buffers,curdir,help,winsize
set exrc
set secure
set noshowmode
set updatetime=1000
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
set synmaxcol=300
set nohlsearch
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set number
set norelativenumber " on is slow
set numberwidth=3
set hidden
set noshowmatch
set matchtime=2 " show paren matches quickly
set shortmess=lmnrxoOItTA
set ignorecase
set infercase
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
set breakindent
set laststatus=2
set foldlevelstart=0
set splitbelow
set splitright
set nobackup
set nowritebackup
set noswapfile
set list
set listchars=tab:▸\ ,trail:•,nbsp:␣,extends:…,precedes:…
augroup PreviewWindow
  au BufAdd * if &previewwindow | setlocal laststatus=0 | endif
  au BufAdd * if &previewwindow | setlocal nonumber | endif
augroup END
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:•
    au InsertLeave * :set listchars+=trail:•
augroup END

set nrformats=hex,alpha
set foldlevelstart=99
set completeopt=menu,preview

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

set undodir=~/.undo
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif
set undofile

if has("gui_running")
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  set guioptions-=R
  set guioptions-=r
  set mouse+=a
endif

func! Fugitive_status()
  if strlen(fugitive#head()) != 0
    return '['.fugitive#head().']'
  else
    return ''
  endif
endfunc

set statusline =
set statusline +=\ %(%3*%{!empty(v:this_session)?'['.ctrlp#session#name_from_file(v:this_session).']':''}%0*%)
set statusline +=\ %(%1*%{exists('g:loaded_fugitive')?Fugitive_status():''}%0*%)
set statusline +=\ %f            " path
set statusline +=%(\ [%n%M%R%W]%)                "modified flag

" Right
set statusline +=%=%{&ff}/%{strlen(&fenc)?&fenc:'none'}            "file format
set statusline +=%2*%y%*                "file type
set statusline +=\ %l             "current line
set statusline +=/%L\ \                "total lines
set statusline +=%3v\              "virtual column number
set statusline +=0x%04B\           "character under cursor

function! TabToggle()
  if &expandtab
    set shiftwidth=4
    set softtabstop=0
    set noexpandtab
  else
    set shiftwidth=4
    set softtabstop=4
    set expandtab
  endif
endfunction
nnoremap <F9> :execute TabToggle()<CR>

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

" default help in vert
"cnoremap help vert help

" don't yank on change
noremap C "_C
noremap c "_c

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

nnoremap <c-o> <c-o>zz

" switch buffers
nnoremap <BS> <C-^>

" Ctrl-move for Window Movement
nnoremap <silent> <C-Up> :wincmd k<cr>
nnoremap <silent> <C-Down> :wincmd j<cr>
nnoremap <silent> <C-Left> :wincmd h<cr>
nnoremap <silent> <C-Right> :wincmd l<cr>
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <right> :silent vertical resize +5<cr>
nnoremap <left> :silent vertical resize -5<cr>
nnoremap <up> :silent resize +5<cr>
nnoremap <down> :silent resize -5<cr>

set pastetoggle=<F2>

" quickfix next previous shortcut
noremap <silent> <leader>n :cn<cr>
noremap <silent> <leader>m :cp<cr>
noremap <silent> <leader>j :lnext<cr>
noremap <silent> <leader>k :lprev<cr>

" Capitals save/quit too
command! W :w
command! Q :q
command! Qa :qa
command! Wq :wq
command! WQ :wq
command! Wqa :wqa

cnoremap w!! w !sudo tee % >/dev/null

nnoremap <silent> <leader>/ :set hlsearch!<cr>
nnoremap <silent> <leader>l :set list!<cr>
nnoremap <silent> <leader>w :set wrap!<cr>

nnoremap <leader>` "=strftime("%FT%T%z")<cr>P
inoremap <C-D> <C-o>"=strftime("%FT%T%z")<cr>

"emacs begin/end
inoremap <c-a> <Home>
inoremap <c-e> <End>

" HIGHLIGHTING
func! SetCustomColors()
  colorscheme molokai
  hi User1 ctermbg=239 ctermfg=6 guibg=#555555 guifg=#AE81FF
  hi User2 ctermbg=239 ctermfg=3 guibg=#555555 guifg=#66D9EF
  hi User3 ctermbg=239 ctermfg=7 guibg=#555555 guifg=#E6DB74
  hi User4 ctermbg=239 ctermfg=118
  hi User5 ctermbg=239 ctermfg=118

  " jinja nice highlights
  hi jinjaSpecial guibg=#555555
  hi jinjaSpecial term=bold ctermfg=81 gui=italic guifg=#66D9EF guibg=#3e3e3e
  hi jinjaTagBlock term=underline ctermfg=118 guifg=#00ffff guibg=#3e3e3e
  hi jinjaVarBlock term=underline ctermfg=118 guifg=#00ffff guibg=#3e3e3e
  hi jinjaStatement term=bold ctermfg=161 guifg=#F92672 guibg=#3e3e3e
  hi jinjaOperator guibg=#3e3e3e
  hi jinjaFilter ctermfg=118 guifg=#A6E22E guibg=#3e3e3e
  hi jinjaBlockName ctermfg=118 guifg=#A6E22E guibg=#3e3e3e
  hi jinjaVariable term=underline ctermfg=208 guifg=#FD971F guibg=#3e3e3e
  hi jinjaString term=underline ctermfg=135 guifg=#AE81FF guibg=#3e3e3e
  hi jinjaNumber term=underline ctermfg=135 guifg=#AE81FF guibg=#3e3e3e

  hi VertSplit guibg=#555555 ctermbg=239

  if has("gui")
    highlight TabLineFill guifg=#293739 guibg=#ffffff
    highlight TabLine guibg=#232526 gui=None
    highlight TabLineSel guifg=#ef5939
    highlight Cursor guibg=#FFFF00
  endif

  augroup insertModeEx
    au!
    if &background == "light"
    else
      au InsertEnter * hi StatusLine ctermfg=2 guifg=#A6E22E
      au InsertLeave * hi StatusLine ctermfg=253 guifg=#eeeeee
    endif
  augroup END

  augroup chdirCurrent
    au!
    autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
    autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
  augroup END
endfunc
call SetCustomColors()

func! ToggleScheme()
  if &background == "light"
    set background=dark
    colorscheme molokai
  else
    set background=light
    colorscheme solarized
    hi Normal guifg=#5D6569
  endif
endfunc
nnoremap <F5> :silent call ToggleScheme()<cr>

" show syntax group under cursor
command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
function! SyntaxGroupBalloonExpr()
  let groups=map(synstack(v:beval_lnum, v:beval_col), 'synIDattr(v:val, "name")')
  if type(groups) == type([])
    return join(groups, ',')
  else
    return ""
  endif
endfunction
if has("balloon_eval")
  set bexpr=SyntaxGroupBalloonExpr()
  nnoremap <F7> :set ballooneval!<CR>
endif

if has("linux")
  set guifont=DejaVu\ Sans\ Mono\ 13
endif
if has("mac")
  "set guifont=Source\ Code\ Pro:h14
  set guifont=Consolas:h15
  "set guifont=Source\ Code\ Pro\ Light:h14
  "set guifont=Sauce\ Code\ Powerline:h14
endif
if has("win32")
  set guifont=Consolas:h13:cANSI
endif


set pumheight=8

" highlight VCS markers
match ErrorMsg '^\(<\|=\|>\||\)\{7\}\([^=].\+\)\?$'

set fillchars=vert:│,diff:-

func! SetDiffMode()
  set scrollbind

  noremap <leader>dh :diffget //2<CR>
  noremap <leader>dl :diffget //3<CR>
  noremap <leader>dg :diffget<CR>
  noremap <leader>dp :diffput<CR>
  noremap <leader>du :diffup<CR>

  set diffopt+=vertical

  syntax off
  let g:has_loaded_diff = 1
endfunc
func! SetDiffModeOff()
  set noscrollbind
  syntax on

  " nunmap dh
  " nunmap dl
  " nunmap dg
  " nunmap dp
  " nunmap du

  call SetCustomColors()
  let g:has_loaded_diff = 0
endfunc
let g:has_loaded_diff = 0
if &diff
  let g:has_loaded_diff = 1
endif
au BufEnter * if &diff | call SetDiffMode() | endif
au BufEnter,BufLeave * if !&diff && g:has_loaded_diff == 1 | call SetDiffModeOff() | endif


" FILETYPES

" File types overrides
augroup filetypes
  au!

  au BufRead *.md setlocal ft=markdown
  au BufRead *.csx setlocal ft=cs
  au BufRead *.ledger setlocal filetype=ledger
  au BufRead *.txt setlocal filetype=text
  au BufRead,BufNewFile *.scss set filetype=scss

  au BufRead *.aes setlocal noundofile
  au BufRead *.aes setlocal nobackup
  au BufRead *.aes setlocal viminfo=
  au BufRead *.secure setlocal noundofile
  au BufRead *.secure setlocal nobackup
  au BufRead *.secure setlocal viminfo=

  au BufRead *.tsv setlocal ft=tsv noexpandtab ts=4

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

" ag
function! SearchWithAg(ss)
  exec "Ag! " . shellescape(substitute(a:ss, "\\$", "\\\\$", "g"), 1)
endfunction
command! -nargs=1 S :call SearchWithAg(<q-args>)
nnoremap <leader>a :<C-U>S 

" gpg
let g:GPGPreferArmor = 1
let g:GPGDefaultRecipients = ['9B5B4181']

" syntastic
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '~'
let g:syntastic_style_error_symbol = 'x'
let g:syntastic_style_warning_symbol = '➧'
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_balloons = 0
let g:syntastic_stl_format = '%E{[%e:%F]}'
" nnoremap <silent> <leader>c :SyntasticCheck<cr>
" nnoremap <silent> <leader>e :Errors<cr>
let g:syntastic_html_tidy_ignore_errors=["proprietary attribute", "trimming empty"]
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_scss_checkers=['scss_lint']

let g:syntastic_dsscript_checkers=['eslint']

" ale
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'javascript.jsx': ['eslint'],
\   'dsscript': ['eslint'],
\   'python': ['autopep8'],
\}
let g:ale_python_autopep8_options = '--aggressive --aggressive'
" let g:ale_fix_on_save = 1
let g:ale_linter_aliases = {'dsscript': 'javascript', 'isml': 'html'}
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'dsscript': ['eslint'],
\   'xml': ['dwrexmllint'],
\}
nnoremap <silent> <leader>ef :ALEFix<cr>
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '➧'
let g:ale_echo_cursor = 1
let g:ale_xml_dwrexmllint_schema_path = '/Users/clavery/code/dwre/dwre-dwre-tools/dwre_tools/schemas/'

" javascript
let g:javascript_plugin_jsdoc = 1
autocmd FileType json set formatprg=python\ -mjson.tool

" Undo tree
nnoremap <silent> <leader>u :UndotreeToggle<cr>

let g:python_highlight_all = 1

" Ultisnips
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsSnippetsDir='~/.vim/UltiSnips/'

" matchit
runtime macros/matchit.vim

" netrw
let g:explHideFiles='^\.,.*\.pyc$'
let g:netrw_liststyle=3
let g:netrw_banner=0

" CTRLP
let g:ctrlp_map = '<c-p>'
nnoremap <C-e> :CtrlPBuffer<cr>
nnoremap <C-p> :CtrlP<cr>

" just use CWD
let g:ctrlp_working_path_mode = ''

let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', '_D=$(pwd); cd %s && git ls-files . -co --exclude-standard | ([ -f ~/.custignore ] && grep -E -v -f ~/.custignore || grep .) | ([ -f $_D/.custignore ] && grep -E -v -f $_D/.custignore || grep .)'],
    \ },
  \ 'fallback': '_D=$(pwd); find %s -type f | ([ -f ~/.custignore ] && grep -E -v -f ~/.custignore || grep .) | ([ -f $_D/.custignore ] && grep -E -v -f $_D/.custignore || grep .)'
  \ }
let g:ctrlp_match_window = 'bottom,btt,min:1,max:16'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_by_filename = 1

" pandoc
let g:pandoc#after#modules#enabled = ["ultisnips"]
"let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#conceal#blacklist = ['titleblock', 'list', 'atx']
let g:pandoc#syntax#codeblocks#embeds#langs = []
let g:pandoc#folding#fdc = 0
let g:pandoc#modules#disabled = ['chdir', 'bibliographies', 'completion', 'templates', 'commands']
let g:pandoc#hypertext#open_cmd = "e"
autocmd FileType pandoc syntax sync fromstart
let g:todo_journal_base="~/Dropbox/Todo/Journal"
"nnoremap <F4> :Journal<cr>

nnoremap <F3> :set spell!<cr>

" turn off help
nnoremap <silent> <F1> :echo<cr>

" jsx
let g:jsx_ext_required = 0

" FUNCTIONS

" Quickfix Window Toggle
nnoremap <leader>o :call QuickfixToggle()<cr>
let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        botright copen
        let g:quickfix_is_open = 1
    endif
endfunction
nnoremap <leader>el :call LLToggle()<cr>
let g:ll_is_open = 0
function! LLToggle()
    if g:ll_is_open
        lclose
        let g:ll_is_open = 0
    else
        botright lopen
        let g:ll_is_open = 1
    endif
endfunction

" Shell execution
let g:runner_default_command = 'zsh'
let g:runner_default_ft = 'text'
let g:runner_ignore_stderr = 0
vnoremap <silent> <leader>s :Runner<cr>
nnoremap <silent> <leader>s :Runner<cr>

" Show git log in balloon
function! GitLogBalloonExpr()
  let fname = bufname(v:beval_bufnr)
  let result = system("git log --format='%h <%an @ %aD> %s' -L " . v:beval_lnum . "," . v:beval_lnum . ":" . fname . " | head -n 1")
  if v:shell_error == 0
    return result
  endif
endfunction
"if has("balloon_eval")
"  set bexpr=GitLogBalloonExpr()
"  set ballooneval
"endif

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

" fix issue with sh vim syntax setting iskeyword
let g:sh_noisk=1

" fix unindent behavior
inoremap # X#

" DWRE
autocmd FileType dsscript nnoremap <buffer> <leader>da :DWREAdd<cr>
autocmd FileType dsscript nnoremap <buffer> <leader>dd :DWREDel<cr>
autocmd FileType dsscript nnoremap <buffer> <leader>dr :DWREReset<cr>
autocmd FileType dsscript nnoremap <buffer> <leader>dg :DWREDebug<cr>

autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

" close preview window
nnoremap <silent> <leader>gp :pclose<cr>

let g:slime_target = "tmux"

" word under cursor change
nnoremap c* *Ncgn
nnoremap c# #NcgN

"let g:lsp_async_completion = 1
" if executable('javascript-typescript-stdio')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'javascript-typescript-stdio',
"         \ 'cmd': {server_info->['javascript-typescript-stdio']},
"         \ 'whitelist': ['javascript', 'javascript.jsx'],
"         \ })
"   autocmd FileType javascript setlocal omnifunc=lsp#complete
"   autocmd FileType javascript.jsx setlocal omnifunc=lsp#complete
" endif



" if executable('pyls')
"     " pip install python-language-server
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pyls',
"         \ 'cmd': {server_info->['pyls']},
"         \ 'whitelist': ['python'],
"         \ })
"   autocmd FileType python setlocal omnifunc=lsp#complete
" endif
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

" " for asyncomplete.vim log
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')

command! -range=% JIRA <line1>,<line2>w !~/bin/jira.py
command! -range=% LOG <line1>,<line2>w !~/bin/log.py
" Load local overrides
silent! source ~/.vimrc-local

" force.com
let g:apex_tooling_force_dot_com_path = $HOME.'/.vim/tooling-force.com-0.4.0.2.jar'
let g:apex_backup_folder = $HOME.'/.salesforce/backup'
let g:apex_temp_folder = $HOME.'/.salesforce/temp'
let g:apex_properties_folder = $HOME.'/.salesforce/properties'
let g:apex_server_port = 9898
" vim:foldmethod=marker foldlevel=0
