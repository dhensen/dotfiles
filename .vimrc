set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'mkusher/padawan.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'bling/vim-airline'
Plugin 'chase/vim-ansible-yaml'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'bling/vim-bufferline'
Plugin 'jlanzarotta/bufexplorer'

cal vundle#end()
filetype plugin indent on

let mapleader=","
"colorscheme torte
colorscheme inkpot

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set laststatus=2

" Automatically open NERDTree when vim starts up with no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <Leader>n :NERDTreeToggle<CR>

" Padawan needs $PATH that includes ~/.composer/vendor/bin
let $PATH=$PATH
let g:padawan#composer_command = "php /usr/local/bin/composer"

" YouCompleteMe. Uses Padawan
let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers.php =
            \ ['->', '::', '(', 'use ', 'namespace ', '\']

let g:airline_powerline_fonts = 1
set t_Co=256

hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

set runtimepath^=~/.vim/bundle/ctrlp.vim
