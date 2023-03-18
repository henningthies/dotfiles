return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
  },
  config = function()
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local opts = { noremap = true, silent = true }

    vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>", opts)
    vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

    local map = function(bufnr, lhs, rhs)
      vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, opts)
    end

    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- Mappings.
      --map(bufnr, "<space>e", "")


      map(bufnr, "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
      map(bufnr, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
      map(bufnr, "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
      map(bufnr, "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
      map(bufnr, "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
      map(bufnr, "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
      map(bufnr, "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
      map(bufnr, "<space>f", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>")
    end


    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require("lspconfig")

    lspconfig.solargraph.setup {
      capabilities = capabilities,
      filetypes = { "ruby", "rakefile" },
      root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
      --command_path = "/home/henning/.rvm/gems/ruby-3.2.0/bin/solargraph",
      command_path = "~/.rbenv/shims/solargraph",
      on_attach = on_attach,
      settings = {
        solargraph = {
          autoformat = false,
          formatting = false,
          completion = true,
          definition = true,
          hover = true,
          diagnostic = true,
          folding = true,
          references = true,
          rename = true,
          symbols = true,
        },
      },
    }
    lspconfig.clangd.setup {
      capabilities = capabilities,
    }
    lspconfig.tsserver.setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lspconfig.tailwindcss.setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
        },
      },
    }

  end,
}
