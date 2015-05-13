setlocal equalprg=pandoc\ -t\ markdown\ --reference-links\ --no-wrap\ --atx-headers
setlocal suffixesadd=.md,.rst,.txt


command! -range=% PDF silent <line1>,<line2>w !pandoc -f markdown -s --toc -V geometry:margin=1in -o $TMPDIR/%:t:r.pdf --filter pandoc-plantuml-filter && open $TMPDIR/%:t:r.pdf
command! -range=% PDFPlain silent <line1>,<line2>w !pandoc -f markdown -s --toc --variable monofont="Source Code Pro" --variable mainfont="Helvetica" --variable sansfont="Helvetica" -o $TMPDIR/%:t:r.pdf && open $TMPDIR/%:t:r.pdf
command! -range=% HTML silent <line1>,<line2>w !pandoc -f markdown -s --toc -o $TMPDIR/%:t:r.html --filter pandoc-plantuml-filter && open $TMPDIR/%:t:r.html
