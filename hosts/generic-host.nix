{paths, inputs, outputs, system, hostname, username,usepkgs, ...}@args:
rec{
    pkgs = extraSpecialArgs.pkgs-stable; # using nixpgs-stable as default (see below)
    extraSpecialArgs = rec{
      inherit system hostname username;
      homeDirectory = "${paths.home.${system}}${username}";
      pkgs-stable = usepkgs.legacyPackages.${system};
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      # pdh = inputs.pdhpkg.packages.${system};
      priv-config = inputs.nix-configs-priv;
    };
    modules = [
      inputs.sops-nix.homeManagerModules.sops
      "${extraSpecialArgs.priv-config}/hosts/${hostname}" 
      ] ++ builtins.attrValues outputs.homeManagerModules;
}