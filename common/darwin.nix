{config, pkgs, priv-config, ...}@inputs:

{
  home = {
    packages = with pkgs; [
      # GNU tools
      gawk
      tree
      watch
      wget

      # Currently installed with
      #yabai
      #skhd
    ];

    file = {
      ".config/brewfile/Brewfile".source = "${priv-config}/hosts/${inputs.hostname}/dotfiles/Brewfile";
      ".yabairc".source = "${priv-config}/common/dotfiles/.yabairc";
      ".skhdrc".source = "${priv-config}/common/dotfiles/.skhdrc";
      ".config/aerospace/aerospace.toml".source = "${priv-config}/common/dotfiles/config/aerospace/aerospace.toml";
      "bin/scratchpad.sh".source = "${priv-config}/common/scripts/scratchpad.sh";
      "bin/scratchpad.sh".executable = true;
    };
  };
}