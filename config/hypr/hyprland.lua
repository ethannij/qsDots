require("autostart")
require("monitors")
require("env")
require("keybinds")
require("rules")
require("animations")
require("fullscreen_anims")
local colors = require("colors")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,

		border_size = 2,

		col = {
			active_border = colors.primary,
			inactive_border = colors.surface,
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		--allow_tearing = true,

		layout = "dwindle",
	},

	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.5,
		focus_fit_method = 1,
		explicit_column_widths = "0.25, 0.333, 0.40, 0.50, 0.667, 1.0",
		follow_focus = true,
	},

	render = {
		cm_auto_hdr = 0,
		direct_scanout = 0,
	},

	decoration = {
		rounding = 14,
		rounding_power = 10,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 4,
			passes = 2,
			vibrancy = 0.1696,
		},
	},

	cursor = {
		no_warps = true,
		inactive_timeout = 3,
		no_break_fs_vrr = true,
	},

	debug = {
		full_cm_proto = true,
		--vfr = false,
		--overlay = true
	},

	--animations = {
	--    enabled = false,
	--},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
		disable_splash_rendering = true,
		vrr = 2,
		session_lock_xray = true,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		-- Keep Wine/yabridge dropdowns from closing when the cursor enters the popup.
		mouse_refocus = false,
		accel_profile = "flat",
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})
