{ config, pkgs, lib, ...}@inputs:
let
  pdh_repo = import (pkgs.fetchFromGitHub {
      owner = "mbovo";
      repo = "pdh";
      rev = "main";
      sha256 = "";
    }) {
      inherit (pkgs) system;
    };

in
{

  options = {
    myhome.apps.pdh.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enable PDH pagerduty cli";
    };
  };

  config = lib.mkIf config.myhome.apps.pdh.enable {
    home.packages = with pdh_repo; [
      pdh
    ];
  };

}