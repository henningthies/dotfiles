vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable netrw in favour of nvim-tree (must run before plugins load)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.FerretMap = 0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("settings")
require("lazy").setup("plugins")
require("keymaps")
