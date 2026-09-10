local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.encoding = "UTF-8"
opt.termguicolors = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true

-- UI
opt.visualbell = true
opt.pumheight = 10 -- max height of autocomplete
opt.completeopt = "menu,menuone,noselect"

-- Shell
opt.shell = "/bin/zsh"

-- Search
opt.ignorecase = true -- case insensitive unless...
opt.smartcase = true  -- search phrase contains a capital letter
opt.showmatch = true

-- Persistent undo
opt.undodir = os.getenv("HOME") .. "/.undodir"
opt.undofile = true
opt.swapfile = false

opt.timeoutlen = 250 -- Time to wait after ESC / leader key

-- Clipboard in herdr panes: no clipboard tool here and herdr does not answer
-- OSC 52 read queries, so nvim's OSC 52 paste blocks for 10s. Copy keeps going
-- out via OSC 52, paste reads back the unnamed register instead.
if vim.env.HERDR_PANE_ID then
  local osc52 = require("vim.ui.clipboard.osc52")
  local paste = function()
    return vim.split(vim.fn.getreg('"'), "\n")
  end

  vim.g.clipboard = {
    name = "herdr-osc52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
