{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:

let 
  pkgs_pulumi_latest = import (pkgs.fetchFromGitHub {
    owner = "NixOs";
    repo = "nixpkgs";
    rev = "d222d01cd2ea050af63ae3ac1e151e9b0f7f6aac"; 
    sha256 = "sha256-8ILBMTB3tU4etacU9JcmUtO+gDoWE4TmhlK+hSyy/zk=";
    #sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # placeholder
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
    docker.darwin.packages = [inputs.pkgs-unstable.qemu inputs.pkgs-unstable.lima inputs.pkgs-unstable.colima];

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