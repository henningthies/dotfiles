return {
  "AlexvZyl/nordic.nvim",
  enable = false,
  lazy = false,
  priority = 1000,
  config = function()
      require 'nordic' .load()
  end
}
