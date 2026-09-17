-- define HOME
local HOME = os.getenv("HOME") or ""

-- checks if file exists (used for custom configs)
local function is_file_exists(path)
	local f = io.open(path, "r")
	if not f then
		return false
	end
	f:close()
	return true
end

-- require default configs
require("hyprland.style")
require("hyprland.animations")
require("hyprland.autostart")
require("hyprland.env")
require("hyprland.keybinds")
require("hyprland.monitors")
require("hyprland.rules")
require("hyprland.misc")
require("hyprland.input")
require("fullscreen_anims")

-- check if customs exist and import them
if is_file_exists(HOME .. "/.config/hypr/custom/style.lua") then
	require("custom.style")
end

if is_file_exists(HOME .. "/.config/hypr/custom/animations.lua") then
	require("custom.animations")
end

if is_file_exists(HOME .. "/.config/hypr/custom/autostart.lua") then
	require("custom.autostart")
end

if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
	require("custom.env")
end

if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
	require("custom.keybinds")
end

if is_file_exists(HOME .. "/.config/hypr/custom/monitors.lua") then
	require("custom.monitors")
end

if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
	require("custom.rules")
end

if is_file_exists(HOME .. "/.config/hypr/custom/misc.lua") then
	require("custom.misc")
end

if is_file_exists(HOME .. "/.config/hypr/custom/input.lua") then
	require("custom.input")
end
