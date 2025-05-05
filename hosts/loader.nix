{inputs, outputs, self, lib, system, hostname, username, usepkgs, paths, type, ...}@args:
rec{
    pkgs = extraSpecialArgs.pkgs-stable; # using nixpgs-stable as default (see below)
    extraSpecialArgs = rec{
      inherit system hostname username;
      homeDirectory = "${paths.home.${system}}${username}";
      pkgs-stable = usepkgs.legacyPackages.${system};
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      priv-config = inputs.nix-configs-priv;
    };
    modules = builtins.attrValues outputs.homeManagerModules ++ 
      [
        inputs.sops-nix.homeManagerModules.sops                                                 # sops-nix module
        "${self}/hosts/0-type-${type}.nix"                                                      # type (desktop|server ...) configurations  
        "${self}/hosts/1-system-${(lib.lists.last (lib.strings.splitString "-" system))}.nix"   # system specific configurations"
        "${self}/hosts/2-host-${hostname}.nix"                                                  # host specific configurations
        "${extraSpecialArgs.priv-config}/hosts/${hostname}"                                     # host specific private configurations
      ]; 
}