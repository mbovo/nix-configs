{ config, pkgs, pkgs-unstable, priv-config, ...}:
{
  home = {
    file = {
      ".tmux.conf".source = ../config/dotfiles/tmux.conf;
      ".wezterm.lua".source = ../config/dotfiles/wezterm.lua;
    };

  };
}
