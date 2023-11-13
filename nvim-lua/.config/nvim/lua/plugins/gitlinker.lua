return {
  "ruifm/gitlinker.nvim",
  config = function ()
    local gitlinker = require"gitlinker"
    gitlinker.setup({
      callbacks = {
        ["gitlab.sumcumo.net"] = require"gitlinker.hosts".get_gitlab_type_url,
      },
    })
  end
}

