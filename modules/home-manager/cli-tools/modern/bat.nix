{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.cli.modern.bat.enable = lib.mkEnableOption "Enable custom bat";
    custom.cli.modern.bat.package = lib.mkOption {
      default = pkgs.bat;
      type = lib.types.package;
      description = "bat packages to install";
    };
    custom.cli.modern.bat.theme = lib.mkOption {
      default = "Monokai Extended";
      type = lib.types.str;
      description = "bat theme to use";
    };
    custom.cli.modern.bat.extra.packages = lib.mkOption {
      default = [
        pkgs.bat-extras.batdiff
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of bat packages to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cli.modern.bat.enable {
      home.packages = config.custom.cli.modern.bat.extra.packages;
      programs.bat = {
        package = config.custom.cli.modern.bat.package;
        enable = true;
        config = {
          theme = config.custom.cli.modern.bat.theme;
        };
      };
    })
  ];

}