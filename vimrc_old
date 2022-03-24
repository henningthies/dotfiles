" are we on a mac?
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    let isMac = 1
  else
    let isMac = 0
  endif
endif

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'vim-scripts/Rename2'
Plugin 'vim-scripts/ZoomWin'
Plugin 'vim-ruby/vim-ruby'
Plugin 'ngmy/vim-rubocop'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdcommenter.git'
Plugin 'scrooloose/nerdtree.git'
Plugin 'tsaleh/vim-align'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'arcticicestudio/nord-vim'
Plugin 'skalnik/vim-vroom'
Plugin 'preservim/vimux'
Plugin 'wincent/Command-T'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'dbeniamine/cheat.sh-vim'
Plugin 'machakann/vim-highlightedyank'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let mapleader=","

set modelines=0

set number " line numbers
set ruler
set encoding=utf-8 " Encoding to UTF-8

" Whitespace and syntax stuff
syntax on
"color nord
colorscheme nord
" set wrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set backspace=indent,eol,start
set autoindent
set list listchars=tab:\ \ ,trail:·

" misc
set visualbell
set ttyfast
set lazyredraw " buffer screen redraws instead of updating all the time
set shell=/bin/sh
"set mouse=nicr "enable mouse selection and scrolling

set hidden " Allow unsafed buffers
set wildignore+=gems/gems/*,doc/*,tmp/*,vendor/gems/*,.git,*.rbc,*.class,.svn,*.o,*.obj,public/assets/*,*.png,*.log,*.jpg,*.svg,*.gif,.bundle
set wildmenu
set wildmode=list:longest
set laststatus=2 " always display the status line
set showcmd

" Search
set ignorecase " search case insensitive unless...
set smartcase  " ...search phrase contains a capital letter
set incsearch
set showmatch
set hlsearch " highlight searches and unhighlight search results with <space>
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Have sane search regexpes
nnoremap / /\v
vnoremap / /\v

" Movement
" Have screen-line j/k instead of file-line
nnoremap j gj
nnoremap k gk
" use jj in insert mode to go back to normal mode
inoremap jj <ESC>
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

if isMac
  " copy stuff to the macs clipboard
  vmap <leader>c "+y
endif

" Mappings
" Opens an edit command with the path of the currently edited file filled in
cnoremap %% <C-R>=expand("%:p:h")."/"<CR>
map <leader>e :e %%
" Switch between current and previous buffer
nnoremap <leader><leader> <c-^>
" Close current Buffer
nnoremap <leader>d :bnext\|bdelete #<CR>
" nnoremap <leader>d :b#<bar>bd#<CR>

" Vim internals
" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set timeoutlen=250  " Time to wait after ESC
set nobackup
set noswapfile

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1
let g:lang_user_options='|| exit 0'

" Plugins

" Command-T
let g:CommandTMaxHeight=20
map <leader>t :CommandTFlush<cr>\|:CommandT<cr>
map <leader>f :CommandT<cr>
map <leader>b :CommandTBuffer<cr>
"set wildignore+=node_modules/**
"set wildignore+=log/**
"set wildignore+=tmp/**
set wildignore+=*/node_modules
set wildignore+=*/log
set wildignore+=*/tmp
set wildignore+=*/fonts

" YankRing
nnoremap <silent> <leader>z :YRShow<CR>
let g:highlightedyank_highlight_duration = 200

" Powerline
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline_section_y = ''
let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0
let g:airline_theme='nord'

" Vroom
let g:vroom_use_vimux=1

" Youcompleteme
let g:ycm_complete_in_comments_and_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

au WinLeave * set nocursorline
au WinEnter * set cursorline
"
" use the silver searcher instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" toggle NERDTree
map <leader>n :NERDTreeToggle<cr>
" redraw screen
map <leader>. :redraw!<cr>
"
" map :Q->:q :W->:w
map :Q :q<cr>
map :W :w<cr>
map :E :e<cr>
