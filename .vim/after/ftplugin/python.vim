
setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4 autoindent

nmap <silent><Leader>pl <Esc>:PymodeLint<CR>
nmap <silent><Leader>pa <Esc>:PymodeLintAuto<CR>

vnoremap <silent><Leader>px :call pymode#rope#extract_method()<cr>
nnoremap <silent><Leader>pr :call pymode#rope#rename()<cr>
