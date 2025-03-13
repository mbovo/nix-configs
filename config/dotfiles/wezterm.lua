local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
 config = wezterm.config_builder()
end

-- config.color_scheme = 'Monokai (terminal.sexy)'

config.window_background_opacity = 0.90

config.font = wezterm.font 'Hack Nerd Font Mono'
config.font_size = 14
config.keys = {
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
}


return config
