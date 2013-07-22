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
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
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
set mouse=n
" Find the cursor
hi CursorLine ctermbg=white ctermfg=NONE guibg=white guifg=none
hi CursorColumn ctermbg=white ctermfg=NONE guibg=white guifg=none
nnoremap <Leader>C :set cursorline! cursorcolumn!<CR>
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

set wildignore+=*/tmp/*,*.so,*.swp,*.zip


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
Bundle 'vim-scripts/bad-whitespace'
Bundle 'scrooloose/nerdcommenter'
"" Colors
set background=dark
colorscheme dandelion
let g:solarized_termcolors=256

"" Aliases
ia rpry require 'pry'; binding.pry

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

"run the wip in this file
map <leader>wf :call RunWipFile()<cr>
"run feature file
map <leader>w :call RunWip()<cr>
"run spec for current file
map <leader>f :call RunTestFile()<cr>
"run spec for what is under cursor
map <leader>t :call RunNearestTest()<cr>
"run spec for entire app
map <leader>a :call RunTests('spec')<cr>
