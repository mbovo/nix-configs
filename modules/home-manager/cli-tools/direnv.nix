{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.cli.direnv.enable = lib.mkEnableOption "Enable direnv";
    custom.cli.direnv.package = lib.mkOption {
      default = pkgs.direnv;
      type = lib.types.package;
      description = "direnv package to install";
    };
    custom.cli.direnv.nix.package = lib.mkOption {
      default = pkgs.nix-direnv;
      type = lib.types.package;
      description = "direnv package to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cli.direnv.enable {
      programs.direnv = {
        enable = true;
        package = config.custom.cli.direnv.package; 
        nix-direnv.enable = true;
        nix-direnv.package = config.custom.cli.direnv.nix.package;
        config = {
          global = {
            hide_env_diff = true;
            warn_timeout = "10s";
          };
        };
      };
    })
  ];

}