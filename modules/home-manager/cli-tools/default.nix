{ config, pkgs, lib, ... }@inputs:
{

  imports = [
    ./editor.nix
    ./nix.nix
    ./direnv.nix
    ./net-tools.nix

    ./gnu.nix
    ./modern.nix
  ];

}