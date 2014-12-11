" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

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
let g:loaded_netrwPlugin = 1
let loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_zipPlugin = 1
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

" web
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'cakebaker/scss-syntax.vim', { 'for': ['scss', 'sass'] }
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss', 'sass'] }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'wavded/vim-stylus', { 'for': 'styl' }
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }
Plug 'juvenn/mustache.vim', { 'for': 'mustache' }
Plug 'mattn/emmet-vim', { 'for': ['html', 'xml', 'xsl', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less', 'mustache'] }

" javascript
Plug 'marijnh/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'maksimr/vim-jsbeautify', { 'for': 'javascript' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'mmalecki/vim-node.js', { 'for': 'javascript' }
Plug 'leshill/vim-json', { 'for': ['javascript', 'json'] }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'coffee', 'ls', 'typescript'] }

" ruby
Plug 'tpope/vim-rails', { 'for': ['ruby', 'rake'] }
Plug 'tpope/vim-bundler', { 'for': ['ruby', 'rake'] }

" python
Plug 'klen/python-mode', { 'for': 'python' }
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

" scala
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'megaannum/vimside', { 'for': 'scala' }

" go
Plug 'jnwhiteh/vim-golang', { 'for': 'go' }
Plug 'nsf/gocode', { 'for': 'go', 'rtp': 'vim' }

" markdown
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
if executable('redcarpet') && executable('instant-markdown-d')
  Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
endif

" objective-c
Plug 'b4winckler/vim-objc', { 'for': 'objc' }
Plug 'Keithbsmiley/swift.vim', { 'for': 'swift' }

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
Plug 'tpope/vim-speeddating'
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
Plug 'jeetsukumaran/vim-buffergator'
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }

" indents
Plug 'sickill/vim-pasta'
Plug 'ciaranm/detectindent', { 'on': 'DetectIndent' }

" misc
Plug 'mhinz/vim-startify'
Plug 'guns/xterm-color-table.vim', { 'on': 'XtermColorTable' }
Plug 'scrooloose/syntastic', { 'for': ['ruby', 'c'], 'on': ['SyntasticCheck', 'SyntasticInfo', 'SyntasticReset', 'SyntasticToggleMode'] }
Plug 'KabbAmine/vCoolor.vim'

" colorscheme
Plug 'w0ng/vim-hybrid'

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

" enable mouse
set mouse=a
" number of command lines to remember
set history=1000
" unix/windows compatibility
set viewoptions=folds,options,cursor,unix,slash
" set encoding for text
set encoding=utf-8
" sync with OS clipboard
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
" allow buffer switching without saving
set hidden
" auto reload if file saved externally
set autoread
" always assume decimal numbers
set nrformats-=octal
set showcmd
set tags=tags;/
set showfulltag
set modeline
set modelines=2
" searching includes can be slow
set complete-=i
set completeopt-=preview
set completeopt+=longest
set tabpagemax=50
set sessionoptions-=options

if s:is_windows && !s:is_cygwin
  " ensure correct shell in gvim
  set shell=c:\windows\system32\cmd.exe
endif

" use pipes
set noshelltemp

" whitespace
" allow backspacing everything in insert mode
set backspace=indent,eol,start
" automatically indent to match adjacent lines
set autoindent
" spaces instead of tabs
set expandtab
" use shiftwidth to enter tabs
set smarttab
" number of spaces per tab in insert mode
set softtabstop=2
" number of spaces when indenting
set shiftwidth=2
set listchars=tab:>-,trail:-,eol:<,nbsp:%,extends:>,precedes:<
set shiftround
set linebreak
if exists('+breakindent')
  set breakindent
  set showbreak=\ +
endif

" always show content after scroll
set scrolloff=1
set sidescrolloff=5
set sidescroll=1
set display+=lastline
" show list for autocomplete
set wildmenu
set wildmode=list:full
set wildignorecase

set splitbelow
set splitright

" disable sounds
set noerrorbells
set novisualbell
set t_vb=

" searching
" highlight searches
set hlsearch
" incremental searching
set incsearch
" ignore case for searching
set ignorecase
" do case-sensitive if there's a capital letter
set smartcase
" add the g flag to search/replace by default
set gdefault

" vim file/folder management
" persistent undo
if exists('+undofile')
  set undofile
  set undodir=~/.vim/.cache/undo
endif

" backups
set backup
set backupdir=~/.vim/.cache/backup

" swap files
set noswapfile
set directory=~/.vim/.cache/swap

call EnsureExists(&undodir)
call EnsureExists(&backupdir)
call EnsureExists(&directory)

let mapleader = ','
let g:mapleader = ','

" -------- ui configuration --------
" automatically highlight matching braces/brackets/etc.
set showmatch
" tens of a second to show matching parentheses
set matchtime=2
set number
set showtabline=0
" folds are created manually
set foldmethod=manual
" speedup vim
set synmaxcol=200
syntax sync minlines=256
set ttyfast
set ttyscroll=3
set lazyredraw

if has('statusline') && !&cp
  set laststatus=2
  set statusline=%f\ %m\ %r
  set statusline+=[#%n]
  set statusline+=[%l/%L]
  set statusline+=[%v]
  set statusline+=[%b][0x%B]
  " vim-fugitive
  set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
endif

if has('conceal')
  set conceallevel=1
endif

if has('gui_running')
  set guioptions=

  if s:is_macvim
    set guifont=Source\ Code\ Pro\ Light:h13
  elseif s:is_windows
    set guifont=Source\ Code\ Pro:h10
  elseif has('gui_gtk')
    set guifont=Source\ Code\ Pro\ 10
  endif
else
  if $COLORTERM == 'gnome-terminal'
    set t_Co=256
  endif
  " disable background color erase
  set t_ut=
endif

" -------- plugin configuration --------
" python-mode
let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_syntax = 0
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
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
" vim-buffergator
let g:buffergator_suppress_keymaps = 1
" detectindent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4
" vim-startify
let g:startify_session_dir = expand('~/.vim/.cache/sessions')
let g:startify_change_to_vcs_root = 1
let g:startify_show_sessions = 1
" vim-objc
let c_no_curly_error = 1
" vim-rsi
let g:rsi_no_meta = 1
" gitv
let g:Gitv_DoNotMapCtrlKey = 1
" YouCompleteMe
let g:ycm_path_to_python_interpreter = '/usr/bin/python'
" ultisnips
let g:UltiSnipsExpandTrigger = '<C-j>'
" emmet-vim
let g:user_emmet_leader_key = '<C-k>'
" eclim
let g:EclimMenus = 0
let g:EclimCompletionMethod = 'omnifunc'

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
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

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

" map semicolon to colon
map ; :
nnoremap ;; ;

" delete character to black hole register
nnoremap x "_x
xnoremap x "_x

" vim-jsbeautify
nnoremap <leader>fjs :call JsBeautify()<cr>
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
map <silent> <space>f <Plug>FileBeagleOpenCurrentWorkingDir
map <silent> - <Plug>FileBeagleOpenCurrentBufferDir
" vim-buffergator
nnoremap <silent> \b :BuffergatorOpen<CR>
nnoremap <silent> \t :BuffergatorTabsOpen<CR>
" detectindent
nnoremap <silent> <leader>di :DetectIndent<CR>
" vim-startify
nnoremap <F1> :Startify<cr>
" vim-dispatch
nnoremap <leader>tag :Dispatch ctags -R<cr>
" fzf
nnoremap <silent> <space><space> :FZF -m<CR>
nnoremap <silent> <space>b :call fzf#run({
      \   'source':      reverse(BufList()),
      \   'sink':        function('BufOpen'),
      \   'options':     '+m',
      \   'tmux_height': '40%'
      \ })<CR>

" -------- commands --------
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis

" -------- autocmd --------
if has('autocmd')
  augroup global_settings
    autocmd!
    " automatically resize splits when resizing MacVim window
    autocmd VimResized * wincmd =
    " go back to previous position of cursor if any
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \  exe 'normal! g`"zvzz' |
          \ endif
  augroup END

  augroup filetype_settings
    autocmd!
    autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
    autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType markdown setlocal nolist
    autocmd FileType vim setlocal fdm=indent keywordprg=:help
  augroup END

  augroup load_us_ycm
    autocmd!
    autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
          \| call youcompleteme#Enable() | autocmd! load_us_ycm
  augroup END
endif

" -------- color schemes --------
if !empty(glob('~/.vim/plugged/vim-hybrid'))
  colorscheme hybrid
endif
