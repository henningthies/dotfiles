return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'windwp/nvim-ts-autotag',
  },
  opts = {
    ensure_installed = { 'ruby', 'javascript', 'html', 'typescript', 'markdown', 'markdown_inline' },
    sync_install = false,
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    autotag = {
      enable = true,
    },
  },
}
