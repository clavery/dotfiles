setlocal equalprg=pandoc\ -t\ markdown\ --reference-links\ --no-wrap\ --atx-headers
setlocal suffixesadd=.md,.rst,.txt


command! PDF silent w !pandoc -f markdown -s --toc --latex-engine=xelatex --variable monofont="Source Code Pro" --variable mainfont="Source Code Pro" -o $TMPDIR/%:r.pdf && open $TMPDIR/%:r.pdf
command! PDFPlain silent w !pandoc -f markdown -s --toc --latex-engine=xelatex --variable monofont="Source Code Pro" --variable mainfont="Helvetica" --variable sansfont="Helvetica" -o $TMPDIR/%:r.pdf && open $TMPDIR/%:r.pdf
command! HTML silent w !pandoc -f markdown -s --toc -o $TMPDIR/%:r.html && open $TMPDIR/%:r.html
