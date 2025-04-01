{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.secTools.enable = lib.mkEnableOption "Enable security tools";

    custom.secTools.packages = lib.mkOption {
      default = [
        # Certificates & Encryption & Secrets
        pkgs.cfssl
        pkgs.age
        pkgs.gnupg24
        pkgs.sops
      ];
      type = lib.types.listOf lib.types.package;
      description = "List of extra security tools to install";
    };


    custom.secTools.extra.enable = lib.mkEnableOption "Enable extra security tools";

    custom.secTools.extra.packages = lib.mkOption {
      default = [
        pkgs.bitwarden-cli
      ];
      type = lib.types.listOf lib.types.package;
      description = "List of extra security tools to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.secTools.enable {
      home.packages = config.custom.secTools.packages;
    })
    (lib.mkIf config.custom.secTools.extra.enable {
      home.packages = config.custom.secTools.extra.packages;
    })
  ];


}