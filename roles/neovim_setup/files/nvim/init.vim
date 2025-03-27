" Neovim configuration

" Disable compatibility to old-time vi
set nocompatible

" Show matching brackets
set showmatch

" Enable case-insensitive matching
set ignorecase
set smartcase

" Highlight search results
set hlsearch

" Set the number of columns occupied by a tab character
set tabstop=2
set softtabstop=2
set expandtab

" Set the width for autoindents
set shiftwidth=2

" Indent a new line the same amount as the line just typed
set autoindent

" Display line numbers
set number

" Enable bash-like tab completions
set wildmode=longest,list

" Enable syntax highlighting and filetype detection
filetype plugin indent on
syntax on

" Set mouse mode to enabled
set mouse=a

" Enable termguicolors for better color support
set termguicolors

" Highlight current line cursor
hi Cursor guifg=green guibg=green

" Highlight secondary cursor
hi Cursor2 guifg=red guibg=red

" Set custom GUI cursors
set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50
