{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.cloudProviders.gcp.enable = lib.mkEnableOption "Enable GCP CLI configuration";
    custom.cloudProviders.gcp.package = lib.mkOption {
      default = pkgs.google-cloud-sdk;
      type = lib.types.package;
      description = "GCP CLI package to install";
    };
    custom.cloudProviders.gcp.withExtraComponents = lib.mkOption {
      default = [
        config.custom.cloudProvider.gcp.package.components.gke-gcloud-auth-plugin
      ];
      type = lib.types.listOf lib.types.package;
      description = "List of extra GCP CLI packages to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cloudProviders.gcp.enable {
      home.packages = [
        config.custom.cloudProviders.gcp.package
      ] 
      ++ [
        config.custom.cloudProvider.gcp.package.withExtraComponents (with config.custom.cloudProvider.gcp.package.components; config.custom.cloudProvider.gcp.withExtraComponents)
      ];
    })
  ];

}