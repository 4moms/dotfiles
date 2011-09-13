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

" enable filetype detection:
filetype on

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" my common spelling mistakes ;)
abbreviate wierd weird
abbreviate restaraunt restaurant

"set statusline=%F%m%r%h%w\ [TYPE=%Y]\ Column:%04v\ Line:\ %04l/%L(%p%%)
"set laststatus=2
"hi StatusLine guifg=#CD5907 guibg=fg
"hi StatusLineNC guifg=#808080 guibg=#080808
"au BufNewFile,BufRead  *.pls    set syntax=dosini
" Statusline {{{
   " Functions {{{
      " Statusline updater {{{
         " Inspired by StatusLineHighlight by Ingo Karkat
         function! s:StatusLine(new_stl, type, current)
            let current = (a:current ? "" : "NC")
            let type = a:type
            let new_stl = a:new_stl

            " Prepare current buffer specific text
            " Syntax: <CUR> ... </CUR>
            let new_stl = substitute(new_stl, '<CUR>\(.\{-,}\)</CUR>', (a:current ? '\1' : ''), 'g')

            " Prepare statusline colors
            " Syntax: #[ ... ]
            let new_stl = substitute(new_stl, '#\[\(\w\+\)\]', '%#StatusLine'.type.'\1'.current.'#', 'g')

            if &l:statusline ==# new_stl
               " Statusline already set, nothing to do
               return
            endif

            if empty(&l:statusline)
               " No statusline is set, use my_stl
               let &l:statusline = new_stl
            else
               " Check if a custom statusline is set
               let plain_stl = substitute(&l:statusline, '%#StatusLine\w\+#', '', 'g')

               if &l:statusline ==# plain_stl
                  " A custom statusline is set, don't modify
                  return
               endif

               " No custom statusline is set, use my_stl
               let &l:statusline = new_stl
            endif
         endfunction
      " }}}
      " Color dict parser {{{
         function! s:StatusLineColors(colors)
            for type in keys(a:colors)
               for name in keys(a:colors[type])
                  let colors = {'c': a:colors[type][name][0], 'nc': a:colors[type][name][1]}
                  let type = (type == 'NONE' ? '' : type)
                  let name = (name == 'NONE' ? '' : name)

                  if exists("colors['c'][0]")
                     exec 'hi StatusLine'.type.name.' ctermbg='.colors['c'][0].' ctermfg='.colors['c'][1].' cterm='.colors['c'][2]
                  endif

                  if exists("colors['nc'][0]")
                     exec 'hi StatusLine'.type.name.'NC ctermbg='.colors['nc'][0].' ctermfg='.colors['nc'][1].' cterm='.colors['nc'][2]
                  endif
               endfor
            endfor
         endfunction
      " }}}
   " }}}
   " Default statusline {{{
      let g:default_stl  = ""
      let g:default_stl .= "<CUR>#[Mode] %{&paste ? 'PASTE  ' : ''}%{substitute(mode(), '', '', 'g')} #[ModeS]</CUR>"
      let g:default_stl .= "#[ModFlag]%{&readonly ? 'RO ' : ''}" " RO flag
      let g:default_stl .= " #[FileName]%t " " File name
      let g:default_stl .= "#[ModFlag]%(%M %)" " Modified flag
      let g:default_stl .= "#[BufFlag]%(%H%W %)" " HLP,PRV flags
      let g:default_stl .= "#[FileNameS] " " Separator
      let g:default_stl .= "#[FunctionName] " " Padding/HL group
      let g:default_stl .= "%<" " Truncate right
      let g:default_stl .= "%= " " Right align
      let g:default_stl .= "<CUR>#[FileFormat]%{&fileformat} </CUR>" " File format
      let g:default_stl .= "<CUR>#[FileEncoding]%{(&fenc == '' ? &enc : &fenc)} </CUR>" " File encoding
      let g:default_stl .= "<CUR>#[Separator]  ⊂ #[FileType]%{strlen(&ft) ? &ft : 'n/a'} </CUR>" " File type
      let g:default_stl .= "#[LinePercentS] #[LinePercent] %p%% " " Line/column/virtual column, Line percentage
      let g:default_stl .= "#[LineNumberS] #[LineNumber]  %l#[LineColumn]:%c%V " " Line/column/virtual column, Line percentage
      let g:default_stl .= "%{exists('g:synid') && g:synid ? ' '.synIDattr(synID(line('.'), col('.'), 1), 'name').' ' : ''}" " Current syntax group
   " }}}
   " Color dict {{{
      let s:statuscolors = {
         \   'NONE': {
            \   'NONE'         : [[ 236, 231, 'bold'], [ 232, 244, 'none']]
         \ }
         \ , 'Normal': {
            \   'Mode'         : [[ 214, 235, 'bold'], [                 ]]
            \ , 'ModeS'        : [[ 214, 240, 'bold'], [                 ]]
            \ , 'Branch'       : [[ 240, 250, 'none'], [ 234, 239, 'none']]
            \ , 'BranchS'      : [[ 240, 246, 'none'], [ 234, 239, 'none']]
            \ , 'FileName'     : [[ 240, 231, 'bold'], [ 234, 244, 'none']]
            \ , 'FileNameS'    : [[ 240, 236, 'bold'], [ 234, 232, 'none']]
            \ , 'Error'        : [[ 240, 202, 'bold'], [ 234, 239, 'none']]
            \ , 'ModFlag'      : [[ 240, 196, 'bold'], [ 234, 239, 'none']]
            \ , 'BufFlag'      : [[ 240, 250, 'none'], [ 234, 239, 'none']]
            \ , 'FunctionName' : [[ 236, 247, 'none'], [ 232, 239, 'none']]
            \ , 'FileFormat'   : [[ 236, 244, 'none'], [ 232, 239, 'none']]
            \ , 'FileEncoding' : [[ 236, 244, 'none'], [ 232, 239, 'none']]
            \ , 'Separator'    : [[ 236, 242, 'none'], [ 232, 239, 'none']]
            \ , 'FileType'     : [[ 236, 248, 'none'], [ 232, 239, 'none']]
            \ , 'LinePercentS' : [[ 240, 236, 'none'], [ 234, 232, 'none']]
            \ , 'LinePercent'  : [[ 240, 250, 'none'], [ 234, 239, 'none']]
            \ , 'LineNumberS'  : [[ 252, 240, 'bold'], [ 234, 234, 'none']]
            \ , 'LineNumber'   : [[ 252, 236, 'bold'], [ 234, 244, 'none']]
            \ , 'LineColumn'   : [[ 252, 240, 'none'], [ 234, 239, 'none']]
         \ }
         \ , 'Insert': {
            \   'Mode'         : [[ 153,  23, 'bold'], [                 ]]
            \ , 'ModeS'        : [[ 153,  31, 'bold'], [                 ]]
            \ , 'Branch'       : [[  31, 117, 'none'], [                 ]]
            \ , 'BranchS'      : [[  31, 117, 'none'], [                 ]]
            \ , 'FileName'     : [[  31, 231, 'bold'], [                 ]]
            \ , 'FileNameS'    : [[  31,  24, 'bold'], [                 ]]
            \ , 'Error'        : [[  31, 202, 'bold'], [                 ]]
            \ , 'ModFlag'      : [[  31, 196, 'bold'], [                 ]]
            \ , 'BufFlag'      : [[  31,  75, 'none'], [                 ]]
            \ , 'FunctionName' : [[  24, 117, 'none'], [                 ]]
            \ , 'FileFormat'   : [[  24,  75, 'none'], [                 ]]
            \ , 'FileEncoding' : [[  24,  75, 'none'], [                 ]]
            \ , 'Separator'    : [[  24,  37, 'none'], [                 ]]
            \ , 'FileType'     : [[  24,  81, 'none'], [                 ]]
            \ , 'LinePercentS' : [[  31,  24, 'none'], [                 ]]
            \ , 'LinePercent'  : [[  31, 117, 'none'], [                 ]]
            \ , 'LineNumberS'  : [[ 117,  31, 'bold'], [                 ]]
            \ , 'LineNumber'   : [[ 117,  23, 'bold'], [                 ]]
            \ , 'LineColumn'   : [[ 117,  31, 'none'], [                 ]]
         \ }
      \ }
   " }}}
" }}}

" Statusline highlighting {{{
augroup StatusLineHighlight
   autocmd!

   let s:round_stl = 0

   au ColorScheme * call <SID>StatusLineColors(s:statuscolors)
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter,CursorHold,BufWritePost,InsertLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 1)
   au BufLeave,BufWinLeave,WinLeave,CmdwinLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 0)
   au InsertEnter,CursorHoldI * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Insert', 1)
augroup END
" }}}

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

nnoremap <F5> :GundoToggle<CR>
set history=700

" Highlights lines over 80 chars in length
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
