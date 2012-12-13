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
