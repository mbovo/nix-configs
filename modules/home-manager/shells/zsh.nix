{ config, pkgs, lib, username, homeDirectory, sops, priv-config, ... }@inputs:
{

  options = {
    custom.shells.zsh.enable = lib.mkEnableOption "Enable custom zsh configuration";
    custom.shells.zsh.packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [
        pkgs.zsh
        pkgs.oh-my-zsh
        pkgs.zsh-powerlevel10k
        pkgs.atuin
      ];
      description = "List of custom zsh packages to install.";
    };

    custom.shells.zsh.extra.files = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      description = "List of extra configuration files to linkto the home directory.";
    };
  };



  config = lib.mkMerge [
    (lib.mkIf config.custom.shells.zsh.enable {
      home.packages = config.custom.shells.zsh.packages;
    })
    (lib.mkIf (config.custom.shells.zsh.extra.files != {}) {
      home.file = lib.genAttrs (builtins.attrNames config.custom.shells.zsh.extra.files) (name: {
        source = config.custom.shells.zsh.extra.files.${name};
      });
    })
  ];

}