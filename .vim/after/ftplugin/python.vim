
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4 autoindent

" Execute the tests
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
" cycle through test errors
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>

nmap <silent><Leader>pl <Esc>:PymodeLint<CR>
nmap <silent><Leader>pa <Esc>:PymodeLintAuto<CR>

vnoremap <silent><Leader>px :call pymode#rope#extract_method()<cr>
nnoremap <silent><Leader>pr :call pymode#rope#rename()<cr>
