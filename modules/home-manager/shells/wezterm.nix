{ config, pkgs, lib, username, homeDirectory, sops, priv-config, ... }@inputs:
{

  options = {
    custom.shells.wezterm = {
      enable = lib.mkEnableOption "Enable wezterm";
      package = lib.mkOption {
        default = pkgs.wezterm;
        type = lib.types.package;
        description = "wezterm package to install";
      };
      config_file = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = "Path to the wezterm config file";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.shells.wezterm.enable {
      home.packages = [ config.custom.shells.wezterm.package ];
    })
    (lib.mkIf (config.custom.shells.wezterm.config_file != null){
      home.file = {
        ".wezterm.lua".source = config.custom.shells.wezterm.config_file;
      };
    })
  ];

}