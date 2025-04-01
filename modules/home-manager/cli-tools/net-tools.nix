{ config, pkgs, lib, ... }@inputs:
{

options = {
  custom.cli.network.enable = lib.mkEnableOption "Enable custom network tools";

  custom.cli.network.packages = lib.mkOption {
    default = [
      pkgs.wget
      pkgs.curl
      pkgs.mtr
      pkgs.nmap
      pkgs.hping
      pkgs.iperf
      pkgs.mtr
      pkgs.tmux
    ];
    type = lib.types.listOf lib.types.package;
    description = "list of network tools to install";
  };
};

}