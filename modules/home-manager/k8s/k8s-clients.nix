{ config, pkgs, priv-config, lib, ...}@inputs:

{

  options = {
    custom.k8s.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable k8s tools (kubectl, etc...)";
    };

    custom.k8s.packages = lib.mkOption {
      default = [
        pkgs.kubectl
        pkgs.kubectx
        pkgs.kustomize
        pkgs.krew
        pkgs.kubernetes-helm
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of k8s packages to install";
    };

    custom.k8s.extra.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable k8s extra packages";
    };

    custom.k8s.extra.packages = lib.mkOption {
        default = [
          pkgs.kind
          pkgs.stern
          pkgs.kubeconform
        ];
        type = lib.types.listOf lib.types.package;
        description = "list of k8s extra packages to install";
      };

    custom.k8s.extra.clusterctl.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable fluxcd";
    };
    custom.k8s.extra.clusterctl.package = lib.mkOption {
      default = pkgs.clusterctl;
      type = lib.types.package;
      description = "fluxcd package to install";
    };

    custom.k8s.extra.kyverno.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable kind";
    };

    custom.k8s.extra.kyverno.package = lib.mkOption {
      default = pkgs.kyverno;
      type = lib.types.package;
      description = "kind package to install";
    };

    custom.k8s.extra.fluxcd.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable fluxcd";
    };

    custom.k8s.extra.fluxcd.package = lib.mkOption {
      default = pkgs.fluxcd;
      type = lib.types.package;
      description = "fluxcd package to install";
    };


    custom.k8s.extra.argocd.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable argcd";
    };

    custom.k8s.extra.argocd.package = lib.mkOption {
      default = pkgs.argocd;
      type = lib.types.package;
      description = "argcd package to install";
    };

  };

  config = lib.mkMerge [
      (lib.mkIf config.custom.k8s.enable { 
        home.packages = config.custom.k8s.packages;
        home.file = {
            "krew_list".source = ../../../config/krew_list;
          };
      })
      (lib.mkIf config.custom.k8s.extra.enable { 
        home.packages = config.custom.k8s.extra.packages;
      })
      (lib.mkIf config.custom.k8s.extra.clusterctl.enable { 
        home.packages = [ config.custom.k8s.extra.clusterctl.package ];
      })
      (lib.mkIf config.custom.k8s.extra.kyverno.enable { 
        home.packages = [ config.custom.k8s.extra.kyverno.package ];
      })
      (lib.mkIf config.custom.k8s.extra.fluxcd.enable { 
        home.packages = [ config.custom.k8s.extra.fluxcd.package ];
      })
      (lib.mkIf config.custom.k8s.extra.argocd.enable { 
        home.packages = [ config.custom.k8s.extra.argocd.package ];
      })
  ];
}

