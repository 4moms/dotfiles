" Encoding (important that this is set early in .vimrc)
se enc=utf8 " use UTF-8 internally
se fencs=ucs-bom,utf-8,default,latin1 " detect detectable Unicode, but fall back

" ==== Presentation
" Info
syntax on
set colorcolumn=80
set laststatus=2

" setup relative numbering
call rnu#setup()

" Do an incremental search
set incsearch
set hlsearch

" Not sure what this does. Looks important/specific
if &term == "xterm-color"
  fixdel
endif
set t_Co=256
set directory=~/.vim/swap//,/tmp/vim-swap//,/tmp//

" ==== Controls
let mapleader = ","
set mouse=a
" Find the cursor
hi CursorLine ctermbg=white ctermfg=NONE guibg=white guifg=NONE
hi CursorColumn ctermbg=white ctermfg=NONE guibg=white guifg=NONE
nnoremap <Leader>C :set cursorline! cursorcolumn!<CR>
" Escape with jk mashing
inoremap jk <Esc>
inoremap kj <Esc>
inoremap jj <Esc>
inoremap kk <Esc>
" searches are case-insensitive, unless they contain upper-case:
set ignorecase
set smartcase

" get rid of bells, hopefully
set noeb vb t_vb=

" Save on focus loss
:au FocusLost * silent! :wa

" ==== Typing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set backspace=2
set autoindent
set smartindent

" Special settings for python
autocmd BufRead,BufNewFile *.py setlocal tabstop=4 expandtab
" And for ruby
autocmd BufRead,BufNewFile *.rb setlocal tabstop=2 expandtab softtabstop=2 shiftwidth=2
" Clojure
autocmd BufRead,BufNewFile *.clj,*.cljs setf clojure
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
  autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

aug filetypedetect
  au! BufNewFile,BufRead *.markdown,*.md,*.mkd se ft=markdown
  au! BufNewFile,BufRead *.scala se ft=scala
  au! BufNewFile,BufRead *.hbs se ft=mustache
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

" Check for file changes
au CursorHold * checktime

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
augroup END

" ==== Plugins
" Airline (better Powerline)
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'

" Rainbow-Parenthesis
" they're overriden by syntax, so run this now
runtime plugin/RainbowParentheses.vim

" Ctrlp
" Show hidden files by default
let g:ctrlp_show_hidden = 1
"Ctrl P Ignore build and git directories
let g:ctrlp_custom_ignore = '\v[\/](\.git|build)$'

" <leader>n = CtrlP from current file's directory
nm <leader>n :CtrlPCurFile<CR>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" ==== Vundle
set rtp+=~/.vim/vundle
call alternative#vundle#rc()
filetype plugin indent on     " required!by Vundle
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-fugitive'
Bundle 'Markdown'
Bundle 'ervandew/supertab'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'tpope/vim-endwise'
Bundle 'airblade/vim-gitgutter'
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"
Bundle "garbas/vim-snipmate"
Bundle 'rcyrus/snipmate-snippets-rubymotion'
Bundle 'mhinz/vim-startify'
Bundle 'vim-scripts/bad-whitespace'
Bundle 'scrooloose/nerdcommenter'
Bundle 'derekwyatt/vim-scala'
Bundle 'Townk/vim-autoclose'
Bundle 'mustache/vim-mustache-handlebars'

"" Colors
set background=light
colorscheme Railscasts
let g:solarized_termcolors=256

"" Aliases
ia rpry require 'pry'; binding.pry

"" Reset search highlighting when refreshing the screen (Ctrl+l)
nn <silent> <C-l> :nohls<CR><C-l>

"" Testing
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  exec ":!bundle exec rspec " . a:filename
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  :silent !echo;echo;echo "Running test file"
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the
  " previously-marked file.
  let in_spec_file = match(expand("%"), '$') != -1
  if in_spec_file
    call SetTestFile()
  elseif
    !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file.command_suffix)
endfunction

function! RunNearestTest()
  :silent !echo;echo;echo;echo;echo;echo "Running nearest test"
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number)
endfunction

function! RunWip(...)
  :w
  :silent !echo;echo;echo;echo;echo; echo "Running wip for the project"
  exec ":!bundle exec rspec -t @wip"
endfunction

function! RunWipFile(...)
  :w
  :silent !echo;echo;echo;echo;echo; echo "Running wip in just one file"
  exec ":!bundle exec rspec -t @wip %"
endfunction

function! TrimWhiteSpace()
      %s/\s\+$//e
endfunction

function! RunCeedlingCurFile()
  :w
  exec ":!rake test:pattern[" . expand('%:t') .']'
endfunction


function! RunCeedlingAll()
  :w
  exec ":!rake test:all"
endfunction

"autocmd BufWritePre     * :call TrimWhiteSpace()
autocmd InsertLeave     * :call TrimWhiteSpace()

"run the wip in this file
map <leader>wf :call RunWipFile()<cr>
"run feature file
map <leader>w :call RunWip()<cr>
"run spec for current file
map <leader>f :call RunCeedlingCurFile()<cr>
"run spec for what is under cursor
map <leader>t :call RunNearestTest()<cr>
"run spec for entire app
map <leader>a :call RunCeedlingAll()<cr>
"keymaping for nerd tree
map <leader>bt :NERDTreeToggle<cr>
:set guifont=Bitstream\ Vera\ Sans\ Mono:h13


au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

