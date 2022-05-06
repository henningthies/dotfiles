call plug#begin('~/.config/nvim/plugged')


Plug 'tpope/vim-surround'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/YankRing.vim'
Plug 'vim-scripts/Rename2'
Plug 'vim-ruby/vim-ruby'
Plug 'ngmy/vim-rubocop'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tsaleh/vim-align'
Plug 'skalnik/vim-vroom'
Plug 'preservim/vimux'
Plug 'machakann/vim-highlightedyank'
Plug 'ap/vim-css-color'
Plug 'junegunn/goyo.vim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Native LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'mileszs/ack.vim'

Plug 'akinsho/toggleterm.nvim'

" Colorscheme
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'

Plug 'vimwiki/vimwiki'

Plug 'rainerborene/vim-reek'

" Generate images from code snipped
Plug 'kristijanhusak/vim-carbon-now-sh'

" Initialize plugin system
call plug#end()

let mapleader=","
"
" use the silver searcher instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'

"
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Have sane search regexpes
"nnoremap / /\v
"vnoremap / /\v

" Movement
" Have screen-line j/k instead of file-line
nnoremap j gj
nnoremap k gk

" Jump between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
noremap <S-J> <C-W>j<C-W>_
noremap <S-K> <C-W>k<C-W>_
noremap <S-L> <C-W>l<C-W>_
noremap <S-H> <C-W>h<C-W>_
" make backtick behave like ' for marks
nnoremap ` '

" Filetypes
au BufRead,BufNewFile {Gemfile,Rakefile} set ft=ruby
au BufNewFile,BufRead *.json set ft=javascript

" Shortcut for copying to/from System Clipboard
" copy selected
vmap <leader>c "+y
" copy line
nmap <leader>C "+Y
" paste below cursor
nmap <leader>p "+p

" Opens an edit command with the path of the currently edited file filled in
cnoremap %% <C-R>=expand("%:p:h")."/"<CR>
map <leader>e :e %%

" Switch between current and previous buffer
nnoremap <leader><leader> <c-^>
" Close current Buffer
nnoremap <leader>d :bnext\|bdelete #<CR>
" nnoremap <leader>d :b#<bar>bd#<CR>

au WinLeave * set nocursorline
au WinEnter * set cursorline
"
" use the silver searcher instead of ack
"let g:ackprg = 'ag --nogroup --nocolor --column'

" map insert mode jk to esc
inoremap jk <esc>

" toggle NERDTree
map <leader>n :NERDTreeToggle<cr>

" edit and reload config
nnoremap <leader>ev <cmd>vsp $MYVIMRC<cr>
nnoremap <leader>sv <cmd>source $MYVIMRC<cr>

" save the current buffer
map <leader>s :w<cr>
" map :Q->:q :W->:w
map :Q :q<cr>
map :W :w<cr>

" disable Ex-modus
map Q <Nop>

" move between search results and center the resul
nnoremap n nzzzv
nnoremap N Nzzzv

" create undo breakpoints on .
inoremap . .<c-g>u

" move lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" ------------------------ configuration for lsp + nvim-cmp + lspkind ------------------------------------------------
lua require('completion')
lua require('statusbar')
lua require('term')
