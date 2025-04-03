{ config, pkgs, lib, username, homeDirectory, sops, priv-config, ... }@inputs:
{

  options = {
    custom.zsh.enable = lib.mkEnableOption "Enable custom zsh configuration";
    custom.zsh.packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [
        pkgs.zsh
        pkgs.oh-my-zsh
        pkgs.zsh-powerlevel10k
        pkgs.atuin
      ];
      description = "List of custom zsh packages to install.";
    };

    custom.zsh.extra.files = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      description = "List of extra configuration files to linkto the home directory.";
    };
  };



  config = lib.mkMerge [
    (lib.mkIf config.custom.zsh.enable {
      home.packages = config.custom.zsh.packages;
    })
    (lib.mkIf (config.custom.zsh.extra.files != {}) {
      home.file = lib.genAttrs (builtins.attrNames config.custom.zsh.extra.files) (name: {
        source = config.custom.zsh.extra.files.${name};
      });
    })
  ];

}