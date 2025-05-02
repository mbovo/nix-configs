{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.dev.pulumi.enable = lib.mkEnableOption "Enable custom pulumi configuration";

    custom.dev.pulumi.package = lib.mkOption {
      default = pkgs.pulumi;
      type = lib.types.package;
      description = "pulumi package to install";
    };

    custom.dev.pulumi.extraPackages = lib.mkOption {
      default = [
        pkgs.pulumiPackages.pulumi-language-python
        #pkgs.pulumiPackages.pulumi-language-go
        #pkgs.pulumiPackages.pulumi-language-typescript
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of extra pulumi packages to install";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.dev.pulumi.enable {
      home.packages = [
        config.custom.dev.pulumi.package
      ] ++ config.custom.dev.python.extraPackages;
    })
  ];

}