{config, pkgs, lib, priv-config, homeDirectory,...}@inputs:

{

  options = {
    custom.docker.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable docker tools (docker, docker-compose, etc...)";
    };

    custom.docker.package = lib.mkOption {
      default = pkgs.docker;
      type = lib.types.package;
      description = "docker package to install";
    };

    custom.docker.darwin.packages = lib.mkOption {
      default = [
        pkgs.qemu
        pkgs.lima
        pkgs.colima
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of extra packages to install on darwin systems";
    };

    custom.docker.extra.enable = lib.mkOption {
      default = config.custom.docker.enable;
      type = lib.types.bool;
      description = "enable docker extra packages";
    };

    custom.docker.extra.packages = lib.mkOption {
      default = [
        pkgs.docker-compose
        pkgs.docker-buildx
        pkgs.dive
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of docker packages to install";
    };
  };

  config = lib.mkMerge [ 
    
    (lib.mkIf (config.custom.docker.enable) {
        # Enable docker4mac in case of macOS
        home.packages = if pkgs.system == "x86_64-darwin" || pkgs.system == "aarch64-darwin" then
            [ config.custom.docker.package ] ++ config.custom.docker.darwin.packages
          else
            # just install docker
            [ config.custom.docker.package ];

        # Create docker daemon config file
        home.file.".docker/daemon.json".source = "${priv-config}/common/dotfiles/docker/daemon.json";

        # Create docker config file
        sops.secrets.dockerconfig = {
          format = "binary";
          sopsFile = "${priv-config}/common/dotfiles/docker/config.json.sops";
          path = "${homeDirectory}/.docker/config.json";
        };
    })
    (lib.mkIf config.custom.docker.extra.enable {
      home.packages = with pkgs; config.custom.docker.extra.packages;
    })
  ];

}