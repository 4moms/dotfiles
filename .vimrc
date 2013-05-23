" ==== Presentation
" Info
syntax on
set colorcolumn=80
set laststatus=2
if exists('&relativenumber')
  set relativenumber
  augroup WindowRNU
  auto!
  auto BufWinEnter,WinEnter,FocusGained * setlocal relativenumber
  auto WinLeave,FocusLost * setlocal number
  augroup END
endif
" Do an incremental search
set incsearch
set hlsearch
" Not sure what this does. Looks important/specific
if &term == "xterm-color"
  fixdel
endif
set t_Co=256
set noswapfile

" ==== Controls
let mapleader = ","
set mouse=n
" Find the cursor
hi CursorLine ctermbg=white ctermfg=NONE guibg=white guifg=none
hi CursorColumn ctermbg=white ctermfg=NONE guibg=white guifg=none
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
" Escape with jk mashing
inoremap jk <Esc>
inoremap kj <Esc>
inoremap jj <Esc>
inoremap kk <Esc>
" searches are case-insensitive, unless they contain upper-case:
set ignorecase
set smartcase


" ==== Typing
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set backspace=2
set autoindent
set smartindent
" Special settings for python
autocmd BufRead *.py set tabstop=4
autocmd BufRead *.py set expandtab
" And for ruby
autocmd BufRead *.rb set tabstop=2
autocmd BufRead *.rb set expandtab
autocmd BufRead *.rb set softtabstop=2
autocmd BufRead *.rb set shiftwidth=2
" Clojure
autocmd BufRead *.clj,*.cljs setf clojure
" Highlight extra whitespace
:match Search /\%(\_^\s*\)\@<=\%(\%1v\|\%5v\|\%9v\)\s/
:match Search /\S\zs[\t ]\+\%#\@!$/
call matchadd('Error', '')
" Wrap visual selectiosn with chars
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
vnoremap " "zdi"<C-R>z"<ESC>


" ==== Meta-vim
filetype on
" reload vimrc on save
augroup vimrc
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup END

aug filetypedetect
  au! BufNewFile,BufRead *.markdown,*.md,*.mkd se ft=markdown
aug END


nmap <leader>v :tabedit $MYVIMRC<CR>
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

" === Programming things
" Syntax checks
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

" ==== Plugins
" Powerline
let g:Powerline_symbols = 'fancy'
set guifont=Inconsolata\ For\ Powerline
" Rainbow-Parenthesis
" they're overriden by syntax, so run this now
runtime plugin/RainbowParenthsis.vim 
" Ctrlp 
" Split instead of replacing pane
" let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("v")': ['<cr>', '<2-LeftMouse>'],
  \ 'AcceptSelection("h")': ['<c-v>', '<RightMouse>'],
  \ 'AcceptSelection("e")': ['<c-x>', '<c-cr>', '<c-s>'],
  \ 'AcceptSelection("t")': ['<c-t>'],
\}

run! plugin/*.vim

" ==== Vundle
set rtp+=~/.vim/vundle/
call vundle#rc()
filetype plugin indent on     " required!by Vundle
Bundle 'Lokaltog/vim-powerline'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-fugitive'
Bundle 'Markdown'
Bundle 'VimClojure'
Bundle 'ervandew/supertab'
Bundle 'vim-scripts/Rainbow-Parenthesis'
Bundle 'tpope/vim-endwise'
Bundle 'airblade/vim-gitgutter'
Bundle 'ervandew/supertab'
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"
Bundle "garbas/vim-snipmate"
Bundle 'rcyrus/snipmate-snippets-rubymotion'
Bundle 'mhinz/vim-startify'
Bundle 'justinxreese/vim-detailed'
"" Colors
set background=dark
colorscheme detailed
let g:solarized_termcolors=256

"" Aliases
ia rpry require 'pry'; binding.pry
