{ config, pkgs, lib, ... }@inputs:
{

  imports = [
    ./aws.nix
    ./gcp.nix
    ./azure.nix
    ./digitalocean.nix
  ];

}