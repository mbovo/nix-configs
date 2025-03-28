{ config, pkgs, lib, ...}@inputs:

{
  nixpkgs.config.allowUnsupportedSystem = true;
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };
}