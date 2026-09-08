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

-- config.window_decorations = "INTEGRATED_BUTTONS|TITLE|RESIZE"
config.enable_wayland = false -- wezterm relies on xdg-decoration, gnome refused to play nice. fine back to xorg
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.enable_tab_bar = false

config.window_background_opacity = 1.0

config.initial_rows = 30
config.initial_cols = 120

config.enable_scroll_bar = true
config.scrollback_lines = 100000

config.background = {
  -- Layer 1: The random stretched cleanly across the window frame
  {
    source = { File = wezterm.config_dir .. '/Frieren.png' },
    width = 'Cover',
    height = 'Cover',
    vertical_align = 'Top',
    horizontal_align = 'Center',
    repeat_y = 'Repeat',
    repeat_x = 'NoRepeat',
    attachment = { Parallax = 0.1 },
  },

  -- Layer 2: Your black protective tint overlay for text legibility
  {
    source = { Color = scheme.background },
    width = '100%',
    height = '100%',
    opacity = 0.75,
  }
}

-- and finally, return the configuration to wezterm
return config
