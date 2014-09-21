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


syn region pythonCodeBlockReg start="```python" keepend end="```" contains=@Python
syn region jstCodeBlock start="```javascript" keepend end="```" contains=@JavaScript
syn region cssCodeBlockReg start="```css" keepend end="```" contains=@CSS
syn region rubyCodeBlockReg start="```ruby" keepend end="```" contains=@RUBY
syn region shCodeBlockReg start="```sh" keepend end="```" contains=@SH
syn region vimCodeBlockReg start="```vim" keepend end="```" contains=@VIM
syn region jsonFrontmatter start="^{$" keepend end="^}\n---$"
hi link jsonFrontmatter Comment


syntax case match
syntax keyword todoStates TODO APPT PAY BUY containedin=markdownH3,markdownH1,markdownH4,markdownH2,markdownH5
syntax keyword logStates LOG containedin=markdownH3,markdownH1,markdownH4,markdownH2,markdownH5
syntax keyword holdStates HOLD WAITING CLIENT containedin=markdownH3,markdownH1,markdownH4,markdownH2,markdownH5
syntax keyword doneStates DONE containedin=markdownH3,markdownH1,markdownH4,markdownH2,markdownH5
syntax keyword canceledStates CANCELED DEFERRED containedin=markdownH3,markdownH1,markdownH4,markdownH2,markdownH5

syntax match tag /\v(:\w+)+:/

syntax match projectOne /^\s\{2\}\*\+\s\+.\+$/ contains=holdStates,todoStates,doneStates,canceledStates,tag
syntax match projectTwo /^\s\{4\}\*\+\s\+.\+$/ contains=holdStates,todoStates,doneStates,canceledStates,tag
syntax match projectRoot /^\*\s\+.\+$/ contains=holdStates,todoStates,doneStates,canceledStates,tag
syntax match listStart /^\s\+-/
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
hi def link listStart Constant
hi def link questionStartTodo Special
hi def link doneLine Comment
hi def link taskDateStamp Comment
hi def link canceledLine Comment
hi def link doneStates Comment
"hi def link drawerRegion Comment
hi def link listStartDone  Comment
hi def link noteState Constant
hi def link importantStart Keyword
hi def link projectRoot Constant
hi def link projectOne Function
hi def link projectTwo String
hi def link holdStates Identifier
hi def link logStates Comment

hi Folded term=None ctermbg=None ctermfg=8 guibg=NONE
