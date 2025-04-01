{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.cli.yazi.enable = lib.mkEnableOption "Enable custom yazi";
    custom.cli.yazi.package = lib.mkOption {
      default = pkgs.yazi;
      type = lib.types.package;
      description = "yazi packages to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cli.yazi.enable {
      programs.yazi = {
        enable = true;
        package = config.custom.cli.yazi.package;
        enableZshIntegration = true;
        settings = {
          log = {
            enabled = false;
          };
          manager = {
            show_hidden = true;
            sort_by = "modified";
            sort_dir_first = true;
            sort_reverse = true;
          };
        };
      };
    })
  ];

}