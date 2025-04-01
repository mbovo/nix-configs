{ config, pkgs, lib, ... }@inputs:
{


  options = {
    custom.dev.vault.enable = lib.mkEnableOption "Enable custom vault configuration";

    custom.dev.vault.package = lib.mkOption {
      default = pkgs.vault;
      type = lib.types.package;
      description = "vault package to install";
    };

    custom.dev.vault.extraPackages = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.package;
      description = "list of extra vault packages to install";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.dev.vault.enable {

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (pkgs.lib.getName pkg) [
          "vault"
        ];

      home.packages = [
        config.custom.dev.vault.package
      ] ++ config.custom.dev.vault.extraPackages;
    })
  ];


}