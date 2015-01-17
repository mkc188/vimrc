" -------- basic initialization --------
let s:is_windows = has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_macvim = has('gui_macvim')

" disable default menus for big boost to gvim startup speed.
" dlso disables toolbars, etc, but menus can be made later in startup
let g:did_install_default_menus = 1
let g:did_install_syntax_menu = 1
" disable mandatory-load stuff from OS packages, sourced early...
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

" -------- plugin manager --------
silent! if plug#begin('~/.vim/plugged')

" core
Plug 'matchit.zip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch', { 'on': ['Dispatch', 'Make', 'Start'] }
Plug 'tpope/vim-eunuch', { 'on': ['Unlink', 'Remove', 'Move', 'Rename', 'Chmod', 'Mkdir', 'SudoEdit', 'SudoWrite'] }
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-obsession', { 'on': 'Obsession' }
Plug 'sheerun/vim-polyglot'

" web
Plug 'rstacruz/sparkup', { 'rtp': 'vim' }
Plug 'jaxbot/browserlink.vim', { 'on': ['BLReloadPage', 'BLReloadCSS'] }

" javascript
Plug 'marijnh/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'coffee', 'ls', 'typescript'] }

" ruby
Plug 'tpope/vim-rails', { 'for': ['ruby', 'rake'] }
Plug 'tpope/vim-bundler', { 'for': ['ruby', 'rake'] }

" python
Plug 'klen/python-mode', { 'for': 'python' }
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

" scala
Plug 'megaannum/vimside', { 'for': 'scala' }

" go
Plug 'nsf/gocode', { 'for': 'go', 'rtp': 'vim' }

" objective-c
Plug 'b4winckler/vim-objc', { 'for': 'objc' }
Plug 'tokorom/xcode-actions.vim', { 'for': ['objc', 'swift'] }

" scm
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }

" autocomplete
if (v:version + has('patch584') >= 704) && has('python')
  Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' ,'on': [] }
endif
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'honza/vim-snippets'

" editing
Plug 'tpope/vim-endwise', { 'for': ['lua', 'ruby', 'sh', 'zsh', 'vb', 'vbnet', 'aspvbs', 'vim', 'c', 'cpp', 'xdefaults'] }
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
Plug 'tpope/vim-rsi'
Plug 'thinca/vim-visualstar'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'mkc188/auto-pairs'
Plug 'ReplaceWithRegister'
Plug 'rhysd/clever-f.vim'

" navigation
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'jeetsukumaran/vim-buffergator', { 'on': ['BuffergatorOpen', 'BuffergatorTabsOpen'] }
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }
Plug 'derekwyatt/vim-fswitch'
Plug 'kshenoy/vim-signature'

" indents
Plug 'sickill/vim-pasta'
Plug 'ciaranm/detectindent', { 'on': 'DetectIndent' }
Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }

" misc
Plug 'guns/xterm-color-table.vim', { 'on': 'XtermColorTable' }
Plug 'scrooloose/syntastic', { 'for': ['ruby', 'c'], 'on': ['SyntasticCheck', 'SyntasticInfo', 'SyntasticReset', 'SyntasticToggleMode'] }
Plug 'KabbAmine/vCoolor.vim'
Plug 'Valloric/ListToggle'
Plug 'Shougo/vinarise.vim', { 'on': 'Vinarise' }
Plug 'mbbill/fencview', { 'on': ['FencAutoDetect', 'FencView'] }
Plug 'fmoralesc/vim-pad', { 'branch': 'devel' , 'on': ['<Plug>(pad-'] }

" colorscheme
Plug 'whatyouhide/vim-gotham'
Plug 'jonathanfilip/vim-lucius'
Plug 'edkolev/tmuxline.vim', { 'on': 'Tmuxline' }

call plug#end()
endif

" -------- functions --------
function! Preserve(command)
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line('.')
  let c = col('.')
  " do the business:
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
function! StripTrailingWhitespace()
  call Preserve("%s/\\s\\+$//e")
endfunction
function! EnsureExists(path)
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path), 'p')
  endif
endfunction

" fzf
function! BufList()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction
function! BufOpen(e)
  execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
endfunction

" -------- base configuration --------
set ttimeout
set timeoutlen=500
set ttimeoutlen=100

set mouse=a
set history=1000
set viewoptions=folds,options,cursor,unix,slash
set encoding=utf-8
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
set hidden
set autoread
set fileformats=unix,dos,mac
set nrformats-=octal
set showcmd
setglobal tags=./tags;
set nomodeline
set complete-=i
set completeopt=menu,menuone,longest
set tabpagemax=50
set sessionoptions-=options
set virtualedit=block
if v:version + has('patch541') >= 704
  set formatoptions+=j
endif
set nojoinspaces
set nostartofline
set noshelltemp

if s:is_windows && !s:is_cygwin
  " ensure correct shell in gvim
  set shell=c:\windows\system32\cmd.exe
endif

" whitespace
set backspace=indent,eol,start
set autoindent
set expandtab
set smarttab
set softtabstop=2
set shiftwidth=2
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
set wildmode=longest:full,full

set splitbelow
set splitright

" disable sounds
set visualbell
set t_vb=

" searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault

" vim file/folder management
if exists('+undofile')
  set undofile
  set undodir=~/.vim/.cache/undo
  call EnsureExists(&undodir)
endif
set backup
set backupdir=~/.vim/.cache/backup
set noswapfile
set directory=~/.vim/.cache/swap
call EnsureExists(&backupdir)
call EnsureExists(&directory)

if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif

let g:mapleader = ','

" -------- ui configuration --------
set showmatch
set matchtime=2
set number
set showtabline=0
set nofoldenable
set foldmethod=indent
set foldlevel=20
set synmaxcol=200
syntax sync minlines=256
set ttyfast
set ttyscroll=3
set lazyredraw

if has('statusline') && !&cp
  set laststatus=2
  set statusline=%t\ %m%r%{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %3p%%,%v\ %<%=
  set statusline+=%{&tabstop}:%{&shiftwidth}:%{&softtabstop}:%{&expandtab?'et':'noet'}
  set statusline+=\|%{&fileformat}
  set statusline+=\|%{strlen(&fenc)?&fenc:&enc}
  set statusline+=\|%{strlen(&filetype)?&filetype:'None'}
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
else
  " disable background color erase
  set t_ut=
endif

" -------- plugin configuration --------
" python-mode
let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_syntax = 0
let g:pymode_run_bind = '<leader>pr'
let g:pymode_breakpoint_bind = '<leader>pb'
" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0
" vim-signify
let g:signify_update_on_bufenter = 0
" ack.vim
if executable('ag')
  let g:ackprg = 'ag -U --silent --nogroup --nocolor'
endif
let g:ack_use_dispatch = 1
" undotree
let g:undotree_SetFocusWhenToggle = 1
" vim-filebeagle
let g:filebeagle_suppress_keymaps = 1
" vim-buffergator
let g:buffergator_suppress_keymaps = 1
let g:buffergator_autoexpand_on_split = 0
" detectindent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4
" vim-objc
let c_no_curly_error = 1
" vim-rsi
let g:rsi_no_meta = 1
" gitv
let g:Gitv_DoNotMapCtrlKey = 1
" YouCompleteMe
let g:ycm_path_to_python_interpreter = '/usr/bin/python'
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
" ultisnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" eclim
let g:EclimMenus = 0
let g:EclimCompletionMethod = 'omnifunc'
" ListToggle
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
" sparkup
let g:sparkupExecuteMapping = '<C-z>'
let g:sparkupNextMapping = '<C-l>'
" tmuxline.vim
let g:tmuxline_powerline_separators = 0
" browserlink.vim
let g:bl_no_mappings = 1
" vim-signature
let g:SignatureEnabledAtStartup = 0
" vim-pad
let g:pad#dir = '~/Dropbox/notes/'
let g:pad#set_mappings = 0

" -------- mappings --------
" formatting shortcuts
nmap <leader>fef :call Preserve("normal gg=G")<CR>
nmap <leader>f$ :call StripTrailingWhitespace()<CR>
xmap <leader>s :sort<cr>

" remap arrow keys
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

" smash escape
inoremap jk <esc>

" recover from accidental Ctrl-U
inoremap <C-u> <C-g>u<C-u>

" sane regex
nnoremap / /\v
xnoremap / /\v
nnoremap ? ?\v
xnoremap ? ?\v
nnoremap :s/ :s/\v

" screen line scroll
nnoremap <silent> j gj
nnoremap <silent> k gk

" auto center
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz

" reselect visual block after indent
xnoremap < <gv
xnoremap > >gv

" reselect last paste
nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'

" shortcuts for windows
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" tab shortcuts
map <leader>tn :tabnew<CR>
map <leader>tc :tabclose<CR>

" make Y consistent with C and D. See :help Y.
nnoremap Y y$

" hide annoying quit message
nnoremap <C-c> <C-c>:echo<cr>

" fix meta-keys which generate <Esc>a .. <Esc>z
for i in range(97,122)
  let c = nr2char(i)
  exec "map \e".c." <M-".c.">"
  exec "map! \e".c." <M-".c.">"
endfor

" use option (alt) as meta key
if s:is_macvim
  set macmeta
endif

" map space to colon
noremap <space> :

" delete character to black hole register
nnoremap x "_x
xnoremap x "_x

" vim-unimpaired
nmap <M-k> [e
nmap <M-j> ]e
xmap <M-k> [egv
xmap <M-j> ]egv
" vim-fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>
" gitv
nnoremap <silent> <leader>gv :Gitv<CR>
nnoremap <silent> <leader>gV :Gitv!<CR>
" vim-commentary
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
" tabular
nmap <Leader>a& :Tabularize /&<CR>
xmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
xmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
xmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
xmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
xmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
xmap <Leader>a<Bar> :Tabularize /<Bar><CR>
" undotree
nnoremap <silent> <F5> :UndotreeToggle<CR>
" tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>
" vim-filebeagle
map <silent> \ <Plug>FileBeagleOpenCurrentWorkingDir
map <silent> - <Plug>FileBeagleOpenCurrentBufferDir
" vim-buffergator
nnoremap <silent> <leader>b :BuffergatorOpen<CR>
nnoremap <silent> <leader>to :BuffergatorTabsOpen<CR>
" detectindent
nnoremap <silent> <leader>di :DetectIndent<CR>
" vim-dispatch
nnoremap <leader>tag :Dispatch ctags -R<cr>
" fzf
nnoremap <silent> <leader>ff :FZF -m<CR>
nnoremap <silent> <leader>fb :call fzf#run({
      \   'source':      reverse(BufList()),
      \   'sink':        function('BufOpen'),
      \   'options':     '+m',
      \   'tmux_height': '40%'
      \ })<CR>
nnoremap <silent> <leader>fm :FZFMru<CR>
" vim-fswitch
nmap <silent> <leader>of :FSHere<CR>
" xcode-actions.vim
nmap <silent> <leader>xb <Plug>(xcode-actions-build)
nmap <silent> <leader>xr <Plug>(xcode-actions-run)
nmap <silent> <leader>xc <Plug>(xcode-actions-clean)
nmap <silent> <leader>xt <Plug>(xcode-actions-test)
nmap <silent> <leader>xo <Plug>(xcode-actions-openfile)
" vim-pad
nmap <silent> <leader>nl <Plug>(pad-list)
nmap <silent> <leader>nn <Plug>(pad-new)
nmap <silent> <leader>ns <Plug>(pad-search)

" -------- commands --------
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
command! FZFMru call fzf#run({
      \'source': v:oldfiles,
      \'sink' : 'e ',
      \'options' : '-m',
      \})

" -------- autocmd --------
if has('autocmd')
  filetype plugin indent on

  augroup global_settings
    autocmd!
    " automatically resize splits when resizing MacVim window
    autocmd VimResized * wincmd =
    " go back to previous position of cursor if any
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe 'normal! g`"zvzz' |
          \ endif
    " disable beeping in gvim
    autocmd GUIEnter * set visualbell t_vb=
  augroup END

  augroup filetype_settings
    autocmd!
    autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
    autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
    autocmd FileType vim setlocal keywordprg=:help
  augroup END

  if !empty(glob('~/.vim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so'))
    augroup load_us_ycm
      autocmd!
      autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
            \| call youcompleteme#Enable() | autocmd! load_us_ycm
    augroup END
  endif
endif

" -------- color schemes --------
syntax enable
if !empty(glob('~/.vim/plugged/vim-gotham'))
  colorscheme gotham
endif
