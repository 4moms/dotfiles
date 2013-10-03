" Prepare driver settings for first use
fun! driver#setup_rtp()
  if !exists('s:inited')
    let s:inited = 0
  end
  if !s:inited
    " Add some directories to &runtimepath
    if exists('$DRIVERS_DIR')
      se rtp^=$DRIVERS_DIR
    elseif exists('$DOTFILES')
      se rtp^=$DOTFILES/drivers
    end
    if exists('$DOTFILES')
      se rtp^=$DOTFILES
    end
  end
  let s:inited = 1
endf

" Set up driver-specific settings
" driver id (e.g. bhaskell), is pulled from $DRIVER if not passed
fun! driver#setup(...)
  call driver#setup_rtp()

  " Driver = first arg, if passed, otherwise DRIVER env var
  let g:driver = a:0 ? a:1 : exists('$DRIVER') ? $DRIVER : ''
  if !strlen(g:driver)
    return
  end

  exe 'run! driver-'.g:driver.'.vim'
endf
