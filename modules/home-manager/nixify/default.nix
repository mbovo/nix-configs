{config, pkgs, lib, priv-config, ...}@inputs:

{
 
  options = {
    custom.nixify.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nixify";
    };
    custom.nixify.binary_file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the nixify binary";
    };
    custom.nixify.config_file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the nixify config";
    };
  };

  config = lib.mkIf config.custom.nixify.enable {
    home = {
      file = {
        "bin/nixify" = { 
          source = config.custom.nixify.binary_file;
          executable = true;
        };
        "bin/flake_venv/flake.nix".source = config.custom.nixify.config_file;
      };
    };
  };
}