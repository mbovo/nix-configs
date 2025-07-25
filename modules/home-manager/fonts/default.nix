{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.fonts.nerdFonts.enable = lib.mkEnableOption "Enable nerd fonts";
    custom.fonts.nerdFonts.fonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.nerd-fonts; [ fira-code hack ];
      description = "List of nerd fonts to install.";
    };
  };

  config = (lib.mkIf config.custom.fonts.nerdFonts.enable {
      home.packages = config.custom.fonts.nerdFonts.fonts; #with pkgs.nerd-fonts; [
        #(nerdfonts.override { fonts = config.custom.fonts.nerdFonts.fonts; })
      # ];
    });

}