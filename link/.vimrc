" ===========================
" Setup
" ===========================

" Don't try to emulate vi
set nocompatible

" Change mapleader
let mapleader=","

" Local dirs for storing swap and backup files
if !has('win32')
  set backupdir=$DOTFILES/caches/vim
  set directory=$DOTFILES/caches/vim
  set undodir=$DOTFILES/caches/vim
  let g:netrw_home = expand('$DOTFILES/caches/vim')
endif

" Create vimrc autocmd group and remove any existing vimrc autocmds,
" in case .vimrc is re-sourced.
augroup vimrc
  autocmd!
augroup END

" ===========================
" Navigation
" ===========================

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Scrolling
set scrolloff=3     " Start scrolling three lines before horizontal border of
                    " window.
set scrolljump=5    " Line to scroll to when cursor leaves screen.
set sidescrolloff=3 " Start scrolling three columns before vertical border of
                    " window.

" Ctrl-J/K/L/H select split
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Buffer navigation
nnoremap <leader>b :CtrlPBuffer<CR> " List other buffers
map <leader><leader> :b#<CR>        " Switch between the last two files
map gb :bnext<CR>                   " Next buffer
map gB :bprev<CR>                   " Prev buffer

" Jump to buffer number 1-9 with ,<N> or 1-99 with <N>gb
let c = 1
while c <= 99
  if c < 10
    execute "nnoremap <silent> <leader>" . c . " :" . c . "b<CR>"
  endif
  execute "nnoremap <silent> " . c . "gb :" . c . "b<CR>"
  let c += 1
endwhile

" Fix page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" ===========================
" Editing
" ===========================

" Reformatting
set nojoinspaces " Only insert single space after a '.', '?' and '!' with a
                 " join command.

" Jump to matching bracket, briefly
set showmatch

set backspace=indent,eol,start " Backspace deletes over autoindent, end of line
                               " and start of the current insertion
set t_kb=
fixdel

" Turn on text completion (use <Ctrl-N>)
set complete=.,b,u,]
set wildmode=longest,list:longest

" ===========================
" Indentation and tabs
" ===========================

" Indentation
set autoindent    " Copy indent from last line when starting new line.
set shiftwidth=4  " The # of spaces for indenting.
set smarttab      " At start of line, <Tab> inserts shiftwidth spaces, 
                  " <Bs> deletes shiftwidth spaces.
set softtabstop=4 " Tab key goes in # spaces (but existing tabs stay the same)
set tabstop=4     " Tabs indent # spaces
set expandtab     " Expand tabs to spaces

" Toggle show tabs and trailing spaces (,c)
if has('win32')
  set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
else
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:>,precedes:<
endif
"set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
"set fillchars=fold:-
nnoremap <silent> <leader>v :call ToggleInvisibles()<CR>

" Automatic indentation based on file type
filetype indent on

" ===========================
" Status line
" ===========================

set noshowmode   " Don't show the current mode.
                 " (airline.vim takes care of this for us)
set laststatus=2 " Always show status line

" Custom status line
"set statusline=%<%f%h%1*%m%*%r%=%3n\ \ %7(%l,%c%)%V\ %P

" ===========================
" Theme / Syntax highlighting
" ===========================

" Make invisible chars less visible in terminal.
autocmd vimrc ColorScheme * :hi NonText ctermfg=236
autocmd vimrc ColorScheme * :hi SpecialKey ctermfg=236
" Show trailing whitespace.
autocmd vimrc ColorScheme * :hi ExtraWhitespace ctermbg=red guibg=red
" Make selection more visible.
autocmd vimrc ColorScheme * :hi Visual guibg=#00588A
autocmd vimrc ColorScheme * :hi link multiple_cursors_cursor Search
autocmd vimrc ColorScheme * :hi link multiple_cursors_visual Visual

colorscheme koehler
set background=dark

" ==========================
" Visual settings
" ==========================
"
set cursorline     " Highlight current line
set number         " Enable line numbers.
set showtabline=4  " Always show tab bar.
set relativenumber " Use relative line numbers.
                   " Current line is still in status bar.
set title          " Show the filename in the window titlebar.
set nowrap         " Do not wrap lines.

" Perform syntax highlighting
syntax enable

" Show absolute numbers in insert mode, otherwise relative line numbers.
autocmd vimrc InsertEnter * :set norelativenumber
autocmd vimrc InsertLeave * :set relativenumber

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" ===========================
" Whitespace
" ===========================

" Extra whitespace
autocmd vimrc BufWinEnter * :2match ExtraWhitespaceMatch /\s\+$/
autocmd vimrc InsertEnter * :2match ExtraWhitespaceMatch /\s\+\%#\@<!$/
autocmd vimrc InsertLeave * :2match ExtraWhitespaceMatch /\s\+$/

" ===========================
" Search / replace
" ===========================
"
set gdefault   " By default add g flag to search/replace. Add g to toggle.
set hlsearch   " Highlight searches
set incsearch  " Highlight dynamically as pattern is typed.
set ignorecase " Ignore case of searches.
set smartcase  " Ignore 'ignorecase' if search pattern contains uppercase 
               " characters.

" Clear last search
map <silent> <leader>/ <Esc>:nohlsearch<CR>

" Ignore things
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*

" ===========================
" Vim commands
" ===========================
"
set hidden                   " When a buffer is brought to foreground, remember
                             " undo history and marks.
set report=0                 " Show all changes.
set mouse=a                  " Enable mouse in all modes.
set selectmode=mouse         " Select using the mouse.
set shortmess+=I             " Hide intro menu.
set vb t_vb=                 " Flash instead of beep
set fileformats=unix,mac,dos "auto-detect format based on EOL

" Splits
set splitbelow   " New split goes below
set splitright   " New split goes right

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" When editing a file, always jump to the last known cursor position. Don't do
" it for commit messages, when the position is invalid, or when inside an event
" handler (happens when dropping a file on gvim).
autocmd vimrc BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" ===========================
" Functions
" ==========================

if !exists("*SourceConfigs")
  function! SourceConfigs()
    let files = ".vimrc"
    source $MYVIMRC
    if has("gui_running")
      let files .= ", .gvimrc"
      source $MYGVIMRC
    endif
    echom "Sourced " . files
  endfunction
endif

" Toggle Invisibles / Show extra whitespace
function! ToggleInvisibles()
  set nolist!
  if &list
    hi! link ExtraWhitespaceMatch ExtraWhitespace
  else
    hi! link ExtraWhitespaceMatch NONE
  endif
endfunction

set nolist
call ToggleInvisibles()

" Trim extra whitespace
function! StripExtraWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

noremap <leader>ss :call StripExtraWhiteSpace()<CR>

" Toggle formatoptions 'a' for automatic wrapping
function! ToggleWrapping()
    if &formatoptions=~'a'
        echo 'formatoptions a unset' 
        setlocal formatoptions-=a
    else
        echo 'formatoptions a set'
        setlocal formatoptions+=a
    endif
endfunction


" F10: Source .vimrc & .gvimrc files
nmap <F10> :call SourceConfigs()<CR>
map <c-F11> :call ToggleWrapping()<CR>
map <c-F12> :echo 'Current time is ' . strftime('%c')<CR>

" ===========================
" File types
" ===========================

" vim
autocmd vimrc BufRead .vimrc,*.vim set keywordprg=:help

" markdown
autocmd vimrc BufRead,BufNewFile *.md set filetype=markdown

" Makefiles
" Make sure TABs work as TABS
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal softtabstop=0

" C
" indentation options for C indenting.
"     :0  -- case labels are indented 0 spaces in from switch
"     (2  -- indent 2 spaces within unclosed parentheses
"     m1  -- line up close parentheses with start of opening line
" there are _many_ more options; do ":help cinoptions-values" to see them
set cinoptions=:0,(2,m1

" Perl
let perl_include_pod=1
let perl_extended_vars=1

" Handlebars
au Bufread,BufNewFile *.handlebars,*.hbs set ft=html syntax=handlebars

" LaTeX
" Turn on spell check
autocmd Bufread,BufNewFile *.tex, setlocal spell spelllang=en_au
" Text wrapping
autocmd Bufread,BufNewFile *.tex, setlocal spell textwidth=80
" Wrap paragraphs using text width, see h:fo-table
autocmd Bufread,BufNewFile *.tex, setlocal spell formatoptions=qt
" Add dictionary words to tab complete
autocmd Bufread,BufNewFile *.tex, setlocal spell complete+=kspell

" ===========================
" Plugins
" ===========================

" Airline
"let g:airline_powerline_fonts = 1 " TODO: detect this?
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#buffer_nr_format = '%s '
"let g:airline#extensions#tabline#buffer_nr_show = 1
""let g:airline#extensions#tabline#fnamecollapse = 0
""let g:airline#extensions#tabline#fnamemod = ':t'

" NERDTree
"let NERDTreeShowHidden = 1
"let NERDTreeMouseMode = 2
"let NERDTreeMinimalUI = 1
"map <leader>n :NERDTreeToggle<CR>
"autocmd vimrc StdinReadPre * let s:std_in=1
"" If no file or directory arguments are specified, open NERDtree.
"" If a directory is specified as the only argument, open it in NERDTree.
"autocmd vimrc VimEnter *
"  \ if argc() == 0 && !exists("s:std_in") |
"  \   NERDTree |
"  \ elseif argc() == 1 && isdirectory(argv(0)) |
"  \   bd |
"  \   exec 'cd' fnameescape(argv(0)) |
"  \   NERDTree |
"  \ end

" Signify
"let g:signify_vcs_list = ['git', 'hg', 'svn']

" CtrlP.vim
"map <leader>p <C-P>
"map <leader>r :CtrlPMRUFiles<CR>
"let g:ctrlp_match_window_bottom = 0 " Show at top of window

" Indent Guides
"let g:indent_guides_start_level = 2
"let g:indent_guides_guide_size = 1

" Mustache/handlebars
"let g:mustache_abbreviations = 1

" https://github.com/junegunn/vim-plug
" Reload .vimrc and :PlugInstall to install plugins.
"call plug#begin('~/.vim/plugged')
"Plug 'bling/vim-airline'
"Plug 'tpope/vim-sensible'
"Plug 'tpope/vim-surround'
"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-vinegar'
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-unimpaired'
"Plug 'tpope/vim-eunuch'
"Plug 'scrooloose/nerdtree'
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'editorconfig/editorconfig-vim'
"Plug 'fatih/vim-go', {'for': 'go'}
"Plug 'nathanaelkane/vim-indent-guides'
"Plug 'pangloss/vim-javascript', {'for': 'javascript'}
"Plug 'mhinz/vim-signify'
"Plug 'mattn/emmet-vim'
"Plug 'mustache/vim-mustache-handlebars'
"Plug 'chase/vim-ansible-yaml'
"Plug 'wavded/vim-stylus'
"Plug 'klen/python-mode', {'for': 'python'}
"Plug 'terryma/vim-multiple-cursors'
"Plug 'wting/rust.vim', {'for': 'rust'}
"call plug#end()
