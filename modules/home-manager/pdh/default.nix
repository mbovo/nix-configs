{ config, pkgs, lib, system, ...}@inputs:
let
  pdh_repo = import (pkgs.fetchFromGitHub {
      owner = "mbovo";
      repo = "pdh";
      rev = "52844e2318f69e4c629b4041e621e2ae58e1ef16";
      sha256 = "sha256-Mk1bQns2cv6qGjhc1Vud0YWcUeORwVMmzy+vYrOYcU8=";
    }) {
      inherit (pkgs) system;
    };
  pdh_flake = import "${pdh_repo}/flake.nix";
in
{
  home.packages = [
       pdh_flake.packages.${system}.pdh
   ];
}