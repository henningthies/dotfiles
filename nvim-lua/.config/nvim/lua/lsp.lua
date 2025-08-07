vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  root_markers = { '.git' },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

local map = function(bufnr, lhs, rhs)
  vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, opts)
end

local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.

  map(bufnr, "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map(bufnr, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map(bufnr, "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  map(bufnr, "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  map(bufnr, "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  map(bufnr, "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  map(bufnr, "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  map(bufnr, "<space>f", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>")
end

vim.lsp.config('solargraph', {
  capabilities = capabilities,
  filetypes = { "ruby", "rakefile" },
  on_attach = on_attach,
  --command_path = "~/.rbenv/shims/solargraph",
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>", opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
