{ config, pkgs, lib, username, homeDirectory, sops, priv-config, ... }@inputs:
{

  options = {

    ## atuin

    custom.atuin.enable = lib.mkEnableOption "Enable atuin";
    custom.atuin.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.atuin;
      description = "atuin package to install";
    };
    custom.atuin.config = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "path to the atuin config file";
    };
    custom.atuin.key = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "path to the atuin key file";
    };
  };



  config = lib.mkMerge [
    (lib.mkIf config.custom.atuin.enable {
      home.packages = [ config.custom.atuin.package ];
      home.activation = {
      ## Install atuin startup script
        atuinsetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            PATH=$PATH:${lib.makeBinPath (with pkgs; [atuin])}
            $DRY_RUN_CMD atuin init zsh --disable-up-arrow > ${homeDirectory}/.atuin.zsh
        '';
      };

    })
    (lib.mkIf (config.custom.atuin.key != null) {
      sops.secrets = {
        atuin = {
          format = "binary";
          sopsFile = config.custom.atuin.key;
          path = "${homeDirectory}/.local/share/atuin/key";
        };
      };
    })
    (lib.mkIf (config.custom.atuin.config != null) {
      home.file = {
        ".config/atuin/config.toml".source = config.custom.atuin.config;
      };
    })
  ];

}