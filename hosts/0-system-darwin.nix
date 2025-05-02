{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
{

  # Darwin specific configuration

  custom = {
    aerospace = {
      enable = true;
      config_file = ../config/dotfiles/config/aerospace/aerospace.toml;
      scratchpad_file = ../config/scripts/scratchpad.sh;
    };

    brew = {
      enable = true;
      config_file = "${inputs.priv-config}/hosts/${inputs.hostname}/dotfiles/Brewfile";
    };

    cli = {
      gnu.enable = true;
      network.enable = true;
      network.tmux.config_file = ../config/dotfiles/tmux.conf;
    };
  };

}