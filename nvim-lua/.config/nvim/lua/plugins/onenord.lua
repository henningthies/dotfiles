return {
  'rmehri01/onenord.nvim',
  config = function()
    --local colors = require("onenord.colors").load()
    require('onenord').setup({
      theme = nil, -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
      custom_highlights = {
        --["@constructor"] = { fg = colors.dark_blue },
      },
    })
  end,
}
