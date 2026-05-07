return {
  'nvim-tree/nvim-tree.lua',
  cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeOpen", "NvimTreeFocus" },
  keys = {
    { "<leader>n",  ":NvimTreeToggle<cr>",   silent = true, desc = "Toggle file tree" },
    { "<leader>nf", ":NvimTreeFindFile<cr>", silent = true, desc = "Reveal file in tree" },
  },
  opts = {
    sort_by = "case_sensitive",
    view = { width = 30 },
    renderer = {
      group_empty = true,
      icons = { webdev_colors = false },
    },
    filters = { dotfiles = false },
    actions = {
      open_file = { window_picker = { enable = false } },
      change_dir = { global = true },
    },
  },
}
