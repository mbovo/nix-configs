{ config, pkgs, username, homeDirectory, sops, priv-config, ... }@inputs:
{

  home = {
    file = {
      "bin/nixify" = { 
        source = ../../config/flakes/nixify;
        executable = true;
      };
      "bin/flake_venv/flake.nix".source = ../../config/flakes/venv.flake.nix;
    };
  };

}