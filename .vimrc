" php helpfuls
" let php_sql_query = 1
set dictionary-=~/phpfunclist.txt dictionary+=~/phpfunclist.txt
let php_baselib = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1
let php_parent_error_open = 1
let php_folding = 1
" Correct indentation after opening a phpdocblock and automatic * on every
" line
set formatoptions=qroct

augroup filetypedetect
    au! BufRead,BufNewFile *.pp     setfiletype puppet
    au! BufRead,BufNewFile *httpd*.conf     setfiletype apache
    au! BufRead,BufNewFile *inc     setfiletype php
    au! BufRead,BufNewFile *scss     setfiletype sass
augroup END

set history=700
