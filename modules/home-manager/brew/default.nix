{config, pkgs, lib, priv-config, ...}@inputs:

{
 
  options = {
    custom.brew.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable brew config";
    };
    custom.brew.config_file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the brewfile config";
    };
  };

  config = lib.mkIf config.custom.brew.enable {
    home = {
      file = {
        ".config/brewfile/Brewfile".source = config.custom.brew.config_file;
      };
    };
  };
}