"====================================keyboard remap============================================
let mapleader=" "
nnoremap s <nop>
nnoremap Q :q<cr>
nnoremap S :w<cr>
nnoremap R :source $MYVIMRC<cr>
nnoremap n nzz
nnoremap N Nzz
nnoremap <leader><cr> :nohlsearch<cr>

" split right left top bottom
nnoremap sh :set nosplitright<cr>:vsplit<cr>
nnoremap sl :set splitright<cr>:vsplit<cr>
nnoremap sj :set splitbelow<cr>:split<cr>
nnoremap sk :set nosplitbelow<cr>:split<cr>

" focus split on left right top below
nnoremap <LEADER>h <c-w>h
nnoremap <LEADER>l <c-w>l
nnoremap <LEADER>j <c-w>j
nnoremap <LEADER>k <c-w>k

" resize split
nnoremap <up> :resize +5<cr>
nnoremap <down> :resize -5<cr>
nnoremap <left> :vertical resize -5<cr>
nnoremap <right> :vertical resize +5<cr>

" tab behavior
nnoremap T :tabedit<cr>
nnoremap th :-tabnext<cr>
nnoremap tl :+tabnext<cr>

" edit my vimrc file
" nnoremap <LEADER>rc :vsplit $MYVIMRC<cr>
nnoremap <leader>rc :tabedit $MYVIMRC<cr>
nnoremap <leader>rm :tabedit $XDG_CONFIG_HOME/nvim/remap.vim<cr>
nnoremap <leader>cc :tabedit $XDG_CONFIG_HOME/nvim/coc.vim<cr>
nnoremap <leader>vp :tabedit $XDG_CONFIG_HOME/nvim/vim-plug.vim<cr>
nnoremap <leader>is :tabedit $XDG_CONFIG_HOME/nvim/im-sw.vim<cr>
nnoremap <c-g> :tabnew<cr>:term lazygit<cr>i

inoremap Lht<cr> <esc>:set filetype=html<cr>i
inoremap Lsh<cr> <esc>:set filetype=bash<cr>i

"clipboard behavior
nnoremap y "+y
vnoremap y "+y
nnoremap yy "+yy
nnoremap p "+p
nnoremap P "+P
vnoremap d "+d
nnoremap dd "+dd
