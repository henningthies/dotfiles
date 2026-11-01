-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Aus bindings.conf übernommen (Quattro-Upgrade)

-- Screenshots auf SUPER + DELETE (SUPER+CTRL+Delete war: Toggle laptop display)
hl.unbind("SUPER + CTRL + Delete")
o.bind("SUPER + DELETE", "Screenshot of region", "omarchy-capture-screenshot region")
o.bind("SUPER + SHIFT + DELETE", "Screenshot of window", "omarchy-capture-screenshot windows")
o.bind("SUPER + CTRL + DELETE", "Screenshot of display", "omarchy-capture-screenshot fullscreen")

-- Close window
o.bind("SUPER + SHIFT + Q", "Close active window", hl.dsp.window.close())

-- Control tiling (SUPER+SHIFT+F war: File manager, SUPER+F war: Full screen)
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + F")
o.bind("SUPER + SHIFT + F", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + F", "Maximize active window", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Move focus with SUPER + hjkl
-- (SUPER+K war: Keybindings, SUPER+J war: Toggle window split, SUPER+L war: Toggle workspace layout)
hl.unbind("SUPER + K")
hl.unbind("SUPER + J")
hl.unbind("SUPER + L")
o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))

-- Swap active window with SUPER + SHIFT + hjkl
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + K", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Groups
o.bind("SUPER + SHIFT + T", "Toggle window grouping", hl.dsp.group.toggle())
o.bind("SUPER + SHIFT + CTRL + RIGHT", "Next window in group", hl.dsp.group.next())
o.bind("SUPER + SHIFT + CTRL + LEFT", "Previous window in group", hl.dsp.group.prev())

-- Voxtype Toggle auf Caps Lock (Keycode 66, da caps:none der Taste kein Keysym lässt):
-- einmal drücken startet, nochmal drücken stoppt und transkribiert.
-- Ersetzt den evdev-Hotkey von Voxtype, der die input-Gruppe bräuchte.
o.bind("code:66", "Toggle dictation", "voxtype record toggle")
