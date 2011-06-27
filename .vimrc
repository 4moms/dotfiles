let mapleader = ","
hi CursorLine ctermbg=white ctermfg=NONE guibg=white guifg=none
hi CursorColumn ctermbg=white ctermfg=NONE guibg=white guifg=none
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
set nocompatible
set background=dark
colorscheme solarized

" Tab settings
set tabstop=3
set softtabstop=3
set shiftwidth=3
set expandtab
set mouse=n
set nowrap
set backspace=2

" Auto indent after a {
set autoindent
set smartindent

" Make pasting reasonable
set paste

if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

nmap <leader>v :tabedit $MYVIMRC<CR>

syntax on
set title
set number

" php helpfuls
" let php_sql_query = 1
let php_baselib = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1
let php_parent_error_open = 1
let php_folding = 1

" some common helpful settings 
set shiftwidth=2

"do an incremental search
set incsearch
set hlsearch

" Correct indentation after opening a phpdocblock and automatic * on every line
set formatoptions=qroct

" Wrap visual selectiosn with chars
:vnoremap ( "zdi^V(<C-R>z)<ESC>
:vnoremap { "zdi^V{<C-R>z}<ESC>
:vnoremap [ "zdi^V[<C-R>z]<ESC>
:vnoremap ' "zdi'<C-R>z'<ESC>
:vnoremap " "zdi^V"<C-R>z^V"<ESC>

" Detect filetypes
"if exists("did_load_filetypes")
"    finish
"endif
augroup filetypedetect
    au! BufRead,BufNewFile *.pp     setfiletype puppet
    au! BufRead,BufNewFile *httpd*.conf     setfiletype apache
    au! BufRead,BufNewFile *inc     setfiletype php
    au! BufRead,BufNewFile *scss     setfiletype sass
augroup END

" Nick wrote: Uncomment these lines to do syntax checking when you save
augroup Programming
" clear auto commands for this group
autocmd!
autocmd BufWritePost *.php !php -d display_errors=on -l <afile>
autocmd BufWritePost *.inc !php -d display_errors=on -l <afile>
autocmd BufWritePost *httpd*.conf !/etc/rc.d/init.d/httpd configtest
autocmd BufWritePost *.bash !bash -n <afile>
autocmd BufWritePost *.sh !bash -n <afile>
autocmd BufWritePost *.pl !perl -c <afile>
autocmd BufWritePost *.perl !perl -c <afile>
autocmd BufWritePost *.xml !xmllint --noout <afile>
autocmd BufWritePost *.xsl !xmllint --noout <afile>
" get csstidy from http://csstidy.sourceforge.net/
autocmd BufWritePost *.css !test -f ~/csstidy/csslint.php && php ~/csstidy/csslint.php <afile>
" get jslint from http://javascriptlint.com/
autocmd BufWritePost *.js !test -f ~/jslint/jsl && ~/jslint/jsl -conf ~/jslint/jsl.default.conf -nologo -nosummary -process <afile>
autocmd BufWritePost *.rb !ruby -c <afile>
autocmd BufWritePost *.rake !ruby -c <afile>
autocmd BufWritePost *.pp !puppet --parseonly <afile>
autocmd BufWritePost *.erb !erb -x -T '-' <afile> | ruby -c 
autocmd BufWritePost *.py !python -c "compile(open('<afile>').read(), '<afile>', 'exec')"
augroup en

" Special settings for python
autocmd BufRead *.py set tabstop=4
autocmd BufRead *.py set expandtab
" And for ruby
autocmd BufRead *.rb set tabstop=2
autocmd BufRead *.rb set expandtab

" enable filetype detection:
filetype on

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" my common spelling mistakes ;)
abbreviate wierd weird
abbreviate restaraunt restaurant


"set ls=2            " allways show status line
"set ruler           " show the cursor position all the time

"au BufNewFile,BufRead  *.pls    set syntax=dosini



if &term == "xterm-color"
  fixdel
endif

" Enable folding by fold markers
" this causes vi problems set foldmethod=marker 

" Correct indentation after opening a phpdocblock and automatic * on every
" line
set formatoptions=qroct



" The completion dictionary is provided by Rasmus:
" http://lerdorf.com/funclist.txt
set dictionary-=~/phpfunclist.txt dictionary+=~/phpfunclist.txt
" Use the dictionary completion
set complete-=k complete+=k

" {{{ Autocompletion using the TAB key

" " This function determines, wether we are on the start of the line text (then tab indents) or
" " if we want to try autocompletion
" function InsertTabWrapper()
"     let col = col('.') - 1
"    if !col || getline('.')[col - 1] !~ '\k'
"         return "\<tab>"
"     else
"         return "\<c-p>"
"     endif
" endfunction
" 
" " Remap the tab key to select action with InsertTabWrapper
" inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" }}} Autocompletion using the TAB key

" {{{ Mappings for autogeneration of PHP code

" There are 2 versions available of the code templates, one for the case, that
" the close character mapping is disabled and one for the case it is enabled.

" {{{ With close char mapping activated (currently active)

:command! Sortcss :g#\({\n\)\@<=#.,/}/sort 

set rnu
:match Search /\%(\_^\s*\)\@<=\%(\%1v\|\%5v\|\%9v\)\s/
