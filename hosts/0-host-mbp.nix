{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
{
  # common configurations, if you don't want to use them, remove the import but you'll need to 
  # define at least the following:
  # # home = {
  # #   inherit username homeDirectory;
    
  # #   keyboard.layout = "it";
  # #   stateVersion = "23.11";
  # # }
  imports = [
    ./common.nix
  ];

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
      python = {
        package = inputs.pkgs-unstable.python3;
        extraPackages = with inputs.pkgs-unstable; [
          pipenv
          poetry
        ];
      };
      go.enable = true;
    };

    docker = {
      enable = true;
      config.daemon = "${inputs.priv-config}/common/dotfiles/docker/daemon.json";
      config.file = "${inputs.priv-config}/common/dotfiles/docker/config.json.sops";
    };

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