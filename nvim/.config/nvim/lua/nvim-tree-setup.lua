vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<cr>", { silent = true})
vim.api.nvim_set_keymap("n", "<leader>nf", ":NvimTreeFindFile<cr>", { silent = true})
