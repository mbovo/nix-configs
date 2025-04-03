{ config, pkgs, lib, username, homeDirectory, sops, priv-config, ... }@inputs:
{

imports = [
    ./zsh.nix
    ./atuin.nix
    ./wezterm.nix
  ];

}