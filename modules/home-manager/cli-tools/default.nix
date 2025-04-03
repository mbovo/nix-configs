{ config, pkgs, lib, ... }@inputs:
{

  imports = [
    ./direnv.nix
    ./editor.nix
    ./gnu.nix
    ./modern.nix
    ./net-tools.nix
    ./nix.nix
  ];

}