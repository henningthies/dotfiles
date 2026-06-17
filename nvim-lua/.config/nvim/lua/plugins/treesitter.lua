return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  dependencies = {
    'windwp/nvim-ts-autotag',
  },
  config = function()
    require('nvim-treesitter').install({
      'ruby', 'javascript', 'html', 'typescript',
      'markdown', 'markdown_inline',
      'lua', 'vim', 'vimdoc',
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'ruby', 'javascript', 'html', 'typescript', 'markdown', 'lua', 'vim', 'help' },
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        if vim.bo[args.buf].filetype ~= 'ruby' then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require('nvim-ts-autotag').setup()
  end,
}
