{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.dev.python.enable = lib.mkEnableOption "Enable custom python configuration";

    custom.dev.python.package = lib.mkOption {
      default = pkgs.python3;
      type = lib.types.package;
      description = "python package to install";
    };

    custom.dev.python.extraPackages = lib.mkOption {
      default = [
        pkgs.pipenv
        pkgs.poetry
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of extra python packages to install";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.dev.python.enable {
      home.packages = [
        (config.custom.dev.python.package.withPackages (
            pp: [
              pp.pyyaml
            ]
          ) 
        )
      ] ++ config.custom.dev.python.extraPackages;
    })
  ];

}