" Set up autocmds to use relative numbering, but only in the active window
fun! rnu#enable()
  if exists('&relativenumber')
    set relativenumber
    augroup WindowRNU
      autocmd!
      autocmd BufWinEnter,WinEnter,FocusGained * setlocal number relativenumber
      autocmd BufWinLeave,WinLeave,FocusLost * setlocal number nornu
    augroup END
  endif
endf

" Turn off relative numbering, and disable relative numbering autocmds
fun! rnu#disable()
  if exists('&relativenumber')
    se nornu
  end
  se nu
  sil! au! WindowRNU
endf

" Set up relative numbering. Default is enabled.
fun! rnu#setup()
  if !exists('g:rnu#enabled') || g:rnu#enabled
    call rnu#enable()
  else
    call rnu#disable()
  end
endf
