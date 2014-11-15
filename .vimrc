" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

" -------- detect OS --------
let s:is_windows = has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_macvim = has('gui_macvim')

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
Plug 'gregsexton/MatchTag', { 'for': ['html', 'xml'] }
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
Plug 'tokorom/xcode-actions.vim', { 'for': ['objc', 'swift'] }
Plug 'brow/vim-xctool', { 'for': ['objc', 'swift'] }

" scm
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }

" autocomplete
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'Rip-Rip/clang_complete'

" editing
Plug 'tpope/vim-endwise', { 'for': ['lua', 'ruby', 'sh', 'zsh', 'vb', 'vbnet', 'aspvbs', 'vim', 'c', 'cpp', 'xdefaults'] }
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
Plug 'thinca/vim-visualstar'
Plug 'terryma/vim-expand-region'
Plug 'chrisbra/NrrwRgn', { 'on': ['NR', 'NarrowRegion', 'NW', 'NarrowWindow'] }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'mkc188/auto-pairs'
Plug 'justinmk/vim-sneak'
Plug 'ReplaceWithRegister'

" navigation
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'ctrlpvim/ctrlp.vim', { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMRU'] }
Plug 'FelikZ/ctrlp-py-matcher'

" indents
Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesEnable', 'IndentGuidesDisable', 'IndentGuidesToggle'] }
Plug 'sickill/vim-pasta'
Plug 'ciaranm/detectindent', { 'on': 'DetectIndent' }

" misc
Plug 'mhinz/vim-startify'
Plug 'guns/xterm-color-table.vim', { 'on': 'XtermColorTable' }
Plug 'scrooloose/syntastic', { 'for': ['ruby', 'c'], 'on': ['SyntasticCheck', 'SyntasticInfo', 'SyntasticReset', 'SyntasticToggleMode'] }
Plug 'zhaocai/GoldenView.Vim', { 'on': '<Plug>ToggleGoldenViewAutoResize' }
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

" emmet-vim
function! s:zen_html_tab()
  let line = getline('.')
  if match(line, '<.*>') < 0
    return "\<c-y>,"
  endif
  return "\<c-y>n"
endfunction
" vim-indent-guides
function! s:indent_set_console_colors()
  hi IndentGuidesOdd ctermbg=235
  hi IndentGuidesEven ctermbg=236
endfunction

" -------- base configuration --------
set ttimeout
set timeoutlen=500
set ttimeoutlen=100

" enable mouse
set mouse=a
" number of command lines to remember
set history=1000
" assume fast terminal connection
set ttyfast
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
if s:is_windows
  set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe
else
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip
endif

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

call EnsureExists(&undodir)
call EnsureExists(&backupdir)
call EnsureExists(&directory)

let mapleader = ","
let g:mapleader = ","

" -------- ui configuration --------
" automatically highlight matching braces/brackets/etc.
set showmatch
" tens of a second to show matching parentheses
set matchtime=2
set number
set lazyredraw
set showtabline=0
" folds are created manually
set foldmethod=manual

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
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=b
  set guioptions-=L

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
" vim-sneak
let g:sneak#s_next = 1
let g:sneak#streak = 1
let g:sneak#target_labels = "asdfghkl;qwertyuiopzxcvbnm/ASDFGHJKL:QWERTYUIOPZXCVBNM?"
hi link SneakPluginTarget Search
hi link SneakPluginScope Search
hi link SneakStreakTarget Search
" ack.vim
if executable('ag')
  let g:ackprg = "ag --nogroup --nocolor --column --smart-case --follow"
endif
" undotree
let g:undotree_SetFocusWhenToggle = 1
" vim-filebeagle
let g:filebeagle_suppress_keymaps = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
" vim-buffergator
let g:buffergator_suppress_keymaps = 1
" vim-indent-guides
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_color_change_percent = 3
" detectindent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4
" vim-startify
let g:startify_session_dir = expand('~/.vim/.cache/sessions')
let g:startify_change_to_vcs_root = 1
let g:startify_show_sessions = 1
" GoldenView.Vim
let g:goldenview__enable_default_mapping = 0
" ctrlp.vim
let g:ctrlp_map = ''
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 0
let g:ctrlp_cache_dir = expand('~/.vim/.cache/ctrlp')
let g:ctrlp_reuse_window = 'startify'
let g:ctrlp_lazy_update = 1
let g:ctrlp_working_path_mode = ''
let g:ctrlp_custom_ignore = {
      \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
      \ 'file': '\v\.(DS_Store|exe|so|dll)$',
      \ }
if has('python') && v:version >= 704
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
        \ --ignore .git
        \ --ignore .svn
        \ --ignore .hg
        \ --ignore .DS_Store
        \ --ignore "**/*.pyc"
        \ -g ""'
endif
" clang_complete
let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
let g:clang_auto_user_options = "compile_commands.json, path, .clang_complete"
let g:clang_complete_auto = 0
let g:clang_periodic_quickfix = 0
let g:clang_snippets = 1
let g:clang_auto_select = 1
let g:clang_complete_copen = 1
" vim-objc
let c_no_curly_error = 1
" supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextDiscoverDiscovery = ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

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

" change cursor position in insert mode
inoremap <C-h> <left>
inoremap <C-l> <right>
inoremap <C-j> <down>
inoremap <C-k> <up>

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

" find current word in quickfix
nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
" find last search in quickfix
nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

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
" GoldenView.Vim
nmap <F4> <Plug>ToggleGoldenViewAutoResize
" vim-dispatch
nnoremap <leader>tag :Dispatch ctags -R<cr>
" ctrlp.vim
nnoremap <silent> <space><space> :CtrlP<CR>
nnoremap <silent> <space>b :CtrlPBuffer<CR>
nnoremap <silent> <space>m :CtrlPMRU<CR>
" clang_complete
nnoremap <leader>q :call g:ClangUpdateQuickFix()<CR>
nnoremap <leader>c :cc<cr>
" xcode-actions.vim
nmap <silent> <leader>xb <Plug>(xcode-actions-build)
nmap <silent> <leader>xr <Plug>(xcode-actions-run)
nmap <silent> <leader>xc <Plug>(xcode-actions-clean)
nmap <silent> <leader>xt <Plug>(xcode-actions-test)
nmap <silent> <leader>xo <Plug>(xcode-actions-openfile)

" -------- commands --------
command! -bang Q q<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>

" -------- autocmd --------
if has('autocmd')
  augroup Misc
    autocmd!
    " automatically resize splits when resizing MacVim window
    autocmd VimResized * wincmd =
    " go back to previous position of cursor if any
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \  exe 'normal! g`"zvzz' |
          \ endif

    " vim-fugitive
    autocmd BufReadPost fugitive://* set bufhidden=delete
  augroup END

  augroup FTOptions
    autocmd!
    " emmet-vim
    autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><tab> <c-y>,
    autocmd FileType html imap <buffer><expr><tab> <sid>zen_html_tab()
  augroup END

  augroup SneakPluginColors
    autocmd!
    autocmd ColorScheme * hi SneakStreakMask guifg=#f0c674 ctermfg=221 guibg=#f0c674 ctermbg=221
  augroup END

  if !has('gui_running')
    let g:indent_guides_auto_colors = 0
    augroup IndentGuidesColors
      autocmd!
      autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
    augroup END
  endif
endif

" -------- color schemes --------
if !empty(glob('~/.vim/plugged/vim-hybrid'))
  colorscheme hybrid
endif
