-----------------------
---- LOOK AND FEEL ----
-----------------------

local colors = require("colors")
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
		rounding = 10,
		rounding_power = 4,

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