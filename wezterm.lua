-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font "JetBrainsMono Nerd Font"
config.font_size = 14

config.audible_bell = "Disabled"

-- Kime's Wayland frontend fails on this KDE setup; use its XIM backend.
if wezterm.target_triple:find("linux") and os.getenv("XMODIFIERS") == "@im=kime" then
  config.enable_wayland = false
  config.use_ime = true
  config.xim_im_name = "kime"
end

-- config.front_end = "WebGpu"

return config
