{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
let 
  pkgs_pulumi_latest = import (pkgs.fetchFromGitHub {
    owner = "NixOs";
    repo = "nixpkgs";
    rev = "123109b0034ea3232ed168a5763994bdd3049e3d"; # https://github.com/NixOS/nixpkgs/pull/409671
    sha256 = "sha256-SC4vkQAVZYN6R7ceQr+rca0tbPvGzJoT/HL1OBNIkUk=";
  }) {
    inherit (pkgs) system;
  };
in
{
  imports = [];

  custom = {

    cli = {
      gnu.enable = true;
      network.enable = true;
      network.tmux.config_file = ../config/dotfiles/tmux.conf;

      # use devbox from pkgs-unstable instead of the default
      modern.extra.packages = (lib.lists.remove pkgs.devbox config.custom.cli.modern.extra.default_packages) ++ [ inputs.pkgs-unstable.devbox ];
    };

    # using python from pkgs-unstable
    dev = {
      pulumi.enable = true;
      pulumi.package = pkgs_pulumi_latest.pulumi-bin;
      pulumi.extraPackages = [];   # needed to avoid collision with the default pulumi package
      #   pkgs_pulumi_latest.pulumiPackages.pulumi-language-python
      # ];
      python = {
        package = inputs.pkgs-unstable.python3;
        extraPackages = with inputs.pkgs-unstable; [
          pipenv
          poetry
        ];
      };
      go.enable = true;
      vault.enable = true;
      nodejs = {
        enable = true;
        package = pkgs.nodejs_22;
      };
    };

    docker.enable = true;
    
    cloudProviders.aws.enable = true;

    git.gh.package = inputs.pkgs-unstable.gh;

    k8s = {
      enable = true;
      extra.enable = true;
      extra.clusterctl.enable = true;
      extra.kyverno.enable = true;
      extra.fluxcd.enable = true;
    };

    nixify = {
      enable = true;
      binary_file = ../config/flakes/nixify;
      config_files = {
        "bin/flake_venv/flake.nix" = ../config/flakes/venv.nix;
        "bin/flake_helm/flake.nix" = ../config/flakes/helm.nix;
      };
    };
  };

}