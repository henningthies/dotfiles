call plug#begin('~/.config/nvim/plugged')

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rails'
"Plug 'tpope/vim-rake'
"Plug 'tpope/vim-bundler'
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-apathy'
Plug 'vim-scripts/YankRing.vim'
Plug 'vim-scripts/Rename2'
"Plug 'ngmy/vim-rubocop'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
"Plug 'tsaleh/vim-align'
Plug 'skalnik/vim-vroom'
Plug 'preservim/vimux'
Plug 'machakann/vim-highlightedyank'
"Plug 'ap/vim-css-color'
Plug 'junegunn/goyo.vim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kelly-lin/telescope-ag'

" Native LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'mileszs/ack.vim'

Plug 'akinsho/toggleterm.nvim'

" Colorscheme
Plug 'rmehri01/onenord.nvim'
Plug 'EdenEast/nightfox.nvim' 

Plug 'lervag/wiki.vim'

"Plug 'rainerborene/vim-reek'

" Generate images from code snipped
Plug 'kristijanhusak/vim-carbon-now-sh'

Plug 'wuelnerdotexe/vim-astro'

" Initialize plugin system
call plug#end()

let mapleader=","
"
" use the silver searcher instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'

"
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Have sane search regexpes
nnoremap / /\v
vnoremap / /\v

" Movement
" Have screen-line j/k instead of file-line
nnoremap j gj
nnoremap k gk

" Jump between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
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

nnoremap <leader>q :bufdo bwipeout <CR>

au WinLeave * set nocursorline
au WinEnter * set cursorline

" map insert mode jk to esc
inoremap jk <esc>

" toggle NERDTree
map <leader>n :NERDTreeToggle<cr>
map <leader>nf :NERDTreeFind<cr>
let NERDTreeShowHidden=1

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
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" create undo breakpoints on .
inoremap . .<c-g>u

lua require('completion')
lua require('statusbar')
lua require('term')
lua require('treesitter')
lua require('mytelescope')
lua require('color')
