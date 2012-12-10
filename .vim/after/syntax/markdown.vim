unlet b:current_syntax
syn include @Python syntax/python.vim
unlet b:current_syntax
syn include @CSS syntax/css.vim
unlet b:current_syntax
syn include @JavaScript syntax/javascript.vim


syn region pythonCodeBlockReg start="```python" keepend end="```" contains=@Python

syn region jstCodeBlock containedin=ALL start="```javascript" keepend end="```" contains=@JavaScript

syn region cssCodeBlockReg start="```css" keepend end="```" contains=@CSS
