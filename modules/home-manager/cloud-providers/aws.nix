{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.cloudProviders.aws.enable = lib.mkEnableOption "Enable AWS CLI configuration";

    custom.cloudProviders.aws.package = lib.mkOption {
      default = pkgs.awscli2;
      type = lib.types.package;
      description = "AWS CLI package to install";
    };

    custom.cloudProviders.aws.extraPackages = lib.mkOption {
      default = [
        pkgs.eksctl
        pkgs.steampipe
      ];
      type = lib.types.listOf lib.types.package;
      description = "List of extra AWS CLI packages to install";
    };

    custom.cloudProviders.aws.extraConfig = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Extra AWS CLI configuration file";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cloudProviders.aws.enable {
      home.packages = [
        config.custom.cloudProviders.aws.package
      ] ++ config.custom.cloudProviders.aws.extraPackages;
    })
    (lib.mkIf (config.custom.cloudProviders.aws.extraConfig != null) {
      # Add extra AWS CLI configuration if provided
      sops = {
        secrets = { 
          awsconfig = {
            format = "binary";
            sopsFile = config.custom.cloudProviders.aws.extraConfig;
            path = "${inputs.homeDirectory}/.aws/config";
            mode = "0600";
          };
        };
      };
    })
  ];
}