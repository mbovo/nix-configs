{
  description = "mbovo home-manager configuration";
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops-nix = { 
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # pdhpkg.url = "github:mbovo/pdh";
    
    nix-configs-priv = {
      #url = "git+ssh://git@github.com/mbovo/nix-configs-priv?ref=main";
      url = "git+file:///Users/manuelbovo/oss/nix-configs-priv";
      flake = false;
    };
  };

  outputs = { home-manager,flake-utils, self, ... }@inputs:
    let inherit (self) outputs; in
    {
      homeManagerModules = import ./modules/home-manager;             # this is to expose modules for external access
      homeConfigurations = import ./hosts {inherit inputs outputs;};  # include all hosts configurations
    }
    //
    flake-utils.lib.eachDefaultSystem                                 # system agnostic dev shell with needed packages 
      (system:{
        devShells.default = inputs.nixpkgs-stable.legacyPackages.${system}.mkShell {
          packages = with inputs.nixpkgs-stable.legacyPackages.${system}; [
            age git gh nh nix-output-monitor sops statix
          ];
        };
      });
}

