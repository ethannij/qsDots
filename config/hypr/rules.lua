---------------
---- RULES ----
---------------

hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland.
	-- Do not apply this to Wine/yabridge popups: Neural DSP preset menus
	-- often have an empty title and close immediately if they cannot take focus.
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Neural DSP / yabridge preset and context menus (XWayland popups)
local function yabridge_menu_rule(name, match)
	hl.window_rule({
		name = name,
		match = match,
		float = true,
		no_anim = true,
		no_blur = true,
		no_shadow = true,
		opaque = true,
		decorate = false,
		stay_focused = true,
		no_initial_focus = false,
		focus_on_activate = false,
	})
end

yabridge_menu_rule("yabridge-menu-title", {
	class = "yabridge-host\\.exe\\.so",
	title = "^(menu)$",
})
yabridge_menu_rule("yabridge-menu-empty-title", {
	class = "yabridge-host\\.exe\\.so",
	title = "^$",
})
yabridge_menu_rule("yabridge-host-exe-menu", {
	class = "yabridge-host\\.exe$",
	title = "^(menu)$",
})

hl.window_rule({
	-- center & size pavucontrol
	name = "Volume Control",
	match = {
		class = "org.pulseaudio.pavucontrol",
	},

	float = true,
	center = true,
	size = { "window_w * 3", "monitor_h * 0.5" },
})

hl.window_rule({
	-- center & size blueman-manager
	name = "Bluetooth Control",
	match = {
		class = "blueman-manager",
	},

	float = true,
	center = true,
	size = { "monitor_w * 0.3", "monitor_h * 0.5" },
})

hl.window_rule({
	name = "Quickshell Test Window",
	match = {
		title = "TestWindow",
	},
	float = true,
	rounding = 20,
})

hl.window_rule({
	name = "Quickshell Wifi Manager",
	match = {
		title = "Wifi Manager",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "Quickshell Bluetooth Manager",
	match = {
		title = "Bluetooth Manager",
	},
	float = true,
	center = true,
})

-- swaync layer rule (blur)
hl.layer_rule({
	name = "SwayNC Control Center Blur",
	match = { namespace = "^swaync-control-center$" },
	blur = true,
	ignore_alpha = 0.5,
	animation = "slide right",
})

hl.layer_rule({
	name = "Quickshell, transparent = blur",
	match = { namespace = "^notification panel$" },
	blur = true,
	ignore_alpha = 0.6,
	animation = "slide right",
})

hl.layer_rule({
	name = "Quickshell, background blur",
	match = { namespace = "quickshell:bar" },
	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "SwayNC Notification Blur",
	match = { namespace = "^swaync-notification-window$" },
	blur = true,
	ignore_alpha = 0.2,
	animation = "slide top",
})

-- rofi layer rule (blur)
hl.layer_rule({
	name = "rofi blur",
	match = { namespace = "^rofi$" },
	blur = true,
	ignore_alpha = 0.5,
	animation = "quick",
})

-- rofi layer rule (blur)
hl.window_rule({
	name = "rofi blur",
	match = { class = "^Rofi$" },
	no_blur = true,
	animation = "quick",
})

-- wlogout layer rule (blur)
hl.layer_rule({
	name = "wlogout blur",
	match = { namespace = "^logout_dialog$" },
	blur = true,
	ignore_alpha = 0.5,
})

-- scratchpad vertical workspace transition
hl.workspace_rule({
	workspace = "special:scratchpad",
	animation = "slide",
})

hl.workspace_rule({
	workspace = "special:gamehub",
	on_created_empty = "$HOME/.config/rofi/modules/gamebar/gamebar.sh",
	animation = "none",
})

-- center & size file picker dialogue
hl.window_rule({
	name = "File Picker",
	match = {
		class = "xdg-desktop-portal-gtk",
	},

	float = true,
	center = true,
	size = { "monitor_w = 1582", "monitor_h = 827" },
})

-- Sticky Notes floating
hl.window_rule({
	match = {
		class = "com.vixalien.sticky",
	},
	float = true,
	size = { "window_w = 366", "window_h = 503" },
})

hl.window_rule({
	match = {
		title = "testWindow",
	},
	float = true,
})

-- Steam Properties / Popups
--hl.window_rule({
--	match = {
--		class = "steam",
--		title = "negative:^steam$",
--	},
--	float = true;
--})

-- Mission Center
hl.window_rule({
	match = {
		class = "io.missioncenter.MissionCenter",
	},
	float = true,
	size = { "monitor_w * 0.3", "monitor_h * 0.5" },
	move = { 1792, 100 },
	pin = true,
})

-- VRR rules
hl.window_rule({ match = { class = ".*" }, no_vrr = true })
hl.window_rule({ match = { class = "^tlou-ii.exe$" }, no_vrr = false })
hl.window_rule({ match = { class = "^steam_app_252950$" }, no_vrr = false })
hl.window_rule({ match = { class = "^steam_app_1627720$" }, no_vrr = false })
hl.window_rule({ match = { class = "^steam_app_3633395288$" }, no_vrr = false })
hl.window_rule({ match = { class = "^nms.exe$" }, no_vrr = false })
hl.window_rule({ match = { class = "^gamescope$" }, no_vrr = false })
hl.window_rule({ match = { class = "^steam_appsteam_app_19667200$" }, no_vrr = false })
hl.window_rule({ match = { class = "^blackops3.exe$" }, no_vrr = false })
hl.window_rule({ match = { class = "^steam_app_2366248338$" }, no_vrr = false })
hl.window_rule({ match = { class = "Minecraft* 1.21.1" }, no_vrr = false })
hl.window_rule({ match = { title = "^All The Mods 10 v7.2$" }, no_vrr = false })

--hl.window_rule({match = {class = "^Crimson Desert$"},  no_vrr = true})
