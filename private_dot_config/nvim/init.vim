"=================================================vim setttings================================================="
set number
set cursorline
set relativenumber
set autoindent
set noexpandtab
set wildmenu
set ruler
set showmode
set showcmd
set scrolloff=5
set list
set listchars+=precedes:<,extends:>
set mouse=a
set encoding=utf-8
set wrap
set shiftround		"used for >> & << command to round indent
set nocompatible
set syntax
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

"Stop the search at the end of the file
set nowrapscan
set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase

"=================================================Source other setttings================================================="
source $XDG_CONFIG_HOME/nvim/coc.vim
source $XDG_CONFIG_HOME/nvim/remap.vim
source $XDG_CONFIG_HOME/nvim/vim-plug.vim
source $XDG_CONFIG_HOME/nvim/im-sw.vim
