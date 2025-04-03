{ config, pkgs, lib, ... }@inputs:
{

  imports = [
    ./modern/bat.nix
    ./modern/yazi.nix
  ];

  options = {
    custom.cli.modern.eza = {
      enable = lib.mkEnableOption "Enable custom eza";
      package = lib.mkOption {
        default = pkgs.eza;
        type = lib.types.package;
        description = "eza packages to install";
      };
    };
    custom.cli.modern.fzf = {
      enable = lib.mkEnableOption "Enable custom fzf";
      package = lib.mkOption {
        default = pkgs.fzf;
        type = lib.types.package;
        description = "fzf packages to install";
      };
    };
    custom.cli.modern.ripgrep = {
      enable = lib.mkEnableOption "Enable custom ripgrep";
      package = lib.mkOption {
        default = pkgs.ripgrep;
        type = lib.types.package;
        description = "ripgrep packages to install";
      };
    };
    custom.cli.modern.jq = {
      enable = lib.mkEnableOption "Enable custom jq";
      package = lib.mkOption {
        default = pkgs.jq;
        type = lib.types.package;
        description = "jq packages to install";
      };
    };
    custom.cli.modern.fd = {
      enable = lib.mkEnableOption "Enable custom fd";
      package = lib.mkOption {
        default = pkgs.fd;
        type = lib.types.package;
        description = "fd packages to install";
      };
    };
    custom.cli.modern.extra.enable = lib.mkEnableOption "Enable modern extra packages";
    custom.cli.modern.extra.packages = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.package;
      description = "list of extra modern packages to install";
    };
    custom.cli.modern.extra.default_packages = lib.mkOption {
      default = [
        pkgs.glow
        pkgs.asciinema
        pkgs.devbox
        pkgs.yq
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of default extra modern packages to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.cli.modern.eza.enable {
      programs.eza = {
        enable = true;
        package = config.custom.cli.modern.eza.package;
      };
    })
    (lib.mkIf config.custom.cli.modern.fzf.enable {
      programs.fzf = {
        enable = true;
        package = config.custom.cli.modern.fzf.package;
      };
    })
    (lib.mkIf config.custom.cli.modern.ripgrep.enable {
      programs.ripgrep = {
        enable = true;
        package = config.custom.cli.modern.ripgrep.package;
      };
    })
    (lib.mkIf config.custom.cli.modern.jq.enable {
      programs.jq = {
        enable = true;
        package = config.custom.cli.modern.jq.package;
      };
    })
    (lib.mkIf config.custom.cli.modern.fd.enable {
      programs.fd = {
        enable = true;
        package = config.custom.cli.modern.fd.package;
      };
    })
    (lib.mkIf config.custom.cli.modern.extra.enable {
      home.packages = config.custom.cli.modern.extra.packages;
    })
  ];

}