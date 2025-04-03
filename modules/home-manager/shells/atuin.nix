{ config, pkgs, lib, username, homeDirectory, sops, priv-config, ... }@inputs:
{

  options = {

    ## atuin

    custom.shells.atuin.enable = lib.mkEnableOption "Enable atuin";
    custom.shells.atuin.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.atuin;
      description = "atuin package to install";
    };
    custom.shells.atuin.config = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "path to the atuin config file";
    };
    custom.shells.atuin.key = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "path to the atuin key file";
    };
  };



  config = lib.mkMerge [
    (lib.mkIf config.custom.shells.atuin.enable {
      home.packages = [ config.custom.shells.atuin.package ];
      home.activation = {
      ## Install atuin startup script
        atuinsetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            PATH=$PATH:${lib.makeBinPath (with pkgs; [atuin])}
            $DRY_RUN_CMD atuin init zsh --disable-up-arrow > ${homeDirectory}/.atuin.zsh
        '';
      };

    })
    (lib.mkIf (config.custom.shells.atuin.key != null) {
      sops.secrets = {
        atuin = {
          format = "binary";
          sopsFile = config.custom.shells.atuin.key;
          path = "${homeDirectory}/.local/share/atuin/key";
        };
      };
    })
    (lib.mkIf (config.custom.shells.atuin.config != null) {
      home.file = {
        ".config/atuin/config.toml".source = config.custom.shells.atuin.config;
      };
    })
  ];

}