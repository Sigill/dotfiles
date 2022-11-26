syntax on

set showmatch " set show matching parenthesis
set hlsearch
set splitright

autocmd BufNewFile,BufRead *.txx setfiletype cpp
autocmd BufNewFile,BufRead *.ctp setfiletype php " CakePHP templates

" Notify when a file is modified outside of vim
autocmd CursorHold * checktime

set matchpairs+=<:> " Include angle brackets in matching

let mapleader="," " change the mapleader from \ to ,

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e ~/.vimrc<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>:exe ":echo 'vimrc reloaded'"<CR>

set listchars=tab:\|\ ,nbsp:¤,eol:¬,trail:·
set list
nmap <leader>ws :set list!<CR>

filetype plugin on
filetype indent on

set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set cindent
set cino+=g0 " Do not indent public, private and protected in c++ classes
set cino+=N-s " Do not indent inside a namespace
set cino+=(0,u0,U0 " Do not use tabs for alignement (does not work properly, will mix tab and spaces)
set cino+=Ws " Do not indent with parenthese position when the parenthese is the last character
set cino+=k0 " Double the indent for if, for & while conditions
set cino+=js " Indent Java anonymous class
set cino+=Js " Indent JSON
