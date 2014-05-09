silent function! OS()
  if has('win16') || has('win32') || has('win64')
    return 'win'
  elseif has('unix') && system('uname')=~'Darwin'
    return 'mac'
  else
    return 'linux'
  endif
endfunction

if OS() == 'mac'
  set guifont=Source\ Code\ Pro:h14
elseif OS() == 'win'
  set guifont=Source\ Code\ Pro:h11
endif
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

if has("gui_running")
  if has("autocmd")
    " Automatically resize splits when resizing MacVim window
    autocmd VimResized * wincmd =
  endif
endif
