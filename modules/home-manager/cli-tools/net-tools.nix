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
  custom.cli.network.tmux.config_file = lib.mkOption {
    default = null;
    type = lib.types.nullOr lib.types.path;
    description = "Path to the tmux config file";
  };
};

config = lib.mkMerge [
  (lib.mkIf config.custom.cli.network.enable {
    home.packages = config.custom.cli.network.packages;
  })
  (lib.mkIf (config.custom.cli.network.tmux.config_file != null) {
    home.file = {
      ".tmux.conf".source = config.custom.cli.network.tmux.config_file;
    };
  })
];

}