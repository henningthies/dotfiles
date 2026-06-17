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

    -- Prefer a version-manager-managed ruby-lsp (so it picks up the project's
    -- ruby + bundle). Mason's ruby-lsp is intentionally ignored: it launches
    -- with system ruby and breaks on projects that pin a different version.
    -- We probe the shim with --version because the shim file exists even
    -- when the gem is missing from the active ruby (rbenv prints "command
    -- not found" and exits 127).
    local ruby_lsp_cmd
    for _, candidate in ipairs({
      "~/.local/share/mise/shims/ruby-lsp",
      "~/.rbenv/shims/ruby-lsp",
    }) do
      local path = vim.fn.expand(candidate)
      if vim.fn.executable(path) == 1 then
        local probe = vim.system({ path, "--version" }, { text = true }):wait()
        if probe.code == 0 then
          ruby_lsp_cmd = path
          break
        end
      end
    end
    if ruby_lsp_cmd then
      vim.lsp.config("ruby_lsp", { cmd = { ruby_lsp_cmd } })
    end

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    -- Exclude ruby_lsp from automatic_enable; we only want it when a
    -- version-manager shim is present (handled below).
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "ts_ls", "tailwindcss" },
      automatic_enable = { exclude = { "ruby_lsp" } },
    })

    local servers = { "lua_ls", "ts_ls", "tailwindcss" }
    if ruby_lsp_cmd then
      table.insert(servers, "ruby_lsp")
    end
    vim.lsp.enable(servers)

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

        map("n", "gd", vim.lsp.buf.definition, "Goto definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "<space>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end,
    })
  end,
}
