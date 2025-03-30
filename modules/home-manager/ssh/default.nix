{ config, pkgs, lib, ... }@inputs:
{

  options = {
    custom.ssh.enable = lib.mkEnableOption "Enable custom ssh configuration";
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
            matchBlocks = {
              "*.i.zroot.org" = {
                forwardAgent = true;
                forwardX11 = true;
              };
            };
          };
        };
    })
  ];
}