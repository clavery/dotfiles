"setlocal equalprg=pandoc\ -t\ markdown\ --reference-links\ --wrap=none\ --atx-headers
setlocal suffixesadd=.md,.rst,.txt
setlocal nonumber
setlocal fo+=t
setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
setlocal iskeyword=48-57,a-z,A-Z,192-255,$,.,+

command! -range=% PDF <line1>,<line2>w !pandoc -f markdown -s --toc -V geometry:margin=1in --variable mainfont="DejaVu Serif" --variable sansfont=Arial -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% PDF2 <line1>,<line2>w !pandoc -f markdown -s -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% PDFPlain <line1>,<line2>w !pandoc -f markdown -s --toc --variable monofont="Source Code Pro" --variable mainfont="Helvetica" --variable sansfont="Helvetica" -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% HTML <line1>,<line2>w !cd $TMPDIR && pandoc -f markdown -s --toc --filter pandoc-plantuml-filter -o $TMPDIR/%:t:r.html && open $TMPDIR/%:t:r.html
command! -range=% DOCX <line1>,<line2>w !pandoc --reference-docx=/Users/clavery/Dropbox/Todo/Wiki/PixelMedia/reference.docx -f markdown -s --toc --filter pandoc-plantuml-filter -o $TMPDIR/%:t:r.docx && open $TMPDIR/%:t:r.docx
command! -range=% SLIDES <line1>,<line2>w !cd $TMPDIR && pandoc -f markdown -t revealjs -s -V revealjs-url='file:///Users/clavery/code/reveal.js/' --slide-level 2 -o $TMPDIR/%:t:r.html && open $TMPDIR/%:t:r.html

fu! pandoc#ToggleCB() range

  for lineno in range(a:firstline, a:lastline)
    let line = getline(lineno)

    if(match(line, "\\[ \\]") != -1)
      let line = substitute(line, "\\[ \\]", "[✓]", "")
    elseif(match(line, "\\[✓\\]") != -1)
      let line = substitute(line, "\\[✓\\]", "[ ]", "")
    else
      let line = substitute(line, "^\\(\\s*\\(-\\|\\*\\)\\)\\s", "\\1 [ ] ", "")
    endif

    call setline(lineno, line)
  endfor
endf

command! -range ToggleCB <line1>,<line2>call pandoc#ToggleCB()

vnoremap <silent> <buffer> <leader>t :ToggleCB<cr>
nnoremap <silent> <buffer> <leader>t :ToggleCB<cr>

