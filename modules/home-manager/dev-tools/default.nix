{ config, pkgs, lib, ... }@inputs:
{

  imports = [
    ./python.nix
    ./pulumi.nix
    ./nodejs.nix
    ./go.nix
    ./vault.nix
  ];

}