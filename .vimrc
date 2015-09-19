" -------- basic initialization --------
let s:is_windows = has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_macvim = has('gui_macvim')

let g:did_install_default_menus = 1
let g:did_install_syntax_menu = 1
let g:loaded_vimballPlugin = 1
let g:loaded_vimball = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_tar = 1
let g:loaded_zipPlugin = 1
let g:loaded_zip = 1
let loaded_gzip = 1
let g:loaded_2html_plugin = 1
let g:loaded_matchparen = 1
let loaded_remote_plugins = 1
let loaded_rrhelper = 1
let g:mapleader = ','

" -------- plugin manager --------
silent! if plug#begin('~/.vim/plugged')

Plug 'matchit.zip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch', { 'on': ['Dispatch', 'Make', 'Start'] }
Plug 'tpope/vim-obsession', { 'on': 'Obsession' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rsi'
let g:rsi_no_meta = 1
Plug 'thinca/vim-visualstar'
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr = 1
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor'
endif
let g:ack_use_dispatch = 1
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
let g:undotree_SetFocusWhenToggle = 1
nnoremap <silent> <F5> :UndotreeToggle<CR>
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
let g:tagbar_autofocus = 1
nnoremap <silent> <F9> :TagbarToggle<CR>
Plug 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_suppress_keymaps = 1
nmap <silent> - <Plug>FileBeagleOpenCurrentBufferDir
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction
function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction
nnoremap <silent> <Leader>f :FZF -m<CR>
nnoremap <silent> <Leader>b :call fzf#run({
      \   'source':  reverse(<sid>buflist()),
      \   'sink':    function('<sid>bufopen'),
      \   'options': '+m',
      \   'down':    len(<sid>buflist()) + 2
      \ })<CR>
Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }
Plug 'KabbAmine/vCoolor.vim'
Plug 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<Leader>l'
let g:lt_quickfix_list_toggle_map = '<Leader>q'
Plug 'mbbill/fencview', { 'on': ['FencAutoDetect', 'FencView'] }
Plug 'christoomey/vim-tmux-navigator'
Plug 'romainl/Apprentice'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
nnoremap gs :Sayonara<CR>
nnoremap gS :Sayonara!<CR>
Plug 't9md/vim-smalls', { 'on': '<Plug>(smalls)' }
nmap s <Plug>(smalls)
xmap s <Plug>(smalls)
let g:smalls_shade = 0
let g:smalls_jump_trigger = '\'
let g:smalls_blink_on_notfound = 0
let g:smalls_exit_at_notfound = 1
let g:smalls_auto_jump = 1
let g:smalls_auto_jump_min_input_length = 2
let g:smalls_auto_jump_timeout = 0.0
Plug 'justinmk/vim-gtfo'
Plug 'tpope/vim-sleuth'
Plug 'kana/vim-fakeclip'
let g:fakeclip_no_default_key_mappings = 1
xmap <Leader>y <Plug>(fakeclip-screen-y)
nmap <Leader>p <Plug>(fakeclip-screen-p)
nmap <Leader>P <Plug>(fakeclip-screen-P)

call plug#end()
endif

" -------- base configuration --------
set ttimeoutlen=10
set mouse=nvi
set history=1000
set encoding=utf-8
set hidden
set autoread
set fileformats=unix,dos,mac
set nrformats-=octal
set showcmd
setglobal tags=./tags;
set nomodeline
set complete-=wbuUi
set completeopt=menu,menuone,longest
set tabpagemax=50
set sessionoptions-=options
set virtualedit=block
if v:version + has('patch541') >= 704
  set formatoptions+=j
endif
set nojoinspaces
set noshelltemp
if s:is_macvim
  set macmeta
endif
if s:is_windows && !s:is_cygwin
  set shell=c:\windows\system32\cmd.exe
endif
set backspace=indent,eol,start
set autoindent
set smarttab
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set shiftround
set linebreak
if exists('+breakindent')
  set breakindent
  set showbreak=\ +
endif
set scrolloff=1
set sidescrolloff=5
set sidescroll=1
set display+=lastline
set wildmenu
set wildmode=longest,full
set splitbelow
set splitright
set visualbell
set t_vb=
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
set noswapfile
if exists('+undofile')
  set undofile
  set undodir=~/tmp,~/,.
endif
if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif

" -------- ui configuration --------
set showtabline=0
set nofoldenable
set synmaxcol=200
syntax sync minlines=256
set lazyredraw
if has('statusline') && !&cp
  set laststatus=2
  set statusline=%t\ %m%r%{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %l,%v\ %<%=
  set statusline+=%{&tabstop}:%{&shiftwidth}:%{&softtabstop}:%{&expandtab?'et':'noet'}
  set statusline+=\ %{&fileformat}
  set statusline+=\ %{strlen(&filetype)?&filetype:'None'}
endif
if has('gui_running')
  set guioptions=
  if s:is_macvim
    set guifont=Fira\ Mono:h13
  elseif s:is_windows
    set guifont=Fira\ Mono:h10
  elseif has('gui_gtk')
    set guifont=Fira\ Mono\ 10
  endif
endif

" -------- mappings --------
inoremap <C-U> <C-G>u<C-U>

nnoremap <silent> <BS> :nohlsearch<CR><BS>
noremap <Space> :
noremap \ ,
inoremap <C-C> <Esc>
nnoremap <Tab> <C-^>
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

nnoremap x "_x
xnoremap x "_x

nnoremap Y y$
xnoremap Y "+y
noremap H ^
noremap L $
xnoremap L g_
nnoremap p p`[v`]=
nnoremap P P`[v`]=
nnoremap Q @q

nnoremap <Left> :bprev<CR>
nnoremap <Right> :bnext<CR>
nnoremap <Up> :tabnext<CR>
nnoremap <Down> :tabprev<CR>

" -------- autocmd --------
if has('autocmd')
  filetype plugin indent on

  augroup global_settings
    autocmd!
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe 'normal! g`"zvzz' |
          \ endif
    autocmd GUIEnter * set visualbell t_vb=
    autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
  augroup END

  augroup filetype_settings
    autocmd!
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType tmux setlocal commentstring=#\ %s
    autocmd FileType cpp setlocal commentstring=//\ %s
  augroup END
endif

" -------- color schemes --------
syntax enable
if !empty(glob('~/.vim/plugged/Apprentice'))
  colorscheme apprentice
endif
