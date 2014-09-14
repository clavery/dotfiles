

if exists("g:loaded_runner") || &cp
  finish
endif
let g:loaded_runner = 1

function! runner#run() range
  let tocmd = join(getline(a:firstline, a:lastline), "\n")

  let runner_command = exists('b:runner_command') ? b:runner_command : g:runner_default_command
  let filetype = exists('b:runner_ft') ? b:runner_ft : g:runner_default_ft
  let ignore_stderr = exists('b:runner_ignore_stderr') ? b:runner_ignore_stderr : g:runner_ignore_stderr

  python import vim, subprocess
  python p=subprocess.Popen(vim.eval('runner_command').split(), stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  python p.stdin.write(vim.eval('tocmd'))
  python p.stdin.close()
  python serr = p.stderr.read()

  if ignore_stderr
    let result = pyeval('p.stdout.read()')
  else
    let result = pyeval('serr if serr else p.stdout.read()')
  endif

  if bufwinnr(bufnr("__OUT__")) == -1
    " Open a new split and set it up.
    botright 14split __OUT__
    execute "setlocal filetype=" . filetype
    execute "setlocal nonumber"
    execute "setlocal norelativenumber"
    setlocal buftype=nofile
  else
    exe bufwinnr(bufnr("__OUT__")) . "wincmd w"
  endif

  execute "setlocal noreadonly"
  normal! ggdG
  call append(line('$'), split(result, '\v\n'))
  execute "setlocal readonly"
  exe "wincmd w"
endfunction

command! -range=% Runner  <line1>,<line2>call runner#run()
