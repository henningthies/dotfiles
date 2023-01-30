return {
  "skalnik/vim-vroom",
  dependencies = {
    "preservim/vimux",
  },
  config = function()
    vim.api.nvim_set_var('vroom_use_vimux', 1)
    vim.api.nvim_set_var('vroom_use_binstubs', 1)
    vim.api.nvim_set_var('vroom_test_unit_command', "test")
  end
}
