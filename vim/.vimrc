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
"Plugin 'shawncplus/phpcomplete.vim'
Plugin 'bling/vim-airline'
Plugin 'chase/vim-ansible-yaml'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'bling/vim-bufferline'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'moll/vim-bbye'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/syntastic'
"Plugin 'joonty/vim-phpunitqf.git'
"Plugin 'mkusher/padawan.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'dracula/vim'

cal vundle#end()
filetype plugin indent on

let mapleader=","
"colorscheme torte
"colorscheme inkpot
color dracula

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

let g:padawan#composer_command = "composer"

let g:phpcomplete_index_composer_command = 'composer'

let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers.php =
            \ ['->', '::', '(', 'new ', 'use ', 'namespace ', '\', '$', ' ']

let g:ycm_python_binary_path = '/usr/bin/python3'

" Turn on omnifunc
set omnifunc=syntaxcomplete#Complete

let g:airline_powerline_fonts = 1
set t_Co=256
let g:airline#extensions#tabline#enabled = 1
" at the end of next line there must be a space character
set fillchars+=stl:\ ,stlnc:\ 

hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

set runtimepath^=~/.vim/bundle/ctrlp.vim

hi Normal ctermbg=none

:nnoremap <Leader>q :Bdelete<CR>
nmap <Leader>w :StripWhitespace<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set runtimepath^=~/.vim/bundle/ctrlp.vim

map <Leader>t :Test<CR>


let g:bufferline_echo = 0
let g:airline#extensions#syntastic#enabled = 1
let g:syntastic_loc_list_height = 3
