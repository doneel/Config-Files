
" ================= Vundle Auto Install ==============
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
"set nocompatible
"let has_vundle=1
"if !filereadable($HOME."/.vim/bundle/Vundle.vim/README.md")
"    echo "Installing Vundle..."
"    echo ""
"    silent !mkdir -p $HOME/.vim/bundle
"    silent !git clone https://github.com/gmarik/Vundle.vim $HOME/.vim/bundle/Vundle.vim
"   let has_vundle=0
"endif

" =============== Vim-Plug install ==================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" =============== Colorscheme Auto Install ==========
if !filereadable($HOME."/.vim/colors/molokai.vim")
    echo "Downloading molokai colorscheme..."
    echo ""
    silent !mkdir -p $HOME/.vim/colors
    silent !curl https://raw.githubusercontent.com/doneel/Config-Files/master/.vim/colors/molokai.vim > $HOME/.vim/colors/molokai.vim
endif


" ================ Package Management ================
" If installed using Homebrew
call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

"set rtp+=~/.vim/bundle/Vundle.vim/
"call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'       "package manager Vundle to manage plugins
"Plugin 'ctrlpvim/ctrlp.vim'         "file finding
"Plugin 'easymotion/vim-easymotion'  "quick movement
"Plugin 'ConradIrwin/vim-bracketed-paste'
" Plugin 'valloric/youcompleteme'
" Plugin 'scrooloose/syntastic'
"Plugin 'Chiel92/vim-autoformat'
"Plugin 'alfredodeza/pytest.vim'
"Plugin 'christoomey/vim-tmux-navigator'
"call vundle#end()

"if has_vundle == 0
"    :silent! PluginInstall
"    :so $MYVIMRC
"endif

filetype plugin indent on


" ================= Leader Macros ====================
set timeout  timeoutlen=400 ttimeoutlen=100   " 1/5 second to double tap
" 1/10 for leader shortcuts
let mapleader =" "
"nmap <leader>w :w<CR>
"nmap <leader>wq :wq<CR>
nmap <leader>rg :%s//g<left><left>
vmap <leader>rg y:%s/<C-R>"//g<left><left>
" y/<C-R>"<CR>
nmap <leader>rn :%s//gc<left><left><left>


" ================= FZF File Search ==================
"search in current cirectory
"nnoremap <Leader>f :Files <C-R>=expand('%:h')<CR><CR>  "not sure about this found online
nnoremap <Leader>f :Files /<CR> "Search for files in current directory

"search in all cirectory
nnoremap <Leader>F :Files /<CR>

"search in current cirectory
nnoremap <Leader>g :Find<CR>
vnoremap <Leader>g y:Find <C-R>"<CR> 
"search in all cirectory
nnoremap <Leader>G :Rg<CR>
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" ================= Syntastic ========================
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint']


" ================= Easy Motion ======================
" let g:EasyMotion_leader_key = '<Leader>'
"let g:EasyMotion_smartcase = 1
"let g:EasyMotion_use_smartsign_us = 1 " US layout
map s <Plug>(easymotion-bd-w)
nmap s <Plug>(easymotion-overwin-w)


" ================= FZF File Search ==================
"search in current cirectory
nmap <Leader>f :Files <C-R>=expand('%:h')<CR><CR> 

"search in all cirectory
nmap <Leader>F :Files<CR>

" ================ Vim Autoformat ====================
let g:formatter_yapf_style = 'google'
"au BufWrite * :Autoformat


" ================ Autoreload .vimrc =================
autocmd! bufwritepost .vimrc source %


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
"set encoding=utf8               "standard encoding and en_US as lang
set ffs=unix,dos,mac            " Use Unix as the standard file type
" set autochdir                   "Set vim's directory to be the file's this
" messes up search!
set ttyfast                        "My terminals are fast
set formatoptions=tcql         " t - autowrap to textwidth
" c - autowrap comments to textwidth
" r - autoinsert comment leader with <Enter>
" q - allow formatting of comments with :gq
" l - don't format already long lines
set autoread                    "Automatically reload file if it's been changed elsewhere

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden


"================= Syntax Highlighting ==============
filetype off
set runtimepath+=$GOROOT/misc/vim
filetype plugin on
filetype indent on
syntax on


" ================ Search Settings  =================
set incsearch        "Find the next match as we type the search (I don't actually like it"
set ignorecase       "Ignore case when searching
set smartcase        "Try to be smart about cases?
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks
cnoremap <c-n> <CR>n/<c-p>


" Double tap search to search for currently selected text
vnoremap // y/<C-R>"<CR> 
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '


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

" set viminfo^=%          "Remember info about open buffers WARNING: This
" means a lot of garbage files. I'm turning this off


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
set shiftwidth=2
set softtabstop=2
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
set wildignore=*.o,*.obj,*~,*.pyc "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*


" ================ Scrolling ========================
set scrolloff=5         "Start scrolling when we're 5 lines away from margins
set sidescrolloff=15
set sidescroll=1


" ================= Navigation =======================
nnoremap j gj
nnoremap k gk
nnoremap J <c-d>
nnoremap K <c-u>


" ================= Key Shortcuts ====================
inoremap fd <Esc>
cnoremap fd <Esc>
vnoremap fd <Esc>
if has('nvim')
    tnoremap fd <C-\><C-n>
end
nnoremap ; :

"Home-row keys to go to end/start of line
noremap L $
noremap H 0

noremap L $
noremap H 0
xmap p ]p


" ================= Copy / Pate ======================
"set pastetoggle=<leader>p
noremap <leader>p "+p
noremap <leader>y "+y

nnoremap d "dd
vnoremap d "dd
nnoremap x "dx
vnoremap x "dx
"set mouse=a
"vnoremap "+y <leader>y
"inoremap "+y <leader>y
set clipboard+=unnamed

" ================= Appearance =======================
set  t_Co=256
"let g:molokai_original = 1
"let g:rehash256 = 1
"set background=dark
colorscheme molokai
set cursorline


" ================= Buffer Switching =================
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nnoremap <C-]> :bp<CR>
nnoremap <C-[> :bn<CR>
