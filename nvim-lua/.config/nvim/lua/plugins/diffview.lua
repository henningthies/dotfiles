return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
  -- opts is a function so diffview.actions is required only after the plugin
  -- is on the runtimepath (lazy evaluates this at load time, not at startup).
  opts = function()
    local actions = require("diffview.actions")
    return {
      enhanced_diff_hl = true,
      view = {
        -- side-by-side diff, like a PR
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal" },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 35 },
      },
      keymaps = {
        view = {
          -- cycle through the changed files without leaving the diff
          { "n", "<tab>",     actions.select_next_entry, { desc = "Next changed file" } },
          { "n", "<s-tab>",   actions.select_prev_entry, { desc = "Prev changed file" } },
          { "n", "<leader>e", actions.focus_files,       { desc = "Focus file panel" } },
        },
        file_panel = {
          { "n", "<tab>",   actions.select_next_entry, { desc = "Next changed file" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev changed file" } },
          { "n", "<cr>",    actions.select_entry,      { desc = "Open diff for entry" } },
        },
      },
    }
  end,
}
