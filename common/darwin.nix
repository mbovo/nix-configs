{config, pkgs, priv-config, ...}@inputs:

{
  home = {
    file = {
      ".config/brewfile/Brewfile".source = "${priv-config}/hosts/${inputs.hostname}/dotfiles/Brewfile";
      ".config/aerospace/aerospace.toml".source = ../config/dotfiles/config/aerospace/aerospace.toml;
      "bin/scratchpad.sh" = {
        source = ../config/scripts/scratchpad.sh;
        executable = true;
      };
    };
  };
}