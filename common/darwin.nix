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
      ".yabairc".source = "${priv-config}/common/dotfiles/.yabairc";
      ".skhdrc".source = "${priv-config}/common/dotfiles/.skhdrc";
      "bin/scratchpad.sh" = {
        source = "${priv-config}/common/scripts/scratchpad.sh";
        executable = true;
      };
    };
  };
}