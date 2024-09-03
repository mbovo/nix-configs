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
      ".zshrc".source = "${priv-config}/common/dotfiles/.zshrc";
      ".zsh_alias".source = "${priv-config}/common/dotfiles/.zsh_alias";
      ".zsh_funx".source = "${priv-config}/common/dotfiles/.zsh_funx";
      ".p10k.zsh".source = "${priv-config}/common/dotfiles/.p10k.zsh";
      ".atuin.zsh".source = "${priv-config}/common/dotfiles/.atuin.zsh";
      ".config/atuin/config.toml".source = "${priv-config}/common/dotfiles/config/atuin/config.toml";
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