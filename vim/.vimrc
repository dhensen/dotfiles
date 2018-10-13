set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'chase/vim-ansible-yaml'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'moll/vim-bbye'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'Chiel92/vim-autoformat'
Plugin 'Valloric/YouCompleteMe'
Plugin 'dracula/vim'
Plugin 'airblade/vim-gitgutter'

cal vundle#end()
filetype plugin indent on
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let mapleader=","
color dracula

syntax on
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set laststatus=2
set hidden

" Automatically open NERDTree when vim starts up with no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Lets me use q to quit if the only windows left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <Leader>n :NERDTreeToggle<CR>
map <C-h> :bp<CR>
map <C-l> :bn<CR>
map <C-q> :Bdelete<CR>

" move between splits
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

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
let g:syntastic_python_checkers = ['flake8']

set runtimepath^=~/.vim/bundle/ctrlp.vim

map <Leader>t :Test<CR>


"let g:bufferline_echo = 1
let g:airline#extensions#syntastic#enabled = 1
let g:syntastic_loc_list_height = 3

