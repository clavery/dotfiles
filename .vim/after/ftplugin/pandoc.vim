"setlocal equalprg=pandoc\ -t\ markdown\ --reference-links\ --wrap=none\ --atx-headers
setlocal suffixesadd=.md,.rst,.txt
setlocal nonumber
setlocal fo+=t

setlocal iskeyword=48-57,a-z,A-Z,192-255,$,.,+

command! -range=% PDF <line1>,<line2>w !pandoc -f markdown -s --toc -V geometry:margin=1in -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% PDF2 <line1>,<line2>w !pandoc -f markdown -s -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% PDFPlain <line1>,<line2>w !pandoc -f markdown -s --toc --variable monofont="Source Code Pro" --variable mainfont="Helvetica" --variable sansfont="Helvetica" -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% HTML <line1>,<line2>w !pandoc -f markdown -s --toc -o $TMPDIR/%:t:r.html && open $TMPDIR/%:t:r.html
