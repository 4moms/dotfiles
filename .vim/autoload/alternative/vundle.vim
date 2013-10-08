" vundle#rc() with better default directories
fun! alternative#vundle#rc(...)
  " With any arguments, just call the original with those args
  if a:0
    return call('vundle#rc', copy(a:000))
  end

  " Use this directory if the normal ~/.vim/bundle isn't writable
  let alt_dir = exists('alternative#vundle#dir')
    \ ? alternative#vundle#dir
    \ : expand('~/alt-vim-bundle')

  " If the alt dir already exists and is writable, use it
  if isdirectory(alt_dir) && filewritable(alt_dir) == 2
    let vundle_dir = alt_dir
  else
    " Use the normal vundle dir by default
    let vundle_dir = expand('$HOME/.vim/bundle', 1)

    " If it's not there and its parent isn't writable, use the alt
    let parent = fnamemodify(vundle_dir, ':p:h')
    if !isdirectory(vundle_dir) && filewritable(parent) != 2
      let vundle_dir = alt_dir
    end
  end

  " If the chosen dir isn't there, and we can create it, do
  if !isdirectory(vundle_dir) && exists('*mkdir')
    call mkdir(vundle_dir)
  end

  " Call the original vundle#rc with the chosen dir
  return vundle#rc(vundle_dir)
endf
