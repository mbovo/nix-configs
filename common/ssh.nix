{ config, pkgs, username, homeDirectory, sops, ... }@inputs:
{

  programs = {
    ssh = {
      enable = true;
      includes = [
        "${homeDirectory}/.colima/ssh_config"
      ];
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
  

}