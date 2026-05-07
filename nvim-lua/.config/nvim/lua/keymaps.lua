-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Shortcut for copying to/from System Clipboard
-- copy selecte'
vim.keymap.set("v", "<leader>c", '"+y', { desc = "copy selection" })
-- copy line
vim.keymap.set("n", "<leader>C", '"+Y', { desc = "copy line" })
-- paste below cursor
vim.keymap.set("n", "<leader>p", '"+p', { desc = "paste below cursor" })

-- write file with <leader>s
vim.keymap.set("n", "<leader>s", ":w<cr>", { desc = "[s]ave current file" })

-- Switch between current and previous buffer
vim.keymap.set("n", "<leader><leader>", "<c-^>", { noremap = true, silent = true })

-- clear search highlight with space
vim.keymap.set("n", "<space>", "<cmd> :nohlsearch<Bar>:echo<CR>", { noremap = true, silent = true })

-- map insert mode jk to esc
vim.keymap.set("i", "jk", "<esc>")

-- (Window navigation handled by vim-tmux-navigator)

-- Telescope
vim.keymap.set("n", "<leader>f", "<cmd> Telescope find_files<cr>", { silent = true })
vim.keymap.set("n", "<leader>F", "<cmd> Telescope git_files<cr>", { silent = true })
vim.keymap.set("n", "<leader>g", "<cmd> Telescope grep_string<cr>", { silent = true })
vim.keymap.set("n", "<leader>G", "<cmd> Telescope git_status<cr>", { silent = true })
vim.keymap.set("n", "<leader>b", "<cmd> Telescope buffers<cr>", { silent = true })
vim.keymap.set("n", "<leader>h", "<cmd> Telescope help_tags<cr>", { silent = true })
vim.keymap.set("n", "<leader>d", "<cmd> Telescope diagnostics<cr>", { silent = true })

--- center view after search
vim.keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- create undo breakpoints on .
vim.keymap.set("i", ".", ".<c-g>u", { noremap = true, silent = true })

-- close buffer
vim.keymap.set("n", "<c-x>", ":bd<cr>", { noremap = true, silent = true })

-- yanky
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<leader>z", ":YankyRingHistory<cr>")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

-- ferret
vim.keymap.set("n", "<leader>a", "<Plug>(FerretAckWord)")

-- vim-rails / projectionist: jump to alternate file (class <-> test)
vim.keymap.set("n", "<leader>.", "<cmd>A<cr>", { silent = true, desc = "Alternate file" })
vim.keymap.set("n", "<leader>r", "<cmd>R<cr>", { silent = true, desc = "Related file" })

-- luasnip
vim.keymap.set({ "i" }, "<C-L>", function() require("luasnip").jump(1) end, { silent = true })

-- NerdCommenter-style toggle via built-in gc/gcc (nvim 0.10+)
vim.keymap.set("n", "<leader>c<space>", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("x", "<leader>c<space>", "gc",  { remap = true, desc = "Toggle comment selection" })
