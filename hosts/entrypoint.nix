{inputs, outputs, self, system, hostname, username, usepkgs, paths, ...}@args:
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
    modules = builtins.attrValues outputs.homeManagerModules ++ 
      [
        inputs.sops-nix.homeManagerModules.sops                 # sops-nix module
        "${self}/hosts/${hostname}.nix"                         # host specific configurations
        "${extraSpecialArgs.priv-config}/hosts/${hostname}"     # host specific private configurations
      ]; 
}