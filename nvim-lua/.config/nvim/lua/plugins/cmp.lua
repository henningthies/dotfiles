return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require "cmp"
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = {
          width = 80,
        },
      },
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<CR>"] = cmp.mapping.confirm(),
      },

      sources = cmp.config.sources({
        { name = "path", keyword_length = 2 },
        { name = "nvim_lsp", keyword_length = 2},
        { name = "buffer" , keyword_length = 2 },
        { name = "luasnip" , keyword_length = 1 },
      })
    })

    require("luasnip/loaders/from_vscode").lazy_load()
    require("luasnip").filetype_extend("ruby", { "rails" })
  end,
}
