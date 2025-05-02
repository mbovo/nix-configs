{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
let 
  pkgs_pulumi_latest = import (pkgs.fetchFromGitHub {
    owner = "NixOs";
    repo = "nixpkgs";
    rev = "82d80188faaa69a6dfa7e5c3f624e653d6943368";
    sha256 = "sha256-WXVaAtpvV/FJ0PT598b1MZ+qpBFP+s9raEDVDrMLj2c=";
  }) {
    inherit (pkgs) system;
  };
in
{

  # Darwin specific configuration

  custom = {
    aerospace = {
      enable = true;
      config_file = ../config/dotfiles/config/aerospace/aerospace.toml;
      scratchpad_file = ../config/scripts/scratchpad.sh;
    };

    brew = {
      enable = true;
      config_file = "${inputs.priv-config}/hosts/${inputs.hostname}/dotfiles/Brewfile";
    };

    cli = {
      gnu.enable = true;
      network.enable = true;
      network.tmux.config_file = ../config/dotfiles/tmux.conf;
    };

    dev = {
      pulumi.enable = true;
      pulumi.package = pkgs_pulumi_latest.pulumi;
      pulumi.extraPackages = [
        pkgs_pulumi_latest.pulumiPackages.pulumi-language-python
      ];
    };
  };

}