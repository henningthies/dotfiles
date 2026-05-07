return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
    { "mason-org/mason.nvim", opts = {} },
  },
  config = function()
    require("mason").setup()

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("*", { capabilities = capabilities })

    -- Use mise-managed ruby-lsp instead of Mason's
    vim.lsp.config("ruby_lsp", {
      cmd = { vim.fn.expand("~/.local/share/mise/shims/ruby-lsp") },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "ts_ls", "tailwindcss" },
      automatic_enable = true,
    })

    vim.lsp.enable({ "lua_ls", "ts_ls", "tailwindcss", "ruby_lsp" })

    -- Diagnostics (avoid <space>* to keep <space> = clear-search snappy)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
        end

        map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
        map("n", "gd", vim.lsp.buf.definition, "Goto definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "<leader>lD", vim.lsp.buf.type_definition, "Type definition")
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>lf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end,
    })
  end,
}
