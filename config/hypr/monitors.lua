------------------
---- MONITORS ----
-------------------
hl.monitor({
	-- MAIN --
	output = "DP-1",
	mode = "5120x1440@240",
	scale = "1",
	bitdepth = 10,
	cm = "hdredid",
	sdrbrightness = 1.0,
	sdrsaturation = 1.0,
	sdr_min_luminance = 0.005,
	-- Peak 1000: 1000 nits only on ~3% windows. Full-screen / desktop APL
	-- is limited by ABL. MSI rates this QD-OLED at 250 nits SDR and 450 at
	-- 10% APL. Mapping SDR white to 250 on a white page will trip ABL.
	-- 200 nits is the usual ceiling that stays under ABL for desktop SDR.
	sdr_max_luminance = 200,

	min_luminance = 0,
	max_luminance = 1000,
	max_avg_luminance = 200,
})
hl.monitor({
	-- MIRROR (SOUNDBAR) --
	output = "HDMI-A-1",
	--mode = "1920x1080@60",
	--position = "0x1440",
	scale = 1,
	mirror = "DP-1",
})
