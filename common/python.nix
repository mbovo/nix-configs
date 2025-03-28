{ config, pkgs, homeDirectory, sops, priv-config, ...}@inputs:
{ 
  home = {
    # using unstable to install python3.12
    packages = with inputs.pkgs-unstable; [ 
      (python3.withPackages 
        (pp: [
          pp.pyyaml
        ]
        )
      )
      # pdh.cli
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

