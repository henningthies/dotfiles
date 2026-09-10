return {
  "skalnik/vim-vroom",
  dependencies = {
    "preservim/vimux",
  },
  config = function()
    vim.api.nvim_set_var('vroom_use_vimux', 1)
    vim.api.nvim_set_var('vroom_use_binstubs', 1)
    vim.api.nvim_set_var('vroom_test_unit_command', "rails test")

    -- vroom ruft für jeden Testlauf VimuxRunCommand(). Unter herdr gibt es
    -- kein tmux, also zeigt die Funktion dort auf das herdr-Pane statt auf
    -- vimux. Unter tmux bleibt das echte vimux unangetastet.
    local mux = require("multiplexer")
    if mux.pane then
      _G.__herdr_run_test = mux.run
      vim.cmd([[
        function! VimuxRunCommand(command, ...) abort
          call v:lua.__herdr_run_test(a:command)
        endfunction
      ]])
    end
  end
}
