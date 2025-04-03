{ config, pkgs, lib, ... }@inputs:
{


  options = {
    custom.dev.go.enable = lib.mkEnableOption "Enable custom go configuration";

    custom.dev.go.package = lib.mkOption {
      default = pkgs.go;
      type = lib.types.package;
      description = "go package to install";
    };

    custom.dev.go.extraPackages = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.package;
      description = "list of extra go packages to install";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.dev.go.enable {
      home.packages = [
        config.custom.dev.go.package
      ] ++ config.custom.dev.go.extraPackages;
    })
  ];


}