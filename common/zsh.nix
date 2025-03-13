{ config, pkgs, username, homeDirectory, sops, priv-config, ... }@inputs:
{

  home = {
    packages =  with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
      zsh
      oh-my-zsh
      zsh-powerlevel10k
      atuin
    ];

    file = {
      ".zshrc".source = ../config/dotfiles/zshrc;
      ".zsh_alias".source = ../config/dotfiles/zsh_alias;
      ".zsh_funx".source = ../config/dotfiles/zsh_funx;
      ".p10k.zsh".source = ../config/dotfiles/p10k.zsh;
      ".atuin.zsh".source = ../config/dotfiles/atuin.zsh;
      ".config/atuin/config.toml".source = ../config/dotfiles/config/atuin/config.toml;
    };
  };

  sops = {
    secrets = { 
      atuin = {
        format = "binary";
        sopsFile = "${priv-config}/common/dotfiles/local/share/atuin/atuin.key";
        path = "${homeDirectory}/.local/share/atuin/key";
      };
    };
  };
}