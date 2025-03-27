{ config, pkgs, lib, ...}@inputs:

{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };
}