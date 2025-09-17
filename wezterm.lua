-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font "JetBrainsMono Nerd Font"
config.font_size = 14

config.audible_bell = "Disabled"

-- config.front_end = "WebGpu"

return config
