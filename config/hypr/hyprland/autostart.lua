hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon") -- start wallpaper
	hl.exec_cmd("qs") -- start quickshell
	hl.exec_cmd("hypridle") -- idle daemon
	hl.exec_cmd("hyprsunset") -- Required
end)
