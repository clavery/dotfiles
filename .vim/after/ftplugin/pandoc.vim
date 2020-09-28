"setlocal equalprg=pandoc\ -t\ markdown\ --reference-links\ --wrap=none\ --atx-headers
setlocal suffixesadd=.md,.rst,.txt
setlocal nonumber
setlocal fo+=t
setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
setlocal iskeyword=48-57,a-z,A-Z,192-255,$,.,+

command! -range=% PDF <line1>,<line2>w !pandoc -f markdown -s --toc -V geometry:margin=1in --variable mainfont="DejaVu Serif" --variable sansfont=Arial -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% PDF2 <line1>,<line2>w !pandoc -f markdown -s -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% PDFPlain <line1>,<line2>w !pandoc -f markdown -s --variable monofont="Source Code Pro" --variable mainfont="Helvetica" --variable sansfont="Helvetica" -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% HTML <line1>,<line2>w !cd $TMPDIR && pandoc -f markdown -s --toc -o $TMPDIR/%:t:r.html && open $TMPDIR/%:t:r.html
command! -range=% DOCX <line1>,<line2>w !pandoc --reference-doc=/Users/charleslavery/Nextcloud/Todo/Wiki/LBH/reference.docx -f markdown -s --toc -o $TMPDIR/%:t:r.docx && open $TMPDIR/%:t:r.docx
command! -range=% SLIDES <line1>,<line2>w !cd $TMPDIR && pandoc -f markdown -t revealjs -s -V revealjs-url='file:///Users/charleslavery/code/reveal.js/' --slide-level 2 -o $TMPDIR/%:t:r.html && open $TMPDIR/%:t:r.html

function! TSIndent(line)
	return strlen(matchstr(a:line,'\v^\s+'))
endfunction
setlocal foldmethod=expr
setlocal foldexpr=MyTSIndentFoldExpr()
setlocal foldcolumn=0
function! MyTSIndentFoldExpr()
	if (getline(v:lnum)=~'^$')
		return 0
	endif
	let ind = TSIndent(getline(v:lnum))
	let indNext = TSIndent(getline(v:lnum+1))
	return (ind<indNext) ? ('>'.(indNext)) : ind
endfunction
setlocal foldtext=MyFoldText()
function! MyFoldText()
	let line = getline(v:foldstart)
	" Foldtext ignores tabstop and shows tabs as one space,
	" so convert tabs to 'tabstop' spaces so text lines up
	let ts = repeat(' ',&tabstop)
	let line = substitute(line, '\t', ts, 'g')
  let numLines = v:foldend - v:foldstart + 1
	return line.' ['.numLines.' lines]'
endfunction
