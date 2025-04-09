{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.ssh.enable = lib.mkEnableOption "Enable custom ssh configuration";
    custom.ssh.matchBlocks = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "SSH match blocks for custom ssh configuration";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.custom.ssh.enable) {
     
      programs = {
          ssh = {
            enable = true;
            compression = true;
            extraOptionOverrides = { 
                  PubkeyAcceptedKeyTypes = "+ssh-rsa";
                  HostKeyAlgorithms = "+ssh-rsa";
                };
            matchBlocks = config.custom.ssh.matchBlocks;
          };
        };
    })
  ];
}