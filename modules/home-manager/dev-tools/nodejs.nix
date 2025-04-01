{ config, pkgs, lib, ... }@inputs:
{


  options = {
    custom.dev.nodejs.enable = lib.mkEnableOption "Enable custom nodejs configuration";

    custom.dev.nodejs.package = lib.mkOption {
      default = pkgs.nodejs;
      type = lib.types.package;
      description = "nodejs package to install";
    };

    custom.dev.nodejs.extraPackages = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.package;
      description = "list of extra nodejs packages to install";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.dev.nodejs.enable {
      home.packages = [
        config.custom.dev.nodejs.package
      ] ++ config.custom.dev.nodejs.extraPackages;
    })
  ];


}