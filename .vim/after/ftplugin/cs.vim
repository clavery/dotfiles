
function! ExecuteScriptCs()
  let t = tempname() . ".csx"
  call writefile(getline(1, '$'), t)
  call runner#RunShellCommand("~/code/scriptcs/artifacts/Release/bin/scriptcs -ScriptName ". t)
endfunction
function! ExecuteScriptCsRange() range
  let tocmd = getline(a:firstline, a:lastline)
  let t = tempname() . ".csx"
  call writefile(tocmd, t)
  call runner#RunShellCommand("~/code/scriptcs/artifacts/Release/bin/scriptcs -ScriptName ". t)
endfunction

nnoremap <buffer> <silent> <leader>s :call ExecuteScriptCs()<cr>
vnoremap <buffer> <silent> <leader>s :call ExecuteScriptCsRange()<cr>

