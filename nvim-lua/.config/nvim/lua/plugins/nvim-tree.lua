return {
  'nvim-tree/nvim-tree.lua',
  config = function()
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
        icons = {
          webdev_colors = false,
        },
      },
      filters = {
        dotfiles = false,
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
        change_dir = {
          global = true
        }
      },
    })
  end,
}
