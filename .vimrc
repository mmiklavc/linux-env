set t_Co=256
set laststatus=2
syntax enable
set background=dark
" colorscheme solarized

set nocompatible

set number
set ruler
set hls

set showcmd
set foldmethod=marker

filetype on
filetype plugin on
filetype indent on
set grepprg=grep\ -nH\ $*

set autoindent

set expandtab
set smarttab

set shiftwidth=4
set softtabstop=4

set wildmenu
set wildmode=list:longest,full

set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]
