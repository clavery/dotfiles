
" simple auto braces
"inoremap <buffer> {<cr> {}<left><cr><space><space>.<cr><esc>kA<bs>

" Function text object (does not wor correctly  in visual mode)
onoremap if :<c-u>execute "normal! $?function\r:nohl\rf{v%"<cr>
onoremap af :<c-u>execute "normal! $?function\r:nohl\rvf{%"<cr>

let g:used_javascript_libs = 'underscore,angularjs,jquery'


function! SendToNode() range
  let tonode = join(getline(a:firstline, a:lastline), "\n")
  python import vim, subprocess
  python p=subprocess.Popen(["node"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  python p.stdin.write(vim.eval('tonode'))
  python p.stdin.close()
  python serr = p.stderr.read()
  let result = pyeval('serr if serr else p.stdout.read()')

  if bufwinnr(bufnr("__JSOUT__")) == -1
    " Open a new split and set it up.
    botright 14split __JSOUT__
    execute "setlocal filetype=text"
    execute "setlocal nonumber"
    execute "setlocal norelativenumber"
    setlocal buftype=nofile
  else
    exe bufwinnr(bufnr("__JSOUT__")) . "wincmd w"
  endif

  execute "setlocal noreadonly"
  normal! ggdG
  call append(line('$'), split(result, '\v\n'))
  execute "setlocal readonly"
  exe "wincmd w"
endfunction
command! -range=% SendToNode  <line1>,<line2>call SendToNode()

vnoremap <buffer> <silent> <leader>s :SendToNode<cr>
nnoremap <buffer> <silent> <leader>s :SendToNode<cr>

vnoremap <buffer> <silent> <leader>r :SendToChrome<cr>
nnoremap <buffer> <silent> <leader>r :SendToChrome<cr>

nno <buffer> <silent> K :exe 'silent !open dash://js:'.expand("<cword>")<cr>
