{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.cli.modern.yazi.enable = lib.mkEnableOption "Enable custom yazi";
    custom.cli.modern.yazi.package = lib.mkOption {
      default = pkgs.yazi;
      type = lib.types.package;
      description = "yazi packages to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cli.modern.yazi.enable {
      programs.yazi = {
        enable = true;
        package = config.custom.cli.modern.yazi.package;
        enableZshIntegration = true;
        settings = {
          log = {
            enabled = false;
          };
          mgr = {
            show_hidden = true;
            sort_by = "mtime";
            sort_dir_first = true;
            sort_reverse = true;
          };
        };
      };
    })
  ];

}