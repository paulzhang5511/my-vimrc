""" paul vim config

""" basic config
set nocompatible
set hidden
set textwidth=80
set colorcolumn=+1
set rnu
set nu
syntax enable 
syntax on
set cursorline
set ignorecase
set smartcase
set hlsearch
set incsearch
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set signcolumn=yes

filetype plugin indent on

""" keymaps
let mapleader = ',' 

nnoremap j gj
nnoremap k g
nnoremap q :<C-u>close<CR>

" window 
nnoremap <Space>wj <C-w>j
nnoremap <Space>wk <C-w>k
nnoremap <Space>wh <C-w>h
nnoremap <Space>wl <C-w>l

" buffer
nnoremap <Space>bd :<C-u>bdelete<CR>
nnoremap <Space>bn :<C-u>bnext<CR>
nnoremap <Space>bp :<C-u>bprevious<CR>

" save file
nnoremap <C-s> :<C-u>w!<CR>
nnoremap <Leader>s :<C-u>w!<CR>

" system clipboard
vnoremap <leader>y "+y 
nnoremap <leader>p "+p

" split screen
nnoremap sg :<C-u>sp<CR>
nnoremap sv :<C-u>vsp<CR>

set background=dark
colorscheme PaperColor





