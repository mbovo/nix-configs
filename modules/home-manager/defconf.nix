{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
{

  imports = [
    ./common.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11"; # don't change it
    activation = {
      ## Add diff changes to home-manager activation
      diffChanges = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          PATH=$PATH:${lib.makeBinPath (with pkgs; [nvd nix-diff])}
          verboseEcho "Diff packages [nvd]"
          run nvd diff $oldGenPath $newGenPath
      '';
    };
  };

  programs = {
    home-manager.enable = true;
  };

  ## Configuring sops key to use
  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
  };

}