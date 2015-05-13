if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'isml'
endif

let s:cpo_save = &cpo
set cpo&vim

runtime! syntax/html.vim syntax/html/*.vim


syn include @htmlJavaScript syntax/javascript.vim
syn region  javaScript start=+<isscript\_[^>]*>+ keepend end=+</isscript>+me=s-1 contains=@htmlJavaScript

syn keyword ismlTagName contained isscript iscomment
syn match ismlTagName contained "\<[a-z_]\+\(\-[a-z_]\+\)\+\>"
hi link ismlTagName Function


let b:current_syntax = "isml"
if main_syntax == 'isml'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save
