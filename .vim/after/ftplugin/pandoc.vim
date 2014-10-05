setlocal equalprg=pandoc\ -t\ markdown\ --reference-links\ --no-wrap\ --atx-headers
setlocal suffixesadd=.md,.rst,.txt


command! ToPDF silent w !pandoc -f markdown -s --toc --latex-engine=xelatex --variable monofont="Source Code Pro" --variable mainfont="Source Code Pro" -o $TMPDIR/%:r.pdf && open $TMPDIR/%:r.pdf
