local wezterm = require("wezterm")

return {
	initial_rows = 30,
	initial_cols = 130,
	color_scheme = "Catppuccin Mocha",
	-- color_scheme = "GitHub Dark",
	-- color_scheme = "Everblush",
	-- color_scheme = "Everforest Dark Hard",
	font = wezterm.font_with_fallback({
		"BlexMono Nerd Font Propo Medium",
		"Noto Sans CJK SC",
	}),
	font_size = 13, -- 字体大小
	line_height = 1.1, -- 行高，改善行间紧凑问题
	-- cell_width = 1, -- 字体宽度缩放（避免太挤）
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	adjust_window_size_when_changing_font_size = true,

	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 0,
	},

	-- 透明背景
	window_background_opacity = 0.95,
	text_background_opacity = 1.0,

	-- Alt + hjkl 分屏移动
	keys = {
		{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	},
	-- Window frame
	window_frame = {
		font = require("wezterm").font("CNN Sans Regular"),
		font_size = 13,
	},
}
