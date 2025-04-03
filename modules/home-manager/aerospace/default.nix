{config, pkgs, lib, priv-config, ...}@inputs:

{
 
  options = {
    custom.aerospace.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable aerospace config";
    };
    custom.aerospace.config_file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the aerospace config file";
    };
    custom.aerospace.scratchpad_file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the scratchpad file";
    };
  };

  config = lib.mkIf config.custom.aerospace.enable {
    home = {
      file = {
        ".config/aerospace/aerospace.toml".source = config.custom.aerospace.config_file;
        "bin/scratchpad.sh" = {
          source = config.custom.aerospace.scratchpad_file;
          executable = true;
        };
      };
    };
  };
}