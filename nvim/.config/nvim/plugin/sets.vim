" set modelines=0
set number
"set relativenumber
set ruler
set noshowmode
set encoding=utf-8
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set backspace=indent,eol,start
set autoindent
set list listchars=tab:\ \ ,trail:·
set visualbell
set shell=/bin/zsh
set hidden
set laststatus=2
set wildmenu
set wildmode=list:longest
set wildignore+=gems/gems/*,doc/*,tmp/*,vendor/gems/*,.git,*.rbc,*.class,.svn,*.o,*.obj,public/assets/*,*.png,*.log,*.jpg,*.svg,*.gif,.bundle
set wildignore+=*/node_modules
set wildignore+=*/log
set wildignore+=*/tmp
set wildignore+=*/fonts

" Search
set ignorecase " search case insensitive unless...
set smartcase  " ...search phrase contains a capital letter
set incsearch
set showmatch
set hlsearch " highlight searches and unhighlight search results with <space>

" used for undotree
set nobackup
set undodir=~/.vim/undodir
set undofile
set timeoutlen=250  " Time to wait after ESC
set noswapfile

" setp options for cmp
set completeopt=menu,menuone,noselect
" max height of autocomplete
set pumheight=10

set termguicolors
