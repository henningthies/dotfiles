-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Aus der alten hyprland.conf übernommen (Quattro-Upgrade)

-- Nochmal dieselbe Workspace-Taste springt zum vorherigen Workspace zurück
hl.config({ binds = { workspace_back_and_forth = true } })

-- Alle Fenster ohne Transparenz (überschreibt Omarchys default-opacity 0.985/0.96)
o.window(".*", { opacity = "1 1" })

-- Kein Rahmen, wenn nur ein Fenster auf dem Workspace sichtbar ist
for _, ws in ipairs({ "w[tv1]", "f[1]" }) do
  hl.workspace_rule({ workspace = ws, gaps_out = 0, gaps_in = 0 })
  o.window({ float = false, workspace = ws }, { border_size = 0, rounding = 0 })
end
