{
  description = "Home Manager configuration";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/24.05";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    sops-nix = { 
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    pdhpkg.url = "github:mbovo/pdh/v0.4.1";
    nix-configs-priv = {
      url = "git+ssh://git@github.com/mbovo/nix-configs-priv";
      flake = false;
    };
  };

  outputs = { home-manager,flake-utils, ... }@inputs:
    let
      # defaults modules for all systems
      mods = {
        common = [ inputs.sops-nix.homeManagerModules.sops ./common/flake.nix ];
        darwin = [ ./common/darwin.nix ./common/docker4mac.nix ];
        linux  = [ ./common/linux.nix ];
      };
      # default paths for all systems
      paths = {
        home = {
          x86_64-darwin = "/Users/";
          aarch64-darwin = "/Users/";
          x86_64-linux = "/home/";
          aarch64-linux = "/home/";
        };
      };
    in
## building dev-shell for all 
    flake-utils.lib.eachDefaultSystem 
      (system:{
        devShells.default = inputs.nixpkgs-stable.legacyPackages.${system}.mkShell {
          packages = with inputs.nixpkgs-stable.legacyPackages.${system}; [
            statix
            go-task
            sops
            nix-output-monitor
          ];
        };
      }
    )
    //
## home-manager configurations
    {
      homeConfigurations = {
        # ==================================================================================================================
        # personal MacOs configuration
        # ==================================================================================================================
        "manuel@mbp" = home-manager.lib.homeManagerConfiguration rec{
          pkgs = extraSpecialArgs.pkgs-stable; # using nixpgs-unstable as default (see below)
          extraSpecialArgs = rec{
            system = "x86_64-darwin";
            username = "manuel"; 
            hostname = "mbp";
            homeDirectory = "${paths.home.${system}}${username}";
            pkgs-stable = inputs.nixpkgs-stable-darwin.legacyPackages.${system};
            pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
            pdh = inputs.pdhpkg.packages.${system};
            priv-config = inputs.nix-configs-priv;
          };
          modules = mods.common ++ mods.darwin ++ [ "${extraSpecialArgs.priv-config}/hosts/${extraSpecialArgs.hostname}/nix/custom.nix" ];
        };
        # ==================================================================================================================

        # ==================================================================================================================
        # work MacOs configuration
        # ==================================================================================================================
        "manuel.bovo@manuel.bovo" = home-manager.lib.homeManagerConfiguration rec{
          pkgs = extraSpecialArgs.pkgs-stable; # using nixpgs-stable as default (see below)
          extraSpecialArgs = rec{
            system = "aarch64-darwin";
            hostname = "manuel.bovo";
            username = "${hostname}";
            homeDirectory = "${paths.home.${system}}${username}";
            pkgs-stable = inputs.nixpkgs-stable-darwin.legacyPackages.${system};
            pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
            pdh = inputs.pdhpkg.packages.${system};
            priv-config = inputs.nix-configs-priv;
          };
          modules = mods.common ++ mods.darwin ++ [ "${extraSpecialArgs.priv-config}/hosts/${extraSpecialArgs.hostname}/nix/custom.nix" ];
        };
        # ==================================================================================================================
      };
    };
}
