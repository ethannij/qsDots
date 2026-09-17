hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon") -- start wallpaper
	hl.exec_cmd("qs") -- start quickshell
	hl.exec_cmd("hypridle") -- idle daemon
	hl.exec_cmd("hyprsunset") -- Required
	hl.exec_cmd(
		'while inotifywait -e close_write "$HOME/.local/state/quickshell/states.json"; do '
			.. 'hyprctl eval "apply_gamemode_from_state()"; '
			.. "done"
	) -- watch quickshell states and check/apply gamemode on changes
end)
