{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.fonts.nerdFonts.enable = lib.mkEnableOption "Enable nerd fonts";
    custom.fonts.nerdFonts.fonts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "FiraCode" "Hack" ];
      description = "List of nerd fonts to install.";
    };
  };

  config = (lib.mkIf config.custom.fonts.nerdFonts.enable {
      home.packages = with pkgs; [
        (nerdfonts.override { fonts = config.custom.fonts.nerdFonts.fonts; })
      ];
    });

}