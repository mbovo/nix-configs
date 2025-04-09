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
    custom.nixify.config_files = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
      default = null;
      description = "List of paths to the nix flake for nixify";
    };
  };

  config = lib.mkMerge [ 
    (lib.mkIf config.custom.nixify.enable {
      home.file = { "bin/nixify" = { 
          source = config.custom.nixify.binary_file;
          executable = true;
          };
        };
    })

    (lib.mkIf (config.custom.nixify.config_files != null) {
      home.file = lib.genAttrs (builtins.attrNames config.custom.nixify.config_files) (name: {
            source = config.custom.nixify.config_files.${name};
          });
    })
  ];

}