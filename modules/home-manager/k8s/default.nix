{ config, pkgs, lib, ... }@inputs:
{

  imports = [
    ./k8s-clients.nix
  ];

}