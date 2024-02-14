return {
  'rmehri01/onenord.nvim',
  config = function()
    require('onenord').setup({
      theme = nil, -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
    })
  end,
}
