{ config, pkgs, homeDirectory, sops, pdh, priv-config, ...}:
{ 
  home = {
    packages = with pkgs; [ 
      (python3.withPackages 
        (pp: [
          pp.pyyaml
        ]
        )
      )
      pdh.cli
    ];
  };
  
  sops = {
    secrets = {
      pdh = {
        format = "binary";
        sopsFile = "${priv-config}/common/dotfiles/config/pdh.yaml.sops";
        path = "${homeDirectory}/.config/pdh.yaml";
      };
    };
  };
}

