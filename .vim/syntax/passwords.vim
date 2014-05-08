""" password lists

function! passwords#FoldText()
  return '→ ' . getline(v:foldstart)
endfunction
setlocal foldtext=passwords#FoldText()
setlocal foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
setlocal foldmethod=expr
" don't open folds for just searching
setlocal foldopen-=search
