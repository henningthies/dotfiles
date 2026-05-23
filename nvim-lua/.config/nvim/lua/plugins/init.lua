return {
  {
    "tpope/vim-projectionist",
    lazy = false,
    init = function()
      -- Rails + RSpec: alternate app/**/*.rb <-> spec/**/*_spec.rb
      vim.g.projectionist_heuristics = {
        ["config/environment.rb&spec/"] = {
          ["app/*.rb"] = {
            alternate = "spec/{}_spec.rb",
            type = "source",
          },
          ["spec/*_spec.rb"] = {
            alternate = "app/{}.rb",
            type = "test",
          },
        },
      }
    end,
  },
  { "vim-ruby/vim-ruby",         ft = { "ruby", "eruby" } },
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby" },
    dependencies = { "tpope/vim-projectionist" },
  },
  { "tpope/vim-rake",            ft = { "ruby", "eruby" } },
  { "tpope/vim-endwise",         ft = { "ruby", "lua", "vim", "sh", "zsh" } },
  { "tpope/vim-surround",        event = "VeryLazy" },
  { "tpope/vim-fugitive",        cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Gblame", "Gstatus" } },
  { "tpope/vim-apathy",          event = "VeryLazy" },
  { "tpope/vim-abolish",         event = "VeryLazy" },
}
