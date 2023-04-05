vim.o.number = true
vim.o.encoding = "UTF-8"
vim.o.relativenumber = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.visualbell = true

vim.o.shell = "/bin/zsh"

-- Search
vim.o.ignorecase = true -- search case insensitive unless...
vim.o.smartcase  = true -- search phrase contains a capital letter
vim.o.showmatch = true

-- undotree
vim.opt.undodir = os.getenv( "HOME" ) .. '/.undodir'

vim.o.undofile = true
vim.o.timeoutlen=250 -- Time to wait after ESC
vim.o.swapfile = false

vim.o.completeopt = "menu,menuone,noselect"
-- vim.o.termguicolors = true
-- max height of autocomplete
vim.o.pumheight = 10
