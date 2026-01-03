-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- _________ Color Schemes I liked at one point ___________
-- config.color_scheme = 'Embers (base16)'
-- config.color_scheme = 'Espresso'
-- config.color_scheme = 'Fahrenheit'
-- config.color_scheme = 'Gnometerm (terminal.sexy)'
-- config.color_scheme = 'Navy and Ivory (terminal.sexy)'
-- config.color_scheme = 'Neutron'
-- config.color_scheme = 'Paul Millr (Gogh)'
-- config.color_scheme = 'Pop (base16)'
-- config.color_scheme = 'Purple People Eater (Gogh)'
-- config.color_scheme = 'rose-pine'
config.color_scheme = "Sex Colors (terminal.sexy)"

local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

-- terminal.sexy color schemes have a green cursor. I don't like that
config.colors = {
	cursor_bg = scheme.foreground,
	cursor_fg = scheme.background,
	cursor_border = scheme.foreground,
}

-- _________ Fonts I liked at one point ___________________
config.font = wezterm.font("Inconsolata Nerd Font")
-- config.font = wezterm.font 'UbuntuMono Nerd Font'
-- config.font = wezterm.font 'Terminess Nerd Font'
config.font_size = 14

config.window_decorations = "TITLE | RESIZE"

config.enable_tab_bar = false

config.window_background_opacity = 0.85

config.initial_rows = 30
config.initial_cols = 80

-- and finally, return the configuration to wezterm
return config
