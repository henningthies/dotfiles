-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Beide Monitore nutzen omarchy_monitor_scale, damit das Scaling aus dem
-- Omarchy-Menü (das diese Variable oben umschreibt) greift und erhalten bleibt.
local scale = tonumber(omarchy_monitor_scale) or 1

-- Der BenQ hat bei gleicher Diagonale (27") 1440p statt 1080p. Faktor 1.25
-- gleicht das weitgehend aus (exakt gleich groß wäre 4/3).
local benq_scale = scale * 1.25

-- HDMI-A-1 (Iiyama PL2770H) - links, vertikal
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = scale, transform = 3 })

-- DP-1 (BenQ PD2705Q) - rechts, 1440p, normal ausgerichtet
-- x = logische Breite des hochkant stehenden Iiyama (1080 / scale)
-- y = vertikal mittig zum Iiyama (der steht physisch oben und unten über)
local benq_x = math.floor(1080 / scale + 0.5)
local benq_y = math.floor((1920 / scale - 1440 / benq_scale) / 2 + 0.5)
hl.monitor({ output = "DP-1", mode = "2560x1440@60", position = benq_x .. "x" .. benq_y, scale = benq_scale })

-- Workspace 9 an den HDMI-Monitor binden
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", default = true })
