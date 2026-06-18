-- Lightweight code-review annotations for Claude.
--
-- Workflow:
--   1. Open a diff (DiffviewOpen / <leader>vd).
--   2. Put the cursor on a line (or select a range) on the *right* (current) side
--      and add a comment with <leader>va.
--   3. Navigate comments via the quickfix list (<leader>vl, then ]q / [q).
--   4. Export to .claude/review.md with <leader>ve and hand it to Claude.

local M = {}

-- Each annotation: { file = <relpath>, lnum = <int>, end_lnum = <int>, text = <str>, lines = { <code> } }
M.annotations = {}
M.base = nil -- the diff base we are reviewing against (for the export header)

local function git_root()
  local out = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })
  if vim.v.shell_error ~= 0 or not out[1] then
    return vim.fn.getcwd()
  end
  return out[1]
end

-- Turn a buffer name into a path relative to the git root. Handles diffview://
-- URIs by stripping the scheme/object prefix so comments made on either side of
-- the diff resolve to the real file.
local function relpath(name)
  if name == "" then return "[no name]" end
  -- diffview:///path/to/repo/.git/<rev>/<file>  ->  <file>
  local stripped = name:gsub("^diffview://", "")
  local abs = vim.fn.fnamemodify(stripped, ":p")
  local root = git_root() .. "/"
  if abs:sub(1, #root) == root then
    return abs:sub(#root + 1)
  end
  return vim.fn.fnamemodify(name, ":.")
end

-- Detect the default branch (origin/HEAD), falling back to main/master.
function M.default_base()
  local head = vim.fn.systemlist({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })[1]
  if vim.v.shell_error == 0 and head and head ~= "" then
    return head -- e.g. "origin/main"
  end
  for _, b in ipairs({ "main", "master" }) do
    vim.fn.systemlist({ "git", "rev-parse", "--verify", b })
    if vim.v.shell_error == 0 then return b end
  end
  return "HEAD"
end

-- A floating-window input prompt. Unlike vim.ui.input (which uses the command
-- line), a long comment wraps inside the window instead of overflowing the
-- cmdline and triggering Neovim's hit-enter prompt.
local function floating_input(prompt, on_confirm)
  local width = math.min(80, vim.o.columns - 4)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = 1,
    style = "minimal",
    border = "rounded",
    title = " " .. prompt .. " ",
    title_pos = "left",
  })
  vim.wo[win].wrap = true

  local done = false
  local function finish(value)
    if done then return end
    done = true
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    on_confirm(value)
  end

  local function confirm()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    finish(table.concat(lines, " "))
  end

  vim.keymap.set({ "i", "n" }, "<CR>", confirm, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function() finish(nil) end, { buffer = buf })
  vim.keymap.set("n", "q", function() finish(nil) end, { buffer = buf })

  vim.cmd("startinsert")
end

local function refresh_quickfix()
  local items = {}
  for _, a in ipairs(M.annotations) do
    table.insert(items, {
      filename = a.file,
      lnum = a.lnum,
      text = a.text,
    })
  end
  vim.fn.setqflist({}, "r", { title = "Claude Review (" .. (M.base or "?") .. ")", items = items })
end

-- Add a comment at the cursor (normal) or over the visual selection.
function M.add(opts)
  opts = opts or {}
  local buf = 0
  local name = vim.api.nvim_buf_get_name(buf)
  local file = relpath(name)

  local lnum, end_lnum
  if opts.range then
    lnum = vim.fn.line("'<")
    end_lnum = vim.fn.line("'>")
  else
    lnum = vim.api.nvim_win_get_cursor(0)[1]
    end_lnum = lnum
  end

  local code = vim.api.nvim_buf_get_lines(buf, lnum - 1, end_lnum, false)

  floating_input("Review @ " .. file .. ":" .. lnum, function(input)
    if not input or input == "" then return end
    table.insert(M.annotations, {
      file = file,
      lnum = lnum,
      end_lnum = end_lnum,
      text = input,
      lines = code,
    })
    refresh_quickfix()
    vim.notify(("Review-Kommentar gespeichert (%d gesamt)"):format(#M.annotations))
  end)
end

-- Open the quickfix list with all comments (navigate with ]q / [q).
function M.list()
  if #M.annotations == 0 then
    vim.notify("Keine Review-Kommentare", vim.log.levels.WARN)
    return
  end
  refresh_quickfix()
  vim.cmd("copen")
end

-- Remove all comments.
function M.clear()
  M.annotations = {}
  vim.fn.setqflist({}, "r", { title = "Claude Review", items = {} })
  vim.notify("Review-Kommentare gelöscht")
end

-- Export to a Markdown file Claude can read.
function M.export(opts)
  opts = opts or {}
  if #M.annotations == 0 then
    vim.notify("Keine Review-Kommentare zum Exportieren", vim.log.levels.WARN)
    return
  end

  local path = opts.path or (git_root() .. "/.claude/review.md")
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

  -- Group annotations by file, preserving first-seen order.
  local by_file, order = {}, {}
  for _, a in ipairs(M.annotations) do
    if not by_file[a.file] then
      by_file[a.file] = {}
      table.insert(order, a.file)
    end
    table.insert(by_file[a.file], a)
  end

  local out = {
    "# Code Review",
    "",
    "Diff: `" .. (M.base or "?") .. "...HEAD`",
    "",
    "Bitte arbeite die folgenden Review-Kommentare ein. Jeder Kommentar bezieht",
    "sich auf die zitierte Stelle.",
    "",
  }

  for _, f in ipairs(order) do
    table.insert(out, "## " .. f)
    table.insert(out, "")
    table.sort(by_file[f], function(x, y) return x.lnum < y.lnum end)
    for _, a in ipairs(by_file[f]) do
      local loc = a.end_lnum > a.lnum
        and ("L%d-%d"):format(a.lnum, a.end_lnum)
        or ("L%d"):format(a.lnum)
      table.insert(out, ("### %s"):format(loc))
      table.insert(out, "")
      table.insert(out, "```")
      for _, l in ipairs(a.lines) do
        table.insert(out, l)
      end
      table.insert(out, "```")
      table.insert(out, "")
      table.insert(out, "💬 " .. a.text)
      table.insert(out, "")
    end
  end

  vim.fn.writefile(out, path)
  vim.notify("Review exportiert: " .. path)
  return path
end

-- Open Diffview against the (auto-detected) base branch, PR-style.
function M.open_diff(base)
  M.base = base or M.default_base()
  vim.cmd("DiffviewOpen " .. M.base .. "...HEAD --imply-local")
  vim.notify("Diff gegen " .. M.base)
end

return M
