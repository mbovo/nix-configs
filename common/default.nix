{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
{

  imports = [
    ./cli-tools.nix
    # ./docker.nix
    # ./git.nix
    # ./kubernetes.nix
    ./python.nix
    ./sec-tools.nix
    # ./zsh.nix
    ./ssh.nix
    ./nixify.nix
    ../modules/home-manager/docker
    ../modules/home-manager/k8s
    ../modules/home-manager/zsh
    ../modules/home-manager/fonts
    ../modules/home-manager/git
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
  custom.docker.enable = true;
  custom.docker.config.daemon = "${inputs.priv-config}/common/dotfiles/docker/daemon.json";
  custom.docker.config.file = "${inputs.priv-config}/common/dotfiles/docker/config.json.sops";

  custom.fonts.nerdFonts.enable = true;  

  custom.zsh.enable = true;
  custom.zsh.extra.files = {
      ".zshrc" = ../config/dotfiles/zshrc;
      ".zsh_alias" = ../config/dotfiles/zsh_alias;
      ".zsh_funx" = ../config/dotfiles/zsh_funx;
      ".p10k.zsh" = ../config/dotfiles/p10k.zsh;
      ".config/atuin/config.toml" = ../config/dotfiles/config/atuin/config.toml;
  };
  custom.atuin.enable = true;
  custom.atuin.key = "${inputs.priv-config}/common/dotfiles/local/share/atuin/atuin.key";
  custom.atuin.config = ../config/dotfiles/config/atuin/config.toml;


  custom.git.enable = true;
  custom.git.config.gitignore_global = ../config/dotfiles/gitignore_global;
  custom.git.gh.config = "${inputs.priv-config}/common/dotfiles/config/gh/hosts.yml.sops";

  programs = {
    home-manager.enable = true;
  };

  ## Configuring sops key to use
  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
  };

  

}