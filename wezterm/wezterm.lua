local wezterm = require("wezterm")

return {
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 16.0,

	macos_window_background_blur = 30,
	-- window_background_opacity = 0.9,
	window_decorations = "RESIZE",

	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},

	default_prog = { "/opt/homebrew/bin/nu" },

	set_environment_variables = {
		XDG_CONFIG_HOME = "/Users/CaseyStratton/.config",
	},

	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
