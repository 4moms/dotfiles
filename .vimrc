let mapleader = ","
hi CursorLine ctermbg=white ctermfg=NONE guibg=white guifg=none
hi CursorColumn ctermbg=white ctermfg=NONE guibg=white guifg=none
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
set nocompatible
set laststatus=2
set background=dark
let g:solarized_termcolors=256
colorscheme solarized
set colorcolumn=80

" White space in Vim
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set mouse=n
set nowrap
set backspace=2

" Auto indent after a {
set autoindent
set smartindent

" Make pasting reasonable
"set paste

" Escape with jk mashing
inoremap jk <Esc>
inoremap kj <Esc>
inoremap jj <Esc>
inoremap kk <Esc>

" The Vim command line
" ====================
" - Make autocompletion smarter
set wildmenu
set wildmode=list:longest

" The Vim status bar
" ====================
" - Show line information
set ruler

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

augroup vimrc
  "autocmd bufwritepost .vimrc source $MYVIMRC
augroup END


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
autocmd BufWritePost *.js !test -f ~/jslint/jsl && ~/jslint/jsl -conf ~/jslint/jsl.default.conf -nologo -nosummary -process <afile>
autocmd BufWritePost *.rb !ruby -c <afile>
autocmd BufWritePost *.rake !ruby -c <afile>
autocmd BufWritePost *.erb !erb -x -T '-' <afile> | ruby -c 
autocmd BufWritePost *.py !python -c "compile(open('<afile>').read(), '<afile>', 'exec')"
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
" autocmd BufWritePost *.css !test -f ~/csstidy/csslint.php && php ~/csstidy/csslint.php <afile>
" get jslint from http://javascriptlint.com/
" autocmd BufWritePost *.pp !puppet --parseonly <afile>
augroup en

" Special settings for python
autocmd BufRead *.py set tabstop=4
autocmd BufRead *.py set expandtab
" And for ruby
autocmd BufRead *.rb set tabstop=2
autocmd BufRead *.rb set expandtab
autocmd BufRead *.rb set softtabstop=2
autocmd BufRead *.rb set shiftwidth=2

" enable filetype detection:
filetype on

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" my common spelling mistakes ;)
abbreviate wierd weird
abbreviate restaraunt restaurant


if &term == "xterm-color"
  fixdel
endif
set t_Co=256

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

:command! Sortcss :g#\({\n\)\@<=#.,/}/sort 

set rnu
:match Search /\%(\_^\s*\)\@<=\%(\%1v\|\%5v\|\%9v\)\s/
:match Search /\S\zs[\t ]\+\%#\@!$/
call matchadd('Error', '') 

" runtime macros/matchit.vim
fun! HighlightWhitespaceErrors()
  " trailing whitespace, except for the current cursor position
  " tabs anywhere but leading
endf
au BufNewFile,BufRead * call HighlightWhitespaceErrors()

" Typo fixer 2000
if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

nnoremap <F5> :GundoToggle<CR>
set history=700

" Highlights lines over 80 chars in length
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" Pathogen
"call pathogen#infect()
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" for some reason the csscolor plugin is very slow when run on the terminal
" but not in GVim, so disable it if no GUI is running
if !has('gui_running')
    call add(g:pathogen_disabled, 'vim-css-color')
endif

" Gundo requires at least vim 7.3
if v:version < '703' || !has('python')
    call add(g:pathogen_disabled, 'gundo')
endif

if v:version < '702'
    call add(g:pathogen_disabled, 'autocomplpop')
    call add(g:pathogen_disabled, 'fuzzyfinder')
    call add(g:pathogen_disabled, 'l9')
endif

call pathogen#runtime_append_all_bundles()

" vundles
"git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'kien/ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'FuzzyFinder'
Bundle 'L9'
Bundle 'Markdown'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" ...

filetype plugin indent on     " required! 

" Plugin specific settings
"" Powerline
let g:Powerline_symbols = 'fancy'
set guifont=Inconsolata\ For\ Powerline

" Ctrlp settings
"" Split instead of replacing pane
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("v")': ['<cr>', '<2-LeftMouse>'],
  \ 'AcceptSelection("h")': ['<c-v>', '<RightMouse>'],
  \ 'AcceptSelection("e")': ['<c-x>', '<c-cr>', '<c-s>'],
  \ 'AcceptSelection("t")': ['<c-t>'],
\}

