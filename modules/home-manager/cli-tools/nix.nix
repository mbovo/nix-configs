{ config, pkgs, lib, ... }@inputs:
{

 options = {

  custom.cli.nix-utils.enable = lib.mkEnableOption "Enable Nix CLI tools";
  custom.cli.nix-utils.extraPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [
      pkgs.nix-diff
      pkgs.nvd
      pkgs.nil
      pkgs.nix-output-monitor
      pkgs.statix
    ];
    description = "List of extra Nix CLI packages to install";
  };  

 };

 config = lib.mkMerge [
   (lib.mkIf config.custom.cli.nix-utils.enable {
     home.packages = config.custom.cli.nix-utils.extraPackages;
   })
 ];
}