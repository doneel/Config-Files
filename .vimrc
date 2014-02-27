" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


" ================ General Config ====================

set number                      "Line numbers are good
set ruler                       "Always show location
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
"set visualbell                  "No sounds (creating glitchy flashing)
set autoread                    "Reload files changed outside vim
set lazyredraw                  "Don't redraw while macro-ing
set magic                       "For reg ex, turn magic on
set showmatch                   "Hilight matching brackets
set encoding=utf8               "standard encoding and en_US as lang
set ffs=unix,dos,mac            " Use Unix as the standard file type
set autochdir                   "Set vim's directory to be the file's
set ttyfast                        "My terminals are fast
set formatoptions=tcql         " t - autowrap to textwidth
                                " c - autowrap comments to textwidth
                                " r - autoinsert comment leader with <Enter>
                                " q - allow formatting of comments with :gq
                                " l - don't format already long lines


" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on
filetype plugin on
filetype indent on


" ================ Search Settings  =================

"set incsearch        "Find the next match as we type the search (I don't actually like it"
set ignorecase       "Ignore case when searching
set smartcase        "Try to be smart about cases?
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks



" ================ Turn Off Swap Files ==============

set noswapfile


" ================ Backup Files =====================

set backup
set backupdir=~/.vim/backups


" ================ Persistent Cursor Position =======

 autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

 set viminfo^=%          "Remember info about open buffers

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.

silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=5
set softtabstop=5
set expandtab            "Use spaces instead of tabs
"set wrap                 "Wrap lines don't go onto th enext line please

" Display tabs and trailing spaces visually
"set list listchars=tab:\ \ ,trail:?

"set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

vnoremap < <gv           
                         "Block indent / outdent"
vnoremap > >gv

" ================ Delete Trailing Whitespace ======

func! DeleteTrailingWS()
     exe "normal mz"
     %s/\s\+$//ge
       exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()         "enabled in python
autocmd BufWrite *.coffee :call DeleteTrailingWS()     "...and coffeescript

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~,*.pyc"stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif


" ================ Scrolling ========================

set scrolloff=5         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================= Navigation =======================
nnoremap j gj
nnoremap k gk

" ================= Key Shortcuts ====================
inoremap jk <Esc>
cnoremap jk <Esc>
vnoremap jk <Esc>
nnoremap ; :

                    "Home-row keys to go to end/start of line
noremap L $
noremap H 0

noremap L $
noremap H 0
xmap p ]p         

" ================= Leader Macros ====================
set timeout timeoutlen=50 ttimeoutlen=100   " 1/20 second to double tap
                                             " 1/10 for leader shortcuts
let mapleader =" "
nmap <leader>w :w<CR>
nmap <leader>wq :wq<CR>
nmap <leader>rg :%s//g<left><left>
nmap <leader>rn :%s//gc<left><left><left>


" ================= Copy / Pate ======================
"set pastetoggle=<leader>p
map <leader>p "+p
map <leader>y "+y
"vnoremap "+y <leader>y
"inoremap "+y <leader>y


" ================= Appearance =======================
set  t_Co=256
"let g:rehash256 = 1
set background=dark
colorscheme molokai
set cursorline
" ================= Buffer Switching =================
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
