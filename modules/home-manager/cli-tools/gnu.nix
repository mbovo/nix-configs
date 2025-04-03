{ config, pkgs, lib, ... }@inputs:
{

  options = { 
    custom.cli.gnu.enable = lib.mkEnableOption "Enable custom gnu tools";
    custom.cli.gnu.packages = lib.mkOption {
      default = [
        pkgs.bash
        pkgs.tree
        pkgs.htop
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of gnu packages to install";
    };
    custom.cli.gnu.darwin.packages = lib.mkOption {
      default = [
        pkgs.gawk
        pkgs.watch
        pkgs.wget
        pkgs.less
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of gnu packages to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cli.gnu.enable {
      home.packages = if pkgs.system == "x86_64-darwin" || pkgs.system == "aarch64-darwin" then
            config.custom.cli.gnu.packages ++ config.custom.cli.gnu.darwin.packages
          else
            # just install the gnu packages
            [ config.custom.cli.gnu.package ];
    })
  ];

}