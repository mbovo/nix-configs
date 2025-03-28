{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
{

  imports = [
    ./cli-tools.nix
    ./docker.nix
    ./git.nix
    # ./kubernetes.nix
    ./python.nix
    ./sec-tools.nix
    ./zsh.nix
    ./ssh.nix
    ./nixify.nix
    ../modules/home-manager/k8s
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11"; # don't change it
    keyboard.layout = "it";
    activation = {
      ## Add diff changes to home-manager activation
      diffChanges = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          PATH=$PATH:${lib.makeBinPath (with pkgs; [nvd])}
          $DRY_RUN_CMD nvd diff $oldGenPath $newGenPath
      '';
    };
  };

  custom.k8s.enable = true;
  custom.k8s.extra.enable = true;
  custom.k8s.extra.clusterctl.enable = true;
  custom.k8s.extra.kyverno.enable = true;
  custom.k8s.extra.fluxcd.enable = true;
  # custom.k8s.extra.argocd.enable = true;
  # custom.k8s.extra.argocd.package = inputs.pkgs-unstable.argocd;

  programs = {
    home-manager.enable = true;
  };

  ## Configuring sops key to use
  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
  };

  

}