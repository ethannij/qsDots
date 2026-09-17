hl.on("hyprland.start", function()
	hl.exec_cmd("nmcli d wifi hotspot ifname wlan0 ssid ethannij-AP password Ethan1007") -- start wifi hotspot
	hl.exec_cmd("sleep 5; $HOME/Git/hyperhdr/build/bin/hyperhdr -d") -- start ambilight capture
	hl.exec_cmd("solaar -w hide") -- start logitech mouse software
	hl.exec_cmd("awww-daemon") -- start wallpaper
	-- hl.exec_cmd("waybar") -- [Replaced by qs] start waybar
	hl.exec_cmd("qs") -- start quickshell
	--hl.exec_cmd("swaync") -- [Replaced by qs] notification daemon
	hl.exec_cmd("hypridle") -- idle daemon
	--hl.exec_cmd("$HOME/.config/rofi/modules/themeswitcher/wallpaper-cycle.sh") [Replaced by qs] -- check if autocycle wallpapers or die
	hl.exec_cmd("hyprsunset") -- Required
	--hl.exec_cmd("$HOME/.config/waybar/hyprsunset.sh") [Repalced by qs] -- waybar integrated hyprsunset script
	-- hl.exec_cmd("$HOME/.config/hypr/scripts/waybar_auto_hide") -- autohide script for waybar
	hl.exec_cmd(
		'while inotifywait -e close_write "$HOME/.local/state/quickshell/states.json"; do '
			.. 'hyprctl eval "apply_gamemode_from_state()"; '
			.. "done"
	)
end)
