
set encoding=utf-8
set relativenumber
set number
syntax on

" Directory specific .vimrc
set exrc
set secure

set nofoldenable
set foldmethod=syntax
let g:vim_markdown_initial_foldlevel = 1

" Status Line Stuff
set laststatus=2
set display+=lastline

let g:airline_enable_branch = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'simple'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extension#tabline#fnamemod = ':t'

" Better line navigation with wrapped lines
nnoremap j gj
nnoremap k gk

" Vundle Setup
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-fugitive'
Bundle 'bling/vim-airline'
Bundle 'plasticboy/vim-markdown'
Bundle 'airblade/vim-gitgutter'
Bundle 'flazz/vim-colorschemes'
Bundle 'tpope/vim-dispatch'

 set background=dark
"set t_Co=256
colorscheme solarized

" tabs
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" leader
let mapleader=","

" newline: find period, delete trailing whitespace, insert newline
nmap <Leader>nl /\. <cr>ldWi<cr><ESC>

" autocmd!
au BufWritePost $NOTES_DIR/*.md silent ! pandoc -o $NOTES_DIR/pdf/<afile>:t:r.pdf <afile>:p
au BufRead,BufNewFile *.md set filetype=markdown

" filetype back on
filetype on
