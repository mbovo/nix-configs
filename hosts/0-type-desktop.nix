{ config, pkgs, username, homeDirectory, sops, lib, self,... }@inputs:
{

  home = {
    inherit username homeDirectory;
    
    keyboard.layout = "it";
    stateVersion = "23.11"; # don't change it
    activation = {
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

  ## Custom configs (see modules/home-manager/*)

  custom = {

    cli = {
      direnv.enable = true;
      editor.enable = true;
      nix-utils.enable = true;

      modern = {
        bat.enable = true;
        yazi.enable = true;
        eza.enable = true;
        fd.enable = true;
        ripgrep.enable = true;
        jq.enable = true;
        fzf.enable = true;
        extra.enable = true;
      };
    };

    dev.python.enable = true;

    fonts.nerdFonts.enable = true;

    git = {
      enable = true;
      config.username = "Manuel Bovo";
      config.email = "manuel.bovo@gmail.com";
      config.gitignore_global = ../config/dotfiles/gitignore_global;
    };

    secTools.enable = true;
    ssh.enable = true;

    shells = {
      zsh.enable = true;
      zsh.extra.files = {
        ".zshrc" = ../config/dotfiles/zshrc;
        ".zsh_alias" = ../config/dotfiles/zsh_alias;
        ".zsh_funx" = ../config/dotfiles/zsh_funx;
        ".p10k.zsh" = ../config/dotfiles/p10k.zsh;
        ".config/atuin/config.toml" = ../config/dotfiles/config/atuin/config.toml;
      };

      atuin.enable = true;
      atuin.key = "${inputs.priv-config}/common/dotfiles/local/share/atuin/atuin.key";
      atuin.config = ../config/dotfiles/config/atuin/config.toml;

      wezterm.enable = false;
      wezterm.config_file = ../config/dotfiles/wezterm.lua;
    };

  };
}