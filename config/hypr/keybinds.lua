---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "nautilus"
local menu = "quickshell:launcher"
local browser = "floorp"
local sessionManager = "wlogout"
local lock = "hyprlock"
local themeswitcher = "qs ipc call wallpaperSwitcher toggleVisible"
local gamebar = "$HOME/.config/rofi/modules/gamebar/gamebar.sh || pkill rofi"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind("SUPER_L", hl.dsp.global(menu), { ignore_mods = true, non_consuming = true, transparent = true }) -- Open Quickshell App Launcher
hl.bind(
	mainMod .. " + catchall",
	hl.dsp.global("quickshell:launcherInterrupt"),
	{ ignore_mods = true, non_consuming = true }
) -- Pass inputs through to other binds

hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("qs ipc call ipcBar toggleBar"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. "+ SHIFT + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) -- fullscreen
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })) -- maximize
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pin({}))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("$HOME/.config/waybar/waybarrestart.sh"))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd(themeswitcher))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
--hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(sessionManager))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(gamebar))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume and Brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- MultiMedia (Requires playerctl)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- scrolling
--hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
--hl.bind(mainMod .. " + comma", hl.dsp.layout("move -col"))

--hl.bind(mainMod .. " + left", hl.dsp.layout("focus l"))
--hl.bind(mainMod .. " + down", hl.dsp.layout("focus d"))
--hl.bind(mainMod .. " + up", hl.dsp.layout("focus u"))
--hl.bind(mainMod .. " + right", hl.dsp.layout("focus r"))

--hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +conf"))
--hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -conf"))

--hl.bind(mainMod .. " + SHIFT + f", hl.dsp.layout("fit expand"))

--hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("consume_or_expel prev"))
--hl.bind(mainMod .. " + bracketright", hl.dsp.layout("consume_or_expel next"))

--hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("swapcol l"))
--hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("swapcol r"))
