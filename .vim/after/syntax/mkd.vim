unlet b:current_syntax
syn include @Python syntax/python.vim
unlet b:current_syntax
syn include @CSS syntax/css.vim
unlet b:current_syntax
syn include @JavaScript syntax/javascript.vim
unlet b:current_syntax
syn include @RUBY syntax/ruby.vim
unlet b:current_syntax
syn include @SH syntax/sh.vim
unlet b:current_syntax
syn include @VIM syntax/vim.vim

syntax region notesInlineCode matchgroup=notesInlineCodeMarker start=/`/ end=/`/ concealends
hi link notesInlineCodeMarker Question
hi link notesInlineCode Question

syn region pythonmkdCode matchgroup=mkdDelimiter start=/^\s*```python.*$/ end=/^\s*```\s*$/ concealends contains=mkdCodeCfg,@Python
syn match  pythonmkdCodeCfg "{[^}]*}" contained conceal 

syn region javascriptmkdCode matchgroup=mkdDelimiter start=/^\s*```javascript.*$/ end=/^\s*```\s*$/ concealends contains=mkdCodeCfg,@javascript
syn match  javascriptmkdCodeCfg "{[^}]*}" contained conceal 

syn region cssmkdCode matchgroup=mkdDelimiter start=/^\s*```css.*$/ end=/^\s*```\s*$/ concealends contains=mkdCodeCfg,@css
syn match  cssmkdCodeCfg "{[^}]*}" contained conceal 

syn region vimmkdCode matchgroup=mkdDelimiter start=/^\s*```vim.*$/ end=/^\s*```\s*$/ concealends contains=mkdCodeCfg,@vim
syn match  vimmkdCodeCfg "{[^}]*}" contained conceal 

syn region csmkdCode matchgroup=mkdDelimiter start=/^\s*```cs.*$/ end=/^\s*```\s*$/ concealends contains=mkdCodeCfg,@cs
syn match  csmkdCodeCfg "{[^}]*}" contained conceal 

syn region shmkdCode matchgroup=mkdDelimiter start=/^\s*```sh.*$/ end=/^\s*```\s*$/ concealends contains=mkdCodeCfg,@sh
syn match  shmkdCodeCfg "{[^}]*}" contained conceal 


syntax case match
syntax keyword todoStates TODO APPT PAY BUY containedin=htmlH1,htmlH2,htmlH3,htmlH4
syntax keyword logStates LOG containedin=htmlH1,htmlH2,htmlH3,htmlH4
syntax keyword holdStates HOLD WAITING CLIENT containedin=htmlH1,htmlH2,htmlH3,htmlH4
syntax keyword doneStates DONE containedin=htmlH1,htmlH2,htmlH3,htmlH4
syntax keyword canceledStates CANCELED DEFERRED containedin=htmlH1,htmlH2,htmlH3,htmlH4

syntax match tag /\v(:\w+)+:/

"syntax match listStart /^\s\+-/
syntax match questionStartTodo /^\s\+?/
syntax match listStartDone /^\s\++.\+$/
syntax match importantStart /^\s\{-}!.\+$/
syntax match doneLine /^\s*\*\sDONE.\+$/
syntax match canceledLine /CANCELED.\+$/
syntax match taskDatestamp /\v\[\d{8}T\d{6}\]/


syntax case ignore

syntax match  orgInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/

"syntax region drawerRegion start=+:.\+:+ end=+:END:+

hi def link fileRef    Question
hi def link orgInlineURL    Question
hi def link todoStates Function
"hi def link listStart Constant
hi def link questionStartTodo Special
hi def link doneLine Comment
hi def link taskDateStamp Comment
hi def link canceledLine Comment
hi def link doneStates Comment
"hi def link drawerRegion Comment
hi def link listStartDone  Comment
hi def link noteState Constant
hi def link importantStart Keyword
hi def link holdStates Identifier
hi def link logStates Comment

hi Folded term=None ctermbg=None ctermfg=8 guibg=NONE
