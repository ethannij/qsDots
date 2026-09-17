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
	size = { "window_w * 0.3", "monitor_h * 0.5" },
})

hl.window_rule({
	name = "Quickshell Test Window",
	match = {
		title = "TestWindow",
	},
	float = true,
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

hl.layer_rule({
	name = "Quickshell, background blur",
	match = { namespace = "quickshell:bar" },
	blur = true,
	ignore_alpha = 0.5,
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

hl.window_rule({
	match = {
		title = "testWindow",
	},
	float = true,
})

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