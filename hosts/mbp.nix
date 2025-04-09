{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
{
  imports = [
    ./common.nix
  ];
}