{paths, inputs, outputs, ...}@args:
rec{
    pkgs = extraSpecialArgs.pkgs-stable; # using nixpgs-stable as default (see below)
    extraSpecialArgs = rec{
      system = "aarch64-darwin";
      hostname = "M-PA-LT75QJ7NN7";
      username = "manuelbovo";
      homeDirectory = "${paths.home.${system}}${username}";
      pkgs-stable = inputs.nixpkgs-stable-darwin.legacyPackages.${system};
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      # pdh = inputs.pdhpkg.packages.${system};
      priv-config = inputs.nix-configs-priv;
    };
    modules = [
      inputs.sops-nix.homeManagerModules.sops
      "${extraSpecialArgs.priv-config}/hosts/${extraSpecialArgs.hostname}/nix/custom.nix" 
      ] ++ builtins.attrValues outputs.homeManagerModules;
}