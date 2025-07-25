{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:

let 
  pkgs_pulumi_latest = import (pkgs.fetchFromGitHub {
    owner = "NixOs";
    repo = "nixpkgs";
    rev = "907bb98c27fef5b8f8c1526ca9bf4a51ffa40055"; 
    sha256 = "sha256-XwPsGDjSid2BJxZlHBm5nYKSWT6TQxJCF8V3m+alQc4=";
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
      pulumi.extraPackages = [];
      #   inputs.pkgs-unstable.pulumiPackages.pulumi-language-python
      # ];
      python = {
        package = inputs.pkgs-unstable.python3;
        extraPackages = with inputs.pkgs-unstable; [
          pipenv
          poetry
        ];
      };
      go.enable = true;
    };

    docker.enable = true;

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