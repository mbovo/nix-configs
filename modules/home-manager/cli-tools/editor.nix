{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.cli.editor = {
      enable = lib.mkEnableOption "Enable CLI editor";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.neovim;
        description = "editor package to install";
      };
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "List of extra editor packages to install";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cli.editor.enable {
      home.packages = [
        config.custom.cli.editor.package
      ] ++ config.custom.cli.editor.extraPackages;
      home.sessionVariables = {
        EDITOR = "nvim";
      };
    })
    
  ];
}