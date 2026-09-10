-- Brücke zum umgebenden Multiplexer.
--
-- Unter tmux erledigen das vim-tmux-navigator und vimux. Herdr bringt keine
-- vim-Integration mit, hat aber eine Pane-API (`herdr pane ...`) — dieses
-- Modul baut die beiden Verhalten darüber nach:
--   * navigate() — ctrl+h/j/k/l wechselt Fenster, am Rand weiter ins Nachbar-Pane
--   * run()      — schickt ein Kommando in ein wiederverwendetes Test-Pane
--
-- Aktiv nur, wenn nvim in einem Herdr-Pane läuft (HERDR_PANE_ID gesetzt).

local M = {}

M.pane = vim.env.HERDR_PANE_ID
if M.pane == "" then
  M.pane = nil
end

local function herdr(args)
  local cmd = { "herdr" }
  vim.list_extend(cmd, args)
  local res = vim.system(cmd, { text = true }):wait()
  return res.code == 0, res.stdout or ""
end

local directions = { h = "left", j = "down", k = "up", l = "right" }

-- Erst innerhalb von nvim bewegen; bleibt das Fenster gleich, waren wir am
-- Rand und Herdr übernimmt.
function M.navigate(key)
  local from = vim.api.nvim_get_current_win()
  pcall(vim.cmd.wincmd, key)
  if vim.api.nvim_get_current_win() ~= from then
    return
  end
  if M.pane then
    herdr({ "pane", "focus", "--pane", M.pane, "--direction", directions[key] })
  end
end

local test_pane

-- Das Test-Pane überlebt zwischen Läufen; ist es weg (manuell geschlossen),
-- wird ein neues aufgemacht.
local function ensure_test_pane()
  if test_pane and herdr({ "pane", "get", test_pane }) then
    return test_pane
  end

  local ok, out = herdr({
    "pane", "split",
    "--pane", M.pane,
    "--direction", "down",
    "--ratio", "0.4",
    "--no-focus",
    "--cwd", vim.fn.getcwd(),
  })
  if not ok then
    return nil
  end

  test_pane = out:match('"pane_id":"([^"]+)"')
  return test_pane
end

-- Läuft im Pane noch ein Test, abbrechen. Ohne den Check würde jeder Lauf ein
-- überflüssiges ^C in die Prompt-Zeile schreiben.
local function interrupt(pane)
  local ok, out = herdr({ "pane", "process-info", "--pane", pane })
  if not ok then
    return
  end
  local shell = out:match('"shell_pid":(%d+)')
  local foreground = out:match('"foreground_process_group_id":(%d+)')
  if foreground and foreground ~= shell then
    herdr({ "pane", "send-keys", pane, "ctrl+c" })
  end
end

-- Ersatz für VimuxRunCommand.
function M.run(command)
  local pane = ensure_test_pane()
  if not pane then
    vim.notify("herdr: konnte kein Test-Pane öffnen", vim.log.levels.ERROR)
    return
  end

  interrupt(pane)
  herdr({ "pane", "send-keys", pane, "ctrl+u" })
  herdr({ "pane", "send-text", pane, command })
  herdr({ "pane", "send-keys", pane, "enter" })
end

return M
