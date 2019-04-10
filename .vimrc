set t_Co=256
set laststatus=2
syntax enable
set background=dark
" colorscheme solarized
colorscheme slate

set nocompatible

set number
set ruler
set hls

" This shows what you are typing as a command.
set showcmd
set foldmethod=marker

" syntax
filetype on
filetype plugin on
filetype indent on
set grepprg=grep\ -nH\ $*
augroup filetypedetect
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END

set autoindent

set expandtab
set smarttab

set shiftwidth=4
set softtabstop=4

set wildmenu
set wildmode=list:longest,full

set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" Avro
au BufRead,BufNewFile *.avdl setlocal filetype=avro-idl
au BufRead,BufNewFile *.avsc set filetype=json

" JSON
" https://www.vim.org/scripts/script.php?script_id=1945
au! BufRead,BufNewFile *.json set filetype=json
augroup json_autocmd
    autocmd!
    autocmd FileType json set autoindent
    autocmd FileType json set formatoptions=tcq2l
    autocmd FileType json set textwidth=78 shiftwidth=2
    autocmd FileType json set softtabstop=2 tabstop=8
    autocmd FileType json set expandtab
    " This will fold lines - only enable if you want this by default
    "    autocmd FileType json set foldmethod=syntax
augroup END

" Git commit message wordwrap and spellchecking
autocmd Filetype gitcommit setlocal spell textwidth=72
" Alternative JSON formatting option. Will use 4 spaces for tab.
command JsonFormat %!python -m json.tool
