{config, pkgs, lib, homeDirectory,...}@inputs:

{

  options = {
    custom.docker.enable = lib.mkEnableOption "Enable custom docker configuration";

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
      description = "Enable extra docker packages";
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

    custom.docker.config.daemon = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "path to the docker daemon config file (if any)";
    };

    custom.docker.config.file = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "path to the docker config file (if any)";
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
        # ssh for colima setup
        programs.ssh.includes = if pkgs.system == "x86_64-darwin" || pkgs.system == "aarch64-darwin" then
            [ "${homeDirectory}/.colima/ssh_config" ]
          else
            [];
    })
    (lib.mkIf config.custom.docker.extra.enable {
      home.packages = with pkgs; config.custom.docker.extra.packages;
    })
    (lib.mkIf (config.custom.docker.config.daemon != null) {
      home.file.".docker/daemon.json".source = config.custom.docker.config.daemon;
    })
    (lib.mkIf (config.custom.docker.config.file != null) {
        
        # Create docker config file
        sops.secrets.dockerconfig = {
          format = "binary";
          sopsFile = config.custom.docker.config.file;
          path = "${homeDirectory}/.docker/config.json";
        };
    })
  ];

}