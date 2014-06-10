" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

" -------- detect OS --------
let s:is_windows = has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_macvim = has('gui_macvim')

" -------- detect cpuinfo --------
let g:slow_mode = 0
let s:cpu_list = []
call add(s:cpu_list, 'ARMv6-compatible processor rev 7')  " Raspberry Pi
if filereadable('/proc/cpuinfo')
  for cpu in s:cpu_list
    let g:slow_mode = system('grep -c "'.cpu.'" /proc/cpuinfo')
    if g:slow_mode
      break
    endif
  endfor
endif

" -------- setup & neobundle --------
if has('vim_starting')
set nocompatible               " Be iMproved

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

call neobundle#end()

" -------- functions --------
function! Preserve(command)
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
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
    call mkdir(expand(a:path))
  endif
endfunction
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction

" -------- base configuration --------
set timeoutlen=300                                  "mapping timeout
set ttimeoutlen=50                                  "keycode timeout

set mouse=a                                         "enable mouse
set history=1000                                    "number of command lines to remember
set ttyfast                                         "assume fast terminal connection
set viewoptions=folds,options,cursor,unix,slash     "unix/windows compatibility
set encoding=utf-8                                  "set encoding for text
if exists('$TMUX')
  set clipboard=
elseif has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed                             "sync with OS clipboard
endif
set hidden                                          "allow buffer switching without saving
set autoread                                        "auto reload if file saved externally
set fileformats+=mac                                "add mac to auto-detection of file format line endings
set nrformats-=octal                                "always assume decimal numbers
set showcmd
set tags=tags;/
set showfulltag
set modeline
set modelines=2

if s:is_windows && !s:is_cygwin
  " ensure correct shell in gvim
  set shell=c:\windows\system32\cmd.exe
endif

" whitespace
set backspace=indent,eol,start                      "allow backspacing everything in insert mode
set autoindent                                      "automatically indent to match adjacent lines
set expandtab                                       "spaces instead of tabs
set smarttab                                        "use shiftwidth to enter tabs
set tabstop=2                                       "number of spaces per tab for display
set softtabstop=2                                   "number of spaces per tab in insert mode
set shiftwidth=2                                    "number of spaces when indenting
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:>,precedes:<
set shiftround
set linebreak

set scrolloff=1                                     "always show content after scroll
set display+=lastline
set wildmenu                                        "show list for autocomplete
set wildmode=list:full
set wildignorecase
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store

set splitbelow
set splitright

" disable sounds
set noerrorbells
set novisualbell
set t_vb=

" searching
set hlsearch                                        "highlight searches
set incsearch                                       "incremental searching
set ignorecase                                      "ignore case for searching
set smartcase                                       "do case-sensitive if there's a capital letter
set gdefault                                        "add the g flag to search/replace by default
if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('ack')
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m
endif

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
set swapfile
set directory=~/.vim/.cache/swap

call EnsureExists('~/.vim/.cache')
call EnsureExists(&undodir)
call EnsureExists(&backupdir)
call EnsureExists(&directory)

let mapleader = ","
let g:mapleader = ","

let g:netrw_home=expand('~/.vim/.cache')

" -------- ui configuration --------
set showmatch                                       "automatically highlight matching braces/brackets/etc.
set matchtime=2                                     "tens of a second to show matching parentheses
set number
set lazyredraw
set showtabline=0
set foldmethod=syntax                               "fold via syntax of files
set foldlevelstart=99                               "open all folds by default
let g:xml_syntax_folding=1                          "enable xml folding

autocmd VimResized * wincmd =                       " automatically resize splits when resizing MacVim window

if has("statusline") && !&cp
  set laststatus=2
  set statusline=%f\ %m\ %r
  set statusline+=[#%n]
  set statusline+=[%l/%L]
  set statusline+=[%p%%]
  set statusline+=[%v]
  set statusline+=[%b][0x%B]
endif

if has('conceal')
  set conceallevel=1
endif

if has('gui_running')
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=b
  set guioptions-=L

  if s:is_macvim
    set guifont=Source\ Code\ Pro:h14
  elseif s:is_windows
    set guifont=Source\ Code\ Pro:h10
  endif
else
  if $COLORTERM == 'gnome-terminal'
    set t_Co=256 "why you no tell me correct colors?!?!
  endif
  if $TERM_PROGRAM == 'iTerm.app'
    " different cursors for insert vs normal mode
    if exists('$TMUX')
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
  endif
  " disable background color erase
  set t_ut=
endif

" -------- plugin configuration --------
" core
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
  nmap <M-k> [e
  nmap <M-j> ]e
  vmap <M-k> [egv
  vmap <M-j> ]egv
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundleLazy 'matchit.zip', { 'autoload' : {
      \ 'mappings' : ['%', 'g%']
      \ }}
  let bundle = neobundle#get('matchit.zip')
  function! bundle.hooks.on_post_source(bundle)
    silent! execute 'doautocmd Filetype' &filetype
  endfunction
NeoBundleLazy 'tpope/vim-repeat', {
      \ 'mappings' : '.',
      \ }
NeoBundleLazy 'tpope/vim-dispatch', {
      \ 'autoload': { 'commands': ['Dispatch', 'Make', 'Start'] }
      \ }
NeoBundleLazy 'tpope/vim-eunuch', {
      \   'autoload' : {
      \     'commands' : ['Unlink', 'Remove', 'Move', 'Rename',
      \                   'Chmod', 'Mkdir', 'SudoEdit', 'SudoWrite'],
      \   }
      \ }

" web
NeoBundleLazy 'groenewege/vim-less', {'autoload':{'filetypes':['less']}}
NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss','sass']}}
NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':{'filetypes':['css','scss','sass']}}
NeoBundleLazy 'ap/vim-css-color', {'autoload':{'filetypes':['css','scss','sass','less','styl']}}
NeoBundleLazy 'othree/html5.vim', {'autoload':{'filetypes':['html']}}
NeoBundleLazy 'wavded/vim-stylus', {'autoload':{'filetypes':['styl']}}
NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}
NeoBundleLazy 'juvenn/mustache.vim', {'autoload':{'filetypes':['mustache']}}
NeoBundleLazy 'gregsexton/MatchTag', {'autoload':{'filetypes':['html','xml']}}
NeoBundleLazy 'mattn/emmet-vim', {'autoload':{'filetypes':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}}
  function! s:zen_html_tab()
    let line = getline('.')
    if match(line, '<.*>') < 0
      return "\<c-y>,"
    endif
    return "\<c-y>n"
  endfunction
  autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><tab> <c-y>,
  autocmd FileType html imap <buffer><expr><tab> <sid>zen_html_tab()

" javascript
NeoBundleLazy 'marijnh/tern_for_vim', {
      \ 'autoload': { 'filetypes': ['javascript'] },
      \ 'build': {
        \ 'mac': 'npm install',
        \ 'unix': 'npm install',
        \ 'cygwin': 'npm install',
        \ 'windows': 'npm install',
      \ },
    \ }
NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}
NeoBundleLazy 'maksimr/vim-jsbeautify', {'autoload':{'filetypes':['javascript']}}
  nnoremap <leader>fjs :call JsBeautify()<cr>
NeoBundleLazy 'leafgarland/typescript-vim', {'autoload':{'filetypes':['typescript']}}
NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee']}}
NeoBundleLazy 'mmalecki/vim-node.js', {'autoload':{'filetypes':['javascript']}}
NeoBundleLazy 'leshill/vim-json', {'autoload':{'filetypes':['javascript','json']}}
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','typescript']}}

" ruby
NeoBundleLazy 'tpope/vim-rails', {'autoload': {'filetypes': ['ruby', 'rake']}}
NeoBundleLazy 'tpope/vim-bundler', {'autoload': {'filetypes': ['ruby', 'rake']}}

" python
NeoBundleLazy 'klen/python-mode', {'autoload':{'filetypes':['python']}}
  let g:pymode_rope=0
NeoBundleLazy 'davidhalter/jedi-vim', {'autoload':{'filetypes':['python']}}
  let g:jedi#popup_on_dot=0

" scala
NeoBundleLazy 'derekwyatt/vim-scala', {'autoload': {'filetypes': ['scala']}}
NeoBundleLazy 'megaannum/vimside', {'autoload': {'filetypes': ['scala']}}

" go
NeoBundleLazy 'jnwhiteh/vim-golang', {'autoload':{'filetypes':['go']}}
NeoBundleLazy 'nsf/gocode', {'autoload': {'filetypes':['go']}, 'rtp': 'vim'}

" markdown
NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
if executable('redcarpet') && executable('instant-markdown-d')
  NeoBundleLazy 'suan/vim-instant-markdown', {'autoload':{'filetypes':['markdown']}}
endif

" scm
if !g:slow_mode
  NeoBundle 'mhinz/vim-signify'
    let g:signify_update_on_bufenter=0
  if executable('hg')
    NeoBundle 'bitbucket:ludovicchabant/vim-lawrencium'
  endif
  NeoBundle 'tpope/vim-fugitive'
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>gr :Gremove<CR>
    autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
    autocmd BufReadPost fugitive://* set bufhidden=delete
    set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
  NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'autoload':{'commands':'Gitv'}}
    nnoremap <silent> <leader>gv :Gitv<CR>
    nnoremap <silent> <leader>gV :Gitv!<CR>
endif

" autocomplete
if !g:slow_mode
  NeoBundleLazy 'honza/vim-snippets'
  NeoBundleLazy 'Shougo/neosnippet-snippets'
  NeoBundleLazy 'Shougo/neosnippet.vim', { 'depends' : ['honza/vim-snippets', 'Shougo/neosnippet-snippets'], 'autoload' : { 'insert' : '1', 'unite_sources' : ['neosnippet/runtime', 'neosnippet/user', 'snippet']} }
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
    let g:neosnippet#enable_snipmate_compatibility=1
    let g:neosnippet_data_directory=expand('~/.vim/.cache/neosnippet')

    imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<TAB>")
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""

  if has('lua') && ( version > 703 || version == 703 && has('patch885') )
    NeoBundleLazy 'Shougo/neocomplete.vim', {'autoload':{'insert':1}, 'vim_version':'7.3.885'}
      let g:neocomplete#enable_at_startup=1
      let g:neocomplete#data_directory=expand('~/.vim/.cache/neocomplete')
  else
    NeoBundleLazy 'Shougo/neocomplcache.vim', {'autoload':{'insert':1}}
      let g:neocomplcache_enable_at_startup=1
      let g:neocomplcache_temporary_dir=expand('~/.vim/.cache/neocomplcache')
      let g:neocomplcache_enable_fuzzy_completion=1
  endif
endif

" editing
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'mkc188/auto-pairs'
NeoBundle 'justinmk/vim-sneak'
  let g:sneak#streak = 1
  hi link SneakPluginTarget Search
  hi link SneakPluginScope Search
  hi link SneakStreakTarget Search
  hi SneakStreakMask guifg=yellow guibg=yellow ctermfg=yellow ctermbg=yellow
NeoBundleLazy 'chrisbra/NrrwRgn', {
      \ 'autoload' : {
      \   'commands' : [
      \     'NR',
      \     'NarrowRegion',
      \     'NW',
      \     'NarrowWindow',
      \   ]},
      \ }
NeoBundleLazy 'tpope/vim-endwise', {'autoload':{'filetypes':['lua','ruby','sh','zsh','vb','vbnet','aspvbs','vim','c','cpp','xdefaults']}}
NeoBundleLazy 'tpope/vim-speeddating'
NeoBundleLazy 'thinca/vim-visualstar', {
      \   'autoload': {
      \     'mappings': [
      \       ['xv', '*'], ['xv', '#'], ['xv', 'g'], ['xv', 'g*']
      \     ]
      \   }
      \ }
NeoBundleLazy 'tomtom/tcomment_vim', {
      \ 'autoload': {
      \   'mappings': [['nx', 'gc', 'gcc', 'gC']]
      \ }
      \}
NeoBundleLazy 'terryma/vim-expand-region', { 'autoload' : { 'mappings' : [ [ 'ov', '+' ], [ 'ov', '_' ] ] } }
NeoBundleLazy 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}}
  nmap <Leader>a& :Tabularize /&<CR>
  vmap <Leader>a& :Tabularize /&<CR>
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:<CR>
  vmap <Leader>a: :Tabularize /:<CR>
  nmap <Leader>a:: :Tabularize /:\zs<CR>
  vmap <Leader>a:: :Tabularize /:\zs<CR>
  nmap <Leader>a, :Tabularize /,<CR>
  vmap <Leader>a, :Tabularize /,<CR>
  nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
  vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

" navigation
if !g:slow_mode
  NeoBundleLazy 'Shougo/vimfiler.vim', {
        \  'autoload': {'commands': [
        \                  'VimFiler',
        \                  'VimFilerExplorer',
        \                  'VimFilerBufferDir',
        \              ]},
        \  'depends': ['Shougo/unite.vim', 'Shougo/vimproc.vim']
        \}
    let g:vimfiler_as_default_explorer=1
    let g:vimfiler_safe_mode_by_default = 0
    let g:vimfiler_data_directory=expand('~/.vim/.cache/vimfiler')
    nnoremap <F2> :VimFilerExplorer<CR>
    nnoremap <F3> :VimFilerBufferDir -quit<CR>
endif
NeoBundleLazy 'mileszs/ack.vim', { 'autoload' : {'commands': 'Ack'}}
  if executable('ag')
    let g:ackprg = "ag --nogroup --column --smart-case --follow"
  endif
NeoBundleLazy 'mbbill/undotree', {'autoload':{'commands':'UndotreeToggle'}}
  let g:undotree_SplitLocation='botright'
  let g:undotree_SetFocusWhenToggle=1
  nnoremap <silent> <F5> :UndotreeToggle<CR>
NeoBundleLazy 'majutsushi/tagbar', {'autoload':{'commands':'TagbarToggle'}}
  nnoremap <silent> <F9> :TagbarToggle<CR>

" unite
if !g:slow_mode
  NeoBundleLazy "Shougo/unite.vim", { "autoload" : { "commands" : ["Unite"] } }
    let bundle = neobundle#get('unite.vim')
    function! bundle.hooks.on_source(bundle)
      call unite#filters#matcher_default#use(['matcher_fuzzy'])
      call unite#filters#sorter_default#use(['sorter_rank'])
      call unite#set_profile('files', 'smartcase', 1)
      call unite#custom#source('line,outline','matchers','matcher_fuzzy')
    endfunction

    let g:unite_data_directory=expand('~/.vim/.cache/unite')
    let g:unite_enable_start_insert=1
    let g:unite_source_history_yank_enable=1
    let g:unite_source_rec_max_cache_files=5000
    let g:unite_prompt='» '

    if executable('ag')
      let g:unite_source_grep_command='ag'
      let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'
      let g:unite_source_grep_recursive_opt=''
    elseif executable('ack')
      let g:unite_source_grep_command='ack'
      let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
      let g:unite_source_grep_recursive_opt=''
    endif

    function! s:unite_settings()
      nmap <buffer> Q <plug>(unite_exit)
      nmap <buffer> <esc> <plug>(unite_exit)
      imap <buffer> <esc> <plug>(unite_exit)

      " Enable navigation with control-j and control-k in insert mode
      imap <buffer> <C-j> <Plug>(unite_select_next_line)
      imap <buffer> <C-k> <Plug>(unite_select_previous_line)
    endfunction
    autocmd FileType unite call s:unite_settings()

    nmap <space> [unite]
    nnoremap [unite] <nop>

    if s:is_windows
      nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec:! buffer file_mru bookmark<cr>
      nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec:!<cr>
    else
      nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr>
      nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr>
    endif
    nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
    nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
    nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
    nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
    nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
    nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
    nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>

    nnoremap <leader>nbu :Unite neobundle/update -vertical -no-start-insert<cr>

  NeoBundleLazy 'Shougo/neomru.vim', {'autoload':{'unite_sources':'file_mru'}}
    let g:neomru#file_mru_path=expand('~/.vim/.cache/neomru/file')
    let g:neomru#directory_mru_path=expand('~/.vim/.cache/neomru/directory')
  NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':['tag','tag/file']}}
    nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<cr>
  NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}}
    nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>
  NeoBundleLazy 'Shougo/unite-help', {'autoload':{'unite_sources':'help'}}
    nnoremap <silent> [unite]h :<C-u>Unite -auto-resize -buffer-name=help help<cr>
  NeoBundleLazy 'Shougo/junkfile.vim', {'autoload':{'commands':'JunkfileOpen','unite_sources':['junkfile','junkfile/new']}}
    let g:junkfile#directory=expand("~/.vim/.cache/junk")
    nnoremap <silent> [unite]j :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<cr>
endif

" indents
NeoBundleLazy 'nathanaelkane/vim-indent-guides', {
      \ 'autoload' : {
      \   'commands' : ['IndentGuidesEnable', 'IndentGuidesDisable', 'IndentGuidesToggle'],
      \ }}
  let g:indent_guides_start_level=1
  let g:indent_guides_guide_size=1
  let g:indent_guides_enable_on_vim_startup=0
  let g:indent_guides_color_change_percent=3
  if !has('gui_running')
    let g:indent_guides_auto_colors=0
    function! s:indent_set_console_colors()
      hi IndentGuidesOdd ctermbg=235
      hi IndentGuidesEven ctermbg=236
    endfunction
    autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
  endif

" misc
NeoBundle 'bufkill.vim'
NeoBundle 'mhinz/vim-startify'
  let g:startify_session_dir = expand('~/.vim/.cache/sessions')
  let g:startify_change_to_vcs_root = 1
  let g:startify_show_sessions = 1
  nnoremap <F1> :Startify<cr>
if exists('$TMUX')
  NeoBundle 'christoomey/vim-tmux-navigator'
endif
NeoBundle 'jamessan/vim-gnupg'
NeoBundleLazy 'guns/xterm-color-table.vim', {'autoload':{'commands':'XtermColorTable'}}
NeoBundleLazy 'scrooloose/syntastic', {
      \ 'autoload': {
      \   'filetypes' : ['ruby', 'c'],
      \   'commands' : [
      \     'SyntasticCheck', 'SyntasticInfo',
      \     'SyntasticReset', 'SyntasticToggleMode'
      \   ]
      \ }}
  let g:syntastic_error_symbol = '✗'
  let g:syntastic_style_error_symbol = '✠'
  let g:syntastic_warning_symbol = '∆'
  let g:syntastic_style_warning_symbol = '≈'
NeoBundleLazy 'mattn/gist-vim', { 'depends': 'mattn/webapi-vim', 'autoload': { 'commands': 'Gist' } }
  let g:gist_post_private=1
  let g:gist_show_privates=1
NeoBundleLazy 'Shougo/vimshell.vim', {
      \ 'depends' : 'Shougo/vimproc.vim',
      \ 'autoload' : {
      \   'commands' : [{ 'name' : 'VimShell',
      \                   'complete' : 'customlist,vimshell#complete'},
      \                 'VimShell',
      \                 'VimShellExecute', 'VimShellInteractive',
      \                 'VimShellTerminal', 'VimShellPop'],
      \   'mappings' : ['<Plug>(vimshell_']
      \ }}
  if s:is_macvim
    let g:vimshell_editor_command='mvim'
  else
    let g:vimshell_editor_command='vim'
  endif
  let g:vimshell_right_prompt='getcwd()'
  let g:vimshell_data_directory=expand('~/.vim/.cache/vimshell')

  nnoremap <leader>c :VimShell -split<cr>
  nnoremap <leader>cc :VimShell -split<cr>
  nnoremap <leader>cn :VimShellInteractive node<cr>
  nnoremap <leader>cl :VimShellInteractive lua<cr>
  nnoremap <leader>cr :VimShellInteractive irb<cr>
  nnoremap <leader>cp :VimShellInteractive python<cr>
NeoBundleLazy 'zhaocai/GoldenView.Vim', {'autoload':{'mappings':['<Plug>ToggleGoldenViewAutoResize']}}
  let g:goldenview__enable_default_mapping=0
  nmap <F4> <Plug>ToggleGoldenViewAutoResize

" -------- mappings --------
" formatting shortcuts
nmap <leader>fef :call Preserve("normal gg=G")<CR>
nmap <leader>f$ :call StripTrailingWhitespace()<CR>
vmap <leader>s :sort<cr>

nnoremap <leader>w :w<cr>

" toggle paste
map <F6> :set invpaste<CR>:set paste?<CR>

" remap arrow keys
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

" smash escape
inoremap jk <esc>
inoremap kj <esc>

" change cursor position in insert mode
inoremap <C-h> <left>
inoremap <C-l> <right>

inoremap <C-u> <C-g>u<C-u>

if mapcheck('<space>/') == ''
  nnoremap <space>/ :vimgrep //gj **/*<left><left><left><left><left><left><left><left>
endif

" sane regex
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
nnoremap :s/ :s/\v

" command-line window
nnoremap q: q:i
nnoremap q/ q/i
nnoremap q? q?i

" folds
nnoremap zr zr:echo &foldlevel<cr>
nnoremap zm zm:echo &foldlevel<cr>
nnoremap zR zR:echo &foldlevel<cr>
nnoremap zM zM:echo &foldlevel<cr>

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
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" find current word in quickfix
nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
" find last search in quickfix
nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" shortcuts for windows
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s
nnoremap <leader>vsa :vert sba<cr>
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

" window killer
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

" quick buffer open
nnoremap gb :ls<cr>:e #

if neobundle#is_sourced('vim-dispatch')
  nnoremap <leader>tag :Dispatch ctags -R<cr>
endif

" general
nmap <leader>l :set list! list?<cr>
nmap <leader>hs :set hlsearch! hlsearch?<cr>

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" helpers for profiling
nnoremap <silent> <leader>DD :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>DP :exe ":profile pause"<cr>
nnoremap <silent> <leader>DC :exe ":profile continue"<cr>
nnoremap <silent> <leader>DQ :exe ":profile pause"<cr>:noautocmd qall!<cr>

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

" format pasted text automatically
nnoremap p p=`]
nnoremap <c-p> p

" -------- commands --------
command! -bang Q q<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>

" -------- autocmd --------
" go back to previous position of cursor if any
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe 'normal! g`"zvzz' |
  \ endif

autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
autocmd FileType python setlocal foldmethod=indent
autocmd FileType markdown setlocal nolist
autocmd FileType vim setlocal fdm=indent keywordprg=:help

" -------- color schemes --------
NeoBundle 'w0ng/vim-hybrid'
colorscheme hybrid

" -------- finish loading --------
" Required:
filetype plugin indent on
syntax enable

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
