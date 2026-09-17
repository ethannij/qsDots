hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Moga-White")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Moga-White")

-- yabridge: GUI apps (Ardour) do not read ~/.zshrc. Pin the 5.1.1 host and
-- Bottles Wine runner so they are not mixed with yabridge-wine10-git / Wine 10.20.
do
	local home = os.getenv("HOME")
	local path = os.getenv("PATH") or "/usr/bin"
	hl.env("WINELOADER", home .. "/.local/bin/yabridge-wine")
	hl.env("PATH", home .. "/.local/share/yabridge:" .. home .. "/.local/bin:" .. path)
end

hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Moga-White'")
